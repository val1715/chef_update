# Readme about cookbook "change1"

This is test chef cookbook about changing web server configuration.

_**Start point:**_

### Overview
In order to have a common code base upon which to conduct a technical discussion, we would like for you to complete the following programming assignment before you arrive for your interview.
Please do not spend more than a few hours on this, we value an 80% solution now as opposed to a 100% solution never. Use any language or tools that you desire. We will use this example to get a sense of your problem solving skills, your decomposition skills, and the way that you approach refactoring.

### Problem Description

Assuming you have 2 or more instances running Apache or Nginx, provide a method (prefer Chef but other tools are acceptable) that updates the web server's configuration as well as a dynamic page (such as a Chef ​templated page​) the web server hosts, ensuring only one instance is down at any time. At a minimum, this program should offer the following features:

- Configuration and web page content is maintained  
- Web server is restarted when it’s configuration changes
- Only one instance is down at a time Deliverable

#### Please provide the following:

- A fully implemented and working solution
- Provide full source of your solution in electronic format, preferably in GitHub
- Provide a log of a sample run

======================================================================================

### Cookbook components:

- recipe for installing nginx;
- recipe for updating configuration;
- recipe for updating main page;
- templates for configuration file and main page file;
- attributes for inserting to templates;
- role for update process

If also include powershell script to execute some logic of updating process.

#### Prerequisites:

  Let's assume that we have a group of nodes (web-servers) which configuration we need to change according to the mentioned features. All that nodes linked together by one role, which is placed to run-list of every node.
```
  PS C:\Val_docs\VMs\Chef_files\cookbooks\change1> knife status 'role:web' --run-list
  4 minutes ago, nodetest-ubuntu, ["role[basic_role]", "role[web]"], ubuntu 16.04.
  2 minutes ago, nodetest-centos, ["role[basic_role]", "recipe[web]", "role[web]"], centos 7.4.1708.
```
To receive name of all nodes, which I need to reconfigure, I use powershell command:

```
$nodes = (knife search node 'role:basic_role' | Select-String -Pattern 'Node Name')
$clean = foreach ($node in $nodes) {($node -split ' ')[-1]}
```
As result I have list (powershell array) of node's names:
```
PS C:\Val_docs\VMs\Chef_files\cookbooks\change1> foreach ($node in $clean) { write-host $node}
nodetest-ubuntu
nodetest-centos
```
Then I want to check interval of running base role of such nodes:
```
PS C:\Val_docs\VMs\Chef_files\cookbooks\change1> knife role show basic_role
chef_type:           role
default_attributes:
  chef_client:
    interval: 240
    splay:    20
description:         basic test role.
env_run_lists:
json_class:          Chef::Role
name:                basic_role
override_attributes:
run_list:
  recipe[chef-client::default]
  recipe[chef-client::delete_validation]
  recipe[basic::default]
```

Then I need to edit my cookbook role (*nginx_install.json* file) to set up less time interval than base role of node. Add cookbook role to chef server:

```
PS C:\Val_docs\VMs\Chef_files\cookbooks\change1> knife role from file .\role\nginx_install.json
Updated Role nginx_install
```

Check the cookbook role details:
```
PS C:\Val_docs\VMs\Chef_files\cookbooks\change1> knife role show nginx_install
chef_type:           role
default_attributes:
  chef_client:
    interval: 240
    splay:    10
description:         Role for updating nginx.
env_run_lists:
json_class:          Chef::Role
name:                nginx_install
override_attributes:
run_list:            recipe[change1::default]
```

After that we can add to every node role for updating configuration, but only to one instance in a time using shift=interval. This gives us situation, when configuration will be executed only on one instance at one moment of time.

Using operand `not_if` excludes situation of restarting nginx server after first time update configuration.

To execute it all together i use command on chefDK workstation:
```
$nodes = (knife search node 'role:web' | select-string -Pattern 'Node Name') ; $clean = foreach ($node in $nodes) { ($node -split ' ')[-1] } ; foreach ($node in $clean) {knife node run_list add $node 'role[nginx_install]' ; sleep 240 }
```
The role will be execute on next interval.
After end of this task we can remove used role from the instances:
```
foreach ($node in $clean) {knife node run_list remove $node 'role[nginx_install]'}
```

Log of cookbook execution placed in file `local_log_file.out`

##### Addition 1:

To execute commands on node with some order PUSH method is more convenient. But Chef was not designed to resolve such problems. Nevertheless we can use Chef push jobs (https://docs.chef.io/push_jobs.html) but I think that it is some kind of extra complexity.

##### Addition 2:

No doubt Chef provides good possibilities of changing files and using templates. So do Ansible.
With Ansible execution tasks to nodes on some queue much more easy, because we can use `serial` keyword to control quantity of parallels playbook execution. Details: http://docs.ansible.com/ansible/latest/user_guide/playbooks_delegation.html#rolling-update-batch-size

$all = (knife search node "role:basic_role")

$all2 = $all | Select-String -Pattern "(?<=Node Name:).*"

($all2[1] -split " ")[-1]

$nodes = (knife search node 'role:basic_role' | Select-String -Pattern 'Node Name')
$clean = foreach ($node in $nodes) {($node -split ' ')[-1]}
foreach ($node in $clean) { knife node show $node; sleep 5 }
knife node run_list add n2u14 'role[nginx_install]'


PS C:\Val_docs\VMs\Chef_files\cookbooks\change1> knife role from file .\role\nginx_install.json
Updated Role nginx_install

PS C:\Val_docs\VMs\Chef_files\cookbooks\change1> knife role show nginx_install
chef_type:           role
default_attributes:
  chef_client:
    interval: 180
    splay:    1
description:         Role for updating nginx.
env_run_lists:
json_class:          Chef::Role
name:                nginx_install
override_attributes:
run_list:            recipe[change1::default]

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
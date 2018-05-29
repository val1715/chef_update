#
# Cookbook:: change1
# Recipe:: install_nginx
#
# Copyright:: 2018, The Authors, All Rights Reserved.

Chef::Log.info("Node platform is '#{node['platform']}'")

include_recipe 'apt::default'

if platform_family?('ubuntu')
  # https://github.com/chef-cookbooks/build-essential/issues/41
  # not running update before installing packages
end

if platform_family?('rhel')
  package 'epel-release' do
    action :install
  end
end

package 'nginx' do
  action :install
end

service 'nginx' do
  action %i[start enable]
end

Chef::Log.info('Installing of nginx server is finished')

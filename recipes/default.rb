#
# Cookbook:: change1
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

Chef::Log.info("Node platform is '#{node['platform']}'")

include_recipe "change1::update_server"

include_recipe "change1::update_page"

Chef::Log.info('Updating process is finished')

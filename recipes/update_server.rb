#
# Cookbook:: change1
# Recipe:: update_server
#
# Copyright:: 2018, The Authors, All Rights Reserved.

Chef::Log.info('Start updating process of server')

include_recipe "change1::install_nginx"

template '/etc/nginx/nginx.conf' do
  source 'default.conf.erb'
end

service 'nginx' do
  action :restart
  #only_if { ::File.readlines('/etc/nginx/update_nginx.conf').grep(/already_updated/).empty? }
  # not_if { ::File.exist?('/etc/nginx/update_nginx.conf') }
end

# file '/etc/nginx/update_nginx.conf' do
#   content '###_already_updated_###'
#   action :create
# end

Chef::Log.info('Updating process is finished')

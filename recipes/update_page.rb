#
# Cookbook:: change1
# Recipe:: update_page
#
# Copyright:: 2018, The Authors, All Rights Reserved.

Chef::Log.info('Start updating main page of server')

include_recipe "change1::install_nginx"

template '/usr/share/nginx/html/index.html' do
  source 'default.page.erb'
#  notifies :run, 'execute[change_index_page_in_config]', :immediately
end

service 'nginx' do
  action :restart
  #only_if { ::File.readlines('/usr/share/nginx/update_index.html').grep(/already_updated/).empty? }
  not_if { ::File.exist?('/usr/share/nginx/update_index.html') }
end

file '/usr/share/nginx/update_index.html' do
  content '###_already_updated_###'
  action :create
end

# service 'nginx' do
#   subscribes :reload, 'file[/usr/share/nginx/html/newIndex.html]', :delayed
# end
#
# execute 'change_index_page_in_config' do
#   command 'sed -Ei 's/.*index.*index.*/        index        newIndex.html/g' /etc/nginx/nginx.conf'
#   action :nothing
# end

Chef::Log.info('Process of updating main page is finished')

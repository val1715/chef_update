default['nginx']['conf']['listen_port'] = '8080'
# update SELinux to use other ports :
# https://serverfault.com/questions/566317/nginx-no-permission-to-bind-port-8090-but-it-binds-to-80-and-8080
# semanage port -a -t http_port_t  -p tcp {port number}

default['nginx']['conf']['index_page'] = 'index.html'
default['nginx']['conf']['root_folder'] = '/usr/share/nginx/html'

default['nginx']['page']['header'] = 'This is a BIG HEADER of page.'
default['nginx']['page']['main_body'] = 'This is a main body of web page.'


# all functionality testing in one File

port_t = 39999
header_t = "MY_TEST_HEADER2"

describe package('nginx') do
  it { should be_installed }
end

describe service('nginx') do
  it { should be_running }
end

describe port(port_t) do
  it { should be_listening }
end

describe command('cat /etc/nginx/nginx.conf') do
  its('stdout') { should match /#{port_t}/ }
end

describe command('cat /usr/share/nginx/html/index.html') do
  its('stdout') { should match /MY_TEST_HEADER2/ }
end

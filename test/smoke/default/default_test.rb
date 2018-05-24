
# all functionality testing in one File

describe package('nginx') do
  it { should be_installed }
end

decribe service('nginx') do
  it { should bu_running }
end

describe port(8080) do
  it { should be_listening }
end

describe command('cat /etc/nginx/nginx.conf') do
  its('stdout') { should match /8080/ }
end

describe command('cat /usr/share/nginx/html/index.html') do
  its('stdout') { should match /text 33233/ }
end

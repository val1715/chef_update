#
# Cookbook:: change1
# Spec:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

require 'spec_helper'

shared_examples 'base conditions' do
  it 'converges successfully' do
    expect { chef_run }.to_not raise_error
  end
  it 'installs nginx' do
    expect(chef_run).to install_package 'nginx'
  end
  it 'starts and enables nginx service' do
    expect(chef_run).to enable_service 'nginx'
    expect(chef_run).to start_service 'nginx'
  end
  it 'create file /etc/nginx/nginx.conf' do
    expect(chef_run).to render_file('/etc/nginx/nginx.conf').with_content('8080')
  end
  it 'update file /usr/share/nginx/html/index.html' do
    expect(chef_run).to render_file('/usr/share/nginx/html/index.html').with_content('text 33233')
  end
end

describe 'change1::default' do
  context 'When all attributes are default, on Ubuntu 16.04' do
    let(:chef_run) do
      # for a complete list of available platforms and versions see:
      # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04')
      runner.converge(described_recipe)
    end

    it_behaves_like 'base conditions'
  end # end Ubuntu 16.04 block

  context 'When all attributes are default, on CentOS 7.4.1708' do
    let(:chef_run) do
      # for a complete list of available platforms and versions see:
      # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '7.4.1708')
      runner.converge(described_recipe)
    end

    it_behaves_like 'base conditions'
  end # end of Centos 7.4.1708 block

  context 'Whel all attributes are default, on amazon 2018.03' do
    let(:chef_run) do
      # for a complete list of available platforms and versions see:
      # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
      runner = ChefSpec::ServerRunner.new(platform: 'amazon', version: '2018.03')
      runner.converge(described_recipe)
    end
    
    it_behaves_like 'base conditions'
  end # end of Amazon 2018.03 block

end

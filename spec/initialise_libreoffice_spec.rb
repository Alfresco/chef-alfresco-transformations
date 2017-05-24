require 'spec_helper'

RSpec.describe 'alfresco-transformations::initialise_libreoffice' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'centos',
      version: '7.2.1511',
      file_cache_path: '/var/chef/cache'
    ) do |node|
    end.converge(described_recipe)
  end

  let(:shellout_1) { double('shellout') }
  let(:shellout_0) { double('shellout') }

  before do
    allow(shellout_1).to receive_messages(
      :run_command => nil,
      :error! => nil,
      :live_stream => nil,
      :live_stream= => nil
    )
    allow(shellout_0).to receive_messages(
      :run_command => nil,
      :error! => nil,
      :live_stream => nil,
      :live_stream= => nil
    )
    allow(shellout_1).to receive(:exitstatus).and_return(1)
    allow(shellout_0).to receive(:exitstatus).and_return(0)
  end

  it 'should not run_initialise_libreoffice by default' do
    expect(chef_run).not_to run_initialise_libreoffice('initialise')
  end

  it 'should run_initialise_libreoffice if enabled, lo is installed and not running' do
    allow(Mixlib::ShellOut).to receive(:new).with('pgrep -f soffice.bin', anything).and_return(shellout_1)
    allow(Mixlib::ShellOut).to receive(:new).with('whereis -b libreoffice | cut -d\':\' -f2 | grep libreoffice', anything).and_return(shellout_0)
    chef_run.node.normal['transformations']['libreoffice']['initialise']['enabled'] = true
    chef_run.converge(described_recipe)
    expect(chef_run).to run_initialise_libreoffice('initialise')
  end

  it 'should not run_initialise_libreoffice if enabled, lo is installed and is running' do
    allow(Chef::Mixin::ShellOut).to receive(:new).with('pgrep -f soffice.bin', anything).and_return(shellout_0)
    allow(Chef::Mixin::ShellOut).to receive(:new).with('whereis -b libreoffice | cut -d\':\' -f2 | grep libreoffice', anything).and_return(shellout_0)
    chef_run.node.normal['transformations']['libreoffice']['initialise']['enabled'] = true
    chef_run.converge(described_recipe)
    expect(chef_run).not_to run_initialise_libreoffice('initialise')
  end

  it 'should not run_initialise_libreoffice if enabled, lo is not installed' do
    allow(Chef::Mixin::ShellOut).to receive(:new).with('whereis -b libreoffice | cut -d\':\' -f2 | grep libreoffice', anything).and_return(shellout_1)
    chef_run.node.normal['transformations']['libreoffice']['initialise']['enabled'] = true
    chef_run.converge(described_recipe)
    expect(chef_run).not_to run_initialise_libreoffice('initialise')
  end
end

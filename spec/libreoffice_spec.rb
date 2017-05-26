require 'spec_helper'

RSpec.describe 'alfresco-transformations::libreoffice' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'centos',
      version: '7.2.1511',
      file_cache_path: '/var/chef/cache'
    ) do |node|
    end.converge(described_recipe)
  end

  before do
    stub_command('yum list installed | grep libreoffice').and_return(false)
  end

  it 'should create libreoffice user' do
    expect(chef_run).to create_user('libreoffice').with(shell: '/sbin/nologin')
  end

  it 'should create tomcat user' do
    expect(chef_run).to create_user('tomcat')
  end

  it 'should manage tomcat group' do
    expect(chef_run).to manage_group('tomcat').with(members: ['libreoffice'])
  end

  it 'should extract libreoffice tar' do
    chef_run.node.normal['transformations']['libreoffice']['tar']['name'] = 'libreoffice.tar.gz'
    chef_run.node.normal['transformations']['libreoffice']['name'] = 'libreoffice'
    chef_run.node.normal['transformations']['libreoffice']['tar']['url'] = 'http://libreofficeurl'
    chef_run.converge(described_recipe)
    expect(chef_run).to extract_tar_extract('http://libreofficeurl').with(
      target_dir: '/var/chef/cache',
      creates: '/var/chef/cache/libreoffice'
    )
  end

  it 'should run command install-libreoffice' do
    chef_run.node.normal['transformations']['libreoffice']['name'] = 'libreoffice'
    chef_run.converge(described_recipe)
    expect(chef_run).to run_execute('install-libreoffice').with(
      command: 'yum -y localinstall /var/chef/cache/libreoffice/RPMS/*.rpm'
    )
  end

  it 'should create transient_variable libreoffice_path' do
    expect(chef_run).to create_transient_variable('libreoffice_path')
  end

  it 'should run file_rename' do
    chef_run.node.run_state['libreoffice_path'] = '/opt/libreoffice'
    chef_run.converge(described_recipe)
    expect(chef_run).to create_file_rename('soffice.bin to .soffice.bin rename').with(
      old_value: '/opt/libreoffice/program/soffice.bin',
      new_value: '/opt/libreoffice/program/.soffice.bin'
    )
  end

  it 'should create soffice.bin template' do
    chef_run.node.run_state['libreoffice_path'] = '/opt/libreoffice'
    chef_run.converge(described_recipe)
    expect(chef_run).to create_template('soffice.bin template').with(
      path: '/opt/libreoffice/program/soffice.bin',
      source: 'soffice.bin.erb',
      owner: 'libreoffice',
      group: 'tomcat',
      mode: 00755,
      variables: { lo_user: 'libreoffice', lo_path: '/opt/libreoffice' }
    )
  end

  it 'should create libreoffice_temp_folder' do
    expect(chef_run).to create_directory('/usr/share/tomcat/alfresco/temp').with(
      recursive: true,
      owner: 'tomcat',
      mode: 02775
    )
  end

  it 'should run change_own_mod' do
    chef_run.node.run_state['libreoffice_path'] = '/opt/libreoffice'
    chef_run.converge(described_recipe)
    expect(chef_run).to run_change_own_mod('libreoffice').with(
      source: '/opt/libreoffice',
      mode: '755',
      user: 'libreoffice',
      group: 'tomcat',
      recursive: true
    )
  end

  it 'should add tomcat sudoer user' do
    chef_run.node.run_state['libreoffice_path'] = '/opt/libreoffice'
    chef_run.converge(described_recipe)
    expect(chef_run).to install_sudo('libreoffice').with(
      user: 'tomcat',
      runas: 'libreoffice',
      commands: ['/opt/libreoffice/program/.soffice.bin'],
      nopasswd: true
    )
  end

  it 'should create link to libreoffice' do
    chef_run.node.run_state['libreoffice_path'] = '/opt/libreoffice5.2'
    chef_run.converge(described_recipe)
    expect(chef_run).to create_link('linking Libreoffice').with(
      to: '/opt/libreoffice5.2',
      target_file: '/opt/libreoffice',
      owner: 'libreoffice',
      group: 'tomcat',
      mode: 00755
    )
  end
end

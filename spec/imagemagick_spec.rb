require 'spec_helper'

RSpec.describe 'alfresco-transformations::imagemagick' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'centos',
      version: '7.2.1511',
      file_cache_path: '/var/chef/cache'
    ) do |node|
    end.converge(described_recipe)
  end

  before do
  end

  it 'should not include imagemagick::default recipe by default' do
    expect(chef_run).not_to include_recipe('imagemagick::default')
  end

  it 'should download imagemagick libs' do
    chef_run.node.normal['transformations']['imagemagick']['libs']['name'] = 'imagemagick-libs-name.tar.gz'
    chef_run.converge(described_recipe)
    expect(chef_run).to create_remote_file('/var/chef/cache/imagemagick-libs-name.tar.gz').with(retries: 2)
  end

  it 'should install imagemagick libs' do
    chef_run.node.normal['transformations']['imagemagick']['libs']['name'] = 'imagemagick-libs-name.tar.gz'
    chef_run.converge(described_recipe)
    expect(chef_run).to install_yum_package('/var/chef/cache/imagemagick-libs-name.tar.gz').with(retries: 2)
  end

  it 'should download imagemagick' do
    chef_run.node.normal['transformations']['imagemagick']['name'] = 'imagemagick-name.tar.gz'
    chef_run.converge(described_recipe)
    expect(chef_run).to create_remote_file('/var/chef/cache/imagemagick-name.tar.gz').with(retries: 2)
  end

  it 'should install imagemagick libs' do
    chef_run.node.normal['transformations']['imagemagick']['name'] = 'imagemagick-name.tar.gz'
    chef_run.converge(described_recipe)
    expect(chef_run).to install_yum_package('/var/chef/cache/imagemagick-name.tar.gz').with(retries: 2)
  end

  it 'should run get ImageMagick path ruby block' do
    expect(chef_run).to run_ruby_block('get ImageMagick path')
  end

  %w(config modules).each do |folder|
    it "should create a link to the #{folder} folder " do
      expect(chef_run).to create_link("linking ImageMagick #{folder}").with(
        target_file: "/usr/lib64/ImageMagick-#{folder}",
        owner: 'root',
        group: 'root',
        mode: 00755
      )
    end
  end
end

require 'spec_helper'

RSpec.describe 'alfresco-transformations::exiftool' do
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

  it 'should install package perl-Image-ExifTool' do
    expect(chef_run).to install_package('perl-Image-ExifTool')
  end
end

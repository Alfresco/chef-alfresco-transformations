require 'spec_helper'

RSpec.describe 'alfresco-transformations::fonts' do
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

  it 'should run install-all-fonts command' do
    expect(chef_run).to run_execute('yum install -y *fonts.noarch --exclude=\'tv-fonts chkfontpath pagul-fonts\*\'')
  end
end

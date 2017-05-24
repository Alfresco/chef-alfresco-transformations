require 'spec_helper'

RSpec.describe 'alfresco-transformations::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'centos',
      version: '7.2.1511',
      file_cache_path: '/var/chef/cache'
    ) do |node|
    end.converge(described_recipe)
  end

  before do
    stub_command('yum list installed | grep libreoffice').and_return('')
  end

  %w(alfresco-transformations::libreoffice alfresco-transformations::imagemagick alfresco-transformations::exiftool).each do |recipe|
    it "should include #{recipe} as default recipe" do
      expect(chef_run).to include_recipe(recipe)
    end
  end

  %w(ffmpeg::default swftools::default alfresco-transformations::fonts alfresco-transformations::swftools).each do |recipe|
    it "should not include #{recipe} recipe by default" do
      expect(chef_run).not_to include_recipe(recipe)
    end
  end
end

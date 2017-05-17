#
# Cookbook:: chef-alfresco-transformations
# Recipe:: default
#
# Copyright:: 2017, Alfresco softare ltd, All Rights Reserved.

include_recipe 'alfresco-transformations::libreoffice'
include_recipe 'ffmpeg::default' if node['platform_family'] == 'ubuntu'
include_recipe 'swftools::default' if node['platform_family'] == 'ubuntu'
include_recipe 'alfresco-transformations::fonts' if node['transformations']['install_fonts']
include_recipe 'alfresco-transformations::swftools' if node['transformations']['install_swftools']
include_recipe 'alfresco-transformations::imagemagick' if node['transformations']['install_imagemagick']
include_recipe 'alfresco-transformations::exiftool'

initialise_libreoffice 'initialise' do
  only_if { node['transformations']['libreoffice']['initialise']['enabled'] }
end

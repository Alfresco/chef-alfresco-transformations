#
# Cookbook:: chef-alfresco-transformations
# Recipe:: default
#
# Copyright:: 2017, Alfresco softare ltd, All Rights Reserved.

include_recipe 'alfresco-transformations::libreoffice' if node['transformations']['install_libreoffice']
include_recipe 'ffmpeg::default' if node['platform_family'] == 'ubuntu'
include_recipe 'swftools::default' if node['platform_family'] == 'ubuntu' && node['transformations']['install_swftools']
include_recipe 'alfresco-transformations::fonts' if node['transformations']['install_fonts']
include_recipe 'alfresco-transformations::imagemagick' if node['transformations']['install_imagemagick']
include_recipe 'alfresco-transformations::exiftool'

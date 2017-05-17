imagemagick_path = "#{Chef::Config[:file_cache_path]}/#{node['transformations']['imagemagick']['name']}"
imagemagick_libs_path = "#{Chef::Config[:file_cache_path]}/#{node['transformations']['imagemagick']['libs']['name']}"
use_im_os_repo = node['transformations']['imagemagick']['use_im_os_repo']

# Imagemagick OS repo installation
include_recipe 'imagemagick::default' if use_im_os_repo

remote_file imagemagick_libs_path do
  source node['transformations']['imagemagick']['libs']['url']
  not_if { use_im_os_repo }
  retries 2
end

yum_package imagemagick_libs_path do
  source imagemagick_libs_path
  not_if { use_im_os_repo }
  retries 2
end

remote_file imagemagick_path do
  source node['transformations']['imagemagick']['url']
  not_if { use_im_os_repo }
  retries 2
end

yum_package imagemagick_path do
  source imagemagick_path
  not_if { use_im_os_repo }
  retries 2
end

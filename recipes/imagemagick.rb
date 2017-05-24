imagemagick_path = "#{Chef::Config[:file_cache_path]}/#{node['transformations']['imagemagick']['name']}"
imagemagick_libs_path = "#{Chef::Config[:file_cache_path]}/#{node['transformations']['imagemagick']['libs']['name']}"
use_im_os_repo = node['transformations']['imagemagick']['use_im_os_repo']

# Imagemagick dependencies
node['transformations']['imagemagick']['extra_dependencies'].each do |package|
  package package do
    action :install
  end
end

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

ruby_block 'get ImageMagick path' do
  block do
    node.run_state['im_path'] = "/usr/lib64/ImageMagick-#{rpm_version('ImageMagick')}"
    Chef::Log.info("ImageMagick path: #{node.run_state['im_path']}")
  end
end

%w(config modules).each do |folder|
  target = node['transformations']['imagemagick']["link_#{folder}"]
  link "linking ImageMagick #{folder}" do
    to lazy { folders_name(node.run_state['im_path'], folder) }
    target_file target
    owner 'root'
    group 'root'
    mode 00755
    not_if { target.to_s.empty? }
  end
end

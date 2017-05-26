libreoffice_user = node['transformations']['libreoffice']['libreoffice_user']
tomcat_user = node['transformations']['libreoffice']['tomcat_user']
libre_office_name = node['transformations']['libreoffice']['name']
libre_office_tar_url = node['transformations']['libreoffice']['tar']['url']
libreoffice_temp_folder = node['transformations']['libreoffice']['temp_folder']
link_directory = node['transformations']['libreoffice']['link_directory']

user tomcat_user

user libreoffice_user do
  shell '/sbin/nologin'
end

group tomcat_user do
  members [libreoffice_user]
  action :manage
end

tar_extract libre_office_tar_url do
  target_dir Chef::Config[:file_cache_path]
  creates "#{Chef::Config[:file_cache_path]}/#{libre_office_name}"
end

execute 'install-libreoffice' do
  command "yum -y localinstall #{Chef::Config[:file_cache_path]}/#{libre_office_name}/RPMS/*.rpm"
  not_if 'yum list installed | grep libreoffice'
end

transient_variable 'libreoffice_path' do
  variable_value lazy { libre_office_path }
end

file_rename 'soffice.bin to .soffice.bin rename' do
  old_value lazy { "#{node.run_state['libreoffice_path']}/program/soffice.bin" }
  new_value lazy { "#{node.run_state['libreoffice_path']}/program/.soffice.bin" }
end

template 'soffice.bin template' do
  path lazy { "#{node.run_state['libreoffice_path']}/program/soffice.bin" }
  source 'soffice.bin.erb'
  owner libreoffice_user
  group tomcat_user
  mode 00755
  variables lazy {
              {
                lo_user: libreoffice_user,
                lo_path: node.run_state['libreoffice_path'],
              } }
end

directory libreoffice_temp_folder do
  recursive true
  action :create
  owner tomcat_user
  group tomcat_user
  mode 02775
end

change_own_mod 'libreoffice' do
  source lazy { node.run_state['libreoffice_path'] }
  mode '755'
  user libreoffice_user
  group tomcat_user
  recursive true
end

sudo 'libreoffice' do
  user      tomcat_user
  runas     libreoffice_user
  commands  lazy { ["#{node.run_state['libreoffice_path']}/program/.soffice.bin"] }
  nopasswd true
end

link 'linking Libreoffice' do
  to lazy { node.run_state['libreoffice_path'] }
  target_file link_directory
  owner libreoffice_user
  group tomcat_user
  mode 00755
  action :create
end

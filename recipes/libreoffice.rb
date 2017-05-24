libreoffice_user = node['transformations']['libreoffice']['libreoffice_user']
tomcat_user = node['transformations']['libreoffice']['tomcat_user']
libre_office_name = node['transformations']['libreoffice']['name']
libre_office_tar_name = node['transformations']['libreoffice']['tar']['name']
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

remote_file "#{Chef::Config[:file_cache_path]}/#{libre_office_tar_name}" do
  source libre_office_tar_url
  owner libreoffice_user
  group libreoffice_user
  retries 2
end

execute 'unpack-libreoffice' do
  cwd Chef::Config[:file_cache_path]
  command "tar -xf #{libre_office_tar_name}"
  creates "#{Chef::Config[:file_cache_path]}/#{libre_office_name}"
end

execute 'install-libreoffice' do
  command "yum -y localinstall #{Chef::Config[:file_cache_path]}/#{libre_office_name}/RPMS/*.rpm"
  not_if 'yum list installed | grep libreoffice'
end

ruby_block 'get LibreOffice installation Path' do
  block do
    node.run_state['libreoffice_path'] = libre_office_path
  end
end

ruby_block 'soffice.bin rename' do
  block do
    path = node.run_state['libreoffice_path']
    unless File.exist?("#{path}/program/.soffice.bin")
      File.rename("#{path}/program/soffice.bin", "#{path}/program/.soffice.bin")
    end
  end
end

template 'soffice.bin template' do
  path lazy { "#{node.run_state['libreoffice_path']}/program/soffice.bin" }
  source 'soffice.bin.erb'
  owner libreoffice_user
  group libreoffice_user
  mode 00700
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
  mode 02755
end

execute 'change-libreoffice-permissions' do
  command lazy {
    <<-EOF
      chown #{libreoffice_user}:#{tomcat_user} -R #{node.run_state['libreoffice_path']}
      chmod -R 00755 #{node.run_state['libreoffice_path']}
      EOF
  }
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

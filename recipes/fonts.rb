execute 'install-all-fonts' do
  command "yum install -y *fonts.noarch --exclude='#{node['transformations']['fonts']['exclude_font_packages']}'"
  only_if { node['platform_family'] == 'rhel' }
end

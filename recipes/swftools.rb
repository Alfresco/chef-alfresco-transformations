# Taken from https://www.centos.org/forums/viewtopic.php?f=48&t=50232
bash 'install_swftools' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  yum install -y wget zlib zlib-devel freetype-devel jpeglib-devel giflib-devel libjpeg-turbo-devel
  wget http://www.swftools.org/swftools-2013-04-09-1007.tar.gz -O swftools-2013-04-09-1007.tar.gz
  tar -zvxf swftools-2013-04-09-1007.tar.gz
  cd swftools-2013-04-09-1007
  ./configure --libdir=/usr/lib64 --bindir=/usr/local/bin
  make && make install
  EOH
  not_if { ::File.exist?('/usr/local/bin/pdf2swf') }
  only_if { node['platform_family'] == 'rhel' }
end

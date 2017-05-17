# LibreOffice
default['transformations']['libreoffice']['version'] = '5.2.1.2'
default['transformations']['libreoffice']['name'] = lazy { "LibreOffice_#{node['transformations']['libreoffice']['version']}_Linux_x86-64_rpm" }
default['transformations']['libreoffice']['tar']['name'] = lazy { "#{node['transformations']['libreoffice']['name']}.tar.gz" }
default['transformations']['libreoffice']['tar']['url'] = lazy { "https://downloadarchive.documentfoundation.org/libreoffice/old/#{node['transformations']['libreoffice']['version']}/rpm/x86_64/#{node['transformations']['libreoffice']['tar']['name']}" }
default['transformations']['libreoffice']['libreoffice_user'] = 'libreoffice'
default['transformations']['libreoffice']['temp_folder'] = '/usr/share/tomcat/alfresco/temp'
default['transformations']['libreoffice']['tomcat_user'] = 'tomcat'

# LibreOffice initialise
default['transformations']['libreoffice']['jodconverter']['portNumbers'] = '8101'
default['transformations']['libreoffice']['initialise']['enabled'] = false
default['transformations']['libreoffice']['initialise']['command']['host'] = '127.0.0.1'
default['transformations']['libreoffice']['initialise']['command']['accept'] = lazy { "\"--accept=socket,host=#{node['transformations']['libreoffice']['initialise']['command']['host']},port=#{node['transformations']['libreoffice']['jodconverter']['portNumbers']};urp;\"" }
default['transformations']['libreoffice']['initialise']['command']['user_installation_path'] = lazy { "#{node['transformations']['libreoffice']['temp_folder']}/.jodconverter_socket_host-#{node['transformations']['libreoffice']['initialise']['command']['host']}_port-#{node['transformations']['libreoffice']['jodconverter']['portNumbers']}" }
default['transformations']['libreoffice']['initialise']['command']['env'] = lazy { "-env:UserInstallation=file://#{node['transformations']['libreoffice']['initialise']['command']['user_installation_path']}" }
default['transformations']['libreoffice']['initialise']['command']['params'] = '--headless --nocrashreport --nodefault --nofirststartwizard --nolockcheck --nologo --norestore'
default['transformations']['libreoffice']['initialise']['command']['full'] = lazy { "#{node['transformations']['libreoffice']['initialise']['command']['accept']} #{node['transformations']['libreoffice']['initialise']['command']['env']} #{node['transformations']['libreoffice']['initialise']['command']['params']}" }

# Fonts
default['transformations']['fonts']['exclude_font_packages'] = 'tv-fonts chkfontpath pagul-fonts\*'

# ImageMagick
default['transformations']['imagemagick']['version'] = '6.9.1-10'
default['transformations']['imagemagick']['use_im_os_repo'] = false
default['transformations']['imagemagick']['libs']['name'] = lazy { "ImageMagick-libs-#{node['transformations']['imagemagick']['version']}.x86_64.rpm" }
default['transformations']['imagemagick']['libs']['url'] = lazy { "ftp://ftp.icm.edu.pl/vol/rzm4/ImageMagick/linux/CentOS/x86_64/#{node['transformations']['imagemagick']['libs']['name']}" }
default['transformations']['imagemagick']['name'] = lazy { "ImageMagick-#{node['transformations']['imagemagick']['version']}.x86_64.rpm" }
default['transformations']['imagemagick']['url'] = lazy { "ftp://ftp.icm.edu.pl/vol/rzm4/ImageMagick/linux/CentOS/x86_64/#{node['transformations']['imagemagick']['name']}" }

# transformations installation
default['transformations']['install_fonts'] = false
default['transformations']['install_swftools'] = false
default['transformations']['install_imagemagick'] = true

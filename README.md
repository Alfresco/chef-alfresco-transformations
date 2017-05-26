# chef-alfresco-transformations cookbook
[![Build Status](https://travis-ci.org/Alfresco/chef-alfresco-transformations.svg)](https://travis-ci.org/Alfresco/chef-alfresco-transformations?branch=master)
[![Cookbook Version](http://img.shields.io/cookbook/v/alfresco-tranformations.svg)](https://github.com/Alfresco/chef-alfresco-transformations)
[![Coverage Status](https://coveralls.io/repos/github/Alfresco/chef-alfresco-transformations/badge.svg?branch=master)](https://coveralls.io/github/Alfresco/chef-alfresco-transformations?branch=master)

This cookbook will install the transformations part of the Alfresco stack.

## Requirements

### Cookbooks

The following cookbooks are direct dependencies because they're used for common "default" functionality.

- [`imagemagick`](https://github.com/someara/imagemagick) for ImageMagick installation
- [`poise-derived`](https://github.com/poise/poise-derived) for defining lazily evaluated node attributes
- [`swftools`](https://github.com/fnichol/chef-swftools) Chef cookbook to install SWFTools: utilities for working with Adobe Flash files (SWF files)
- [`ffmpeg`](https://github.com/djoos-cookbooks/ffmpeg) Installs and configures FFMPEG from source or package
- [`alfresco-utils`](https://github.com/Alfresco/chef-alfresco-utils) Chef utilities used by Chef-Alfresco
- [`sudo`](https://github.com/chef-cookbooks/sudo) Development repository for sudo cookbook

### Platforms

The following platforms are supported and tested with Test Kitchen:

- CentOS 7+

### Chef

- Chef 12.1+

## Attributes

| Key | Type | Description | Default |
|-----|------|-------------|---------|
| default['transformations']['libreoffice']['version'] | String | Libreoffice Version | 5.2.1.2  |
| default['transformations']['libreoffice']['name'] | String | rpm name for Libreoffice | LibreOffice_5.2.1.2_Linux_x86-64_rpm |
| default['transformations']['libreoffice']['tar']['name'] | String | Tar Name for LibreOffice | LibreOffice_5.2.1.2_Linux_x86-64_rpm.tar.gz |
| default['transformations']['libreoffice']['tar']['url']  | String | Tar Name to download LibreOffice |  https://downloadarchive.documentfoundation.org/libreoffice/old/5.2.1.2/rpm/x86_64/LibreOffice_5.2.1.2_Linux_x86-64_rpm.tar.gz |
| default['transformations']['libreoffice']['libreoffice_user'] | String | Libreoffice User |  libreoffice |
| default['transformations']['libreoffice']['temp_folder'] | String  |  Folder to store user configuration for Libreoffice |  /usr/share/tomcat/alfresco/temp |
| default['transformations']['libreoffice']['tomcat_user'] | String  | Tomcat user (running soffice.bin) | tomcat |
| default['transformations']['libreoffice']['link_directory'] | String  | Symlink to libreoffice | /opt/libreoffice |
| default['transformations']['libreoffice']['jodconverter']['portNumbers']  | String  | jodconverter port number |  8101 |
| default['transformations']['libreoffice']['initialise']['enabled']  | Boolean  | Enable/disable LibreOffice Initialisation |  false |
| default['transformations']['libreoffice']['initialise']['command']['host'] | String | Host | 127.0.0.1
| default['transformations']['libreoffice']['initialise']['command']['accept'] | String | Accept params | --accept=socket,host=127.0.0.1,port=8101;urp;StarOffice.ServiceManager
| default['transformations']['libreoffice']['initialise']['command']['user_installation_path'] | String | User Istallation Path | /usr/share/tomcat/alfresco/temp/.jodconverter_socket_host-127.0.0.1_port-8101
| default['transformations']['libreoffice']['initialise']['command']['env'] | String | Env Parameters | -env:UserInstallation=file:///usr/share/tomcat/alfresco/temp/.jodconverter_socket_host-127.0.0.1_port-8101
| default['transformations']['libreoffice']['initialise']['command']['params'] | String | Additional Params | --headless --nocrashreport --nodefault --nofirststartwizard --nolockcheck --nologo --norestore
| default['transformations']['libreoffice']['initialise']['command']['full'] | String | Full Command | "--accept=socket,host=127.0.0.1,port=8101;urp;StarOffice.ServiceManager" -env:UserInstallation=file:///usr/share/tomcat/alfresco/temp/.jodconverter_socket_host-127.0.0.1_port-8101 --headless --nocrashreport --nodefault --nofirststartwizard --nolockcheck --nologo —norestore
| default['transformations']['fonts']['exclude_font_packages'] | String | Font Packages to exclude use_im_os_repo = false | tv-fonts chkfontpath pagul-fonts\*
| default['transformations']['imagemagick']['version'] | String | ImageMagick version (This will work just with ) |  '7.0.5-6'
| default['transformations']['imagemagick']['use_im_os_repo'] | Boolean | Use ImageMagick from OS repo | false
| default['transformations']['imagemagick']['libs']['name'] | String | ImageMagick libs rpm name | ImageMagick-libs-6.9.1-10.x86_64.rpm
| default['transformations']['imagemagick']['libs']['url'] | String | ImageMagick libs rpm url | ftp://ftp.icm.edu.pl/vol/rzm4/ImageMagick/linux/CentOS/x86_64/ImageMagick-libs-6.9.1-10.x86_64.rpm
| default['transformations']['imagemagick']['name'] | String | ImageMagick rpm name | ImageMagick-6.9.1-10.x86_64.rpm
| default['transformations']['imagemagick']['url'] | String | ImageMagick rpm url | ftp://ftp.icm.edu.pl/vol/rzm4/ImageMagick/linux/CentOS/x86_64/ImageMagick-6.9.1-10.x86_64.rpm
| default['transformations']['imagemagick']['link_config'] | String | Symlink to ImageMagick config folder | /usr/lib64/ImageMagick-config
| default['transformations']['imagemagick']['link_modules'] | String | Symlink to ImageMagick modules folder| /usr/lib64/ImageMagick-modules
| default['transformations']['imagemagick']['extra_dependencies'] | Array | <empty>
| default['transformations']['install_fonts'] | Boolean | Install fonts? | false
| default['transformations']['install_libreoffice'] | Boolean | Install LibreOffice? | true
| default['transformations']['install_imagemagick'] | Boolean | Install ImageMagick? | true


## Usage

Just add the reference of this cookbook inside your `metadata.rb` file:

```
depends 'alfresco-tranformations', '~> v0.1'
```

Main recipe is:

- `alfresco-tranformations::default` will install the transformations part of Alfresco
Include `alfresco-tranformations` in your node `run_list`:

```json
{
  "run_list": [
    "recipe[alfresco-tranformations:default]"
  ]
}
```

# Resources

`initialise_libreoffice`: resource to initalise Libreoffice and verify it works correctly. It is mainly used within EC2 instances with AMI pre-baked with LibreOffice

**properties:**

`version` String, default: lazy { node['transformations']['libreoffice']['version'] }

`initialise_command` String, default: lazy { node['transformations']['libreoffice']['initialise']['command']['full'] }

`run_user` String, default: lazy { node['transformations']['libreoffice']['tomcat_user'] }

`user_installation_path` String, default: lazy { node['transformations']['libreoffice']['initialise']['command']['user_installation_path'] }

`lo_installation_path` String, default: lazy { libre_office_path }

example:

```
initialise_libreoffice 'initialise' do
  only_if { node['transformations']['libreoffice']['initialise']['enabled'] }
  not_if {  shell_out('pgrep -f soffice.bin').exitstatus == 0 }
  only_if { shell_out('whereis -b libreoffice | cut -d\':\' -f2 | grep libreoffice').exitstatus == 0 }
end
```

## Testing
Refer to: [Testing](./TESTING.md)
## License and Authors

- Author:: Marco Mancuso (<marco.mancuso@alfresco.com>)

```text
Copyright 2017, Alfresco

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
```

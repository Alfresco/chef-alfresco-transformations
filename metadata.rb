name 'alfresco-transformations'
maintainer 'Alfresco Tooling and Automation Team'
maintainer_email 'devops@alfresco.com'
license 'Apache 2.0'
description 'Installs/Configures chef-alfresco-transformations'
long_description 'Installs/Configures chef-alfresco-transformations'
version '1.0'

chef_version '~> 12' if respond_to?(:chef_version)

issues_url 'https://github.com/Alfresco/chef-alfresco-transformations/issues' if respond_to?(:issues_url)
source_url 'https://github.com/Alfresco/chef-alfresco-transformations' if respond_to?(:source_url)

supports 'centos', '>= 7.0'

depends 'imagemagick', '>= 0.2.3'
depends 'swftools', '>= 0.2.4'
depends 'ffmpeg', '>= 0.4.4'
depends 'poise-derived', '~> 1.0.0'
depends 'alfresco-utils', '~> 1.2.0'
depends 'sudo', '~> 3.4.0'
depends 'tar', '~> 2.0.0'

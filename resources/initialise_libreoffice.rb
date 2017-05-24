# This resource is meant to be used by AWS instances using AMIs with prebaked LibreOffice

actions :run
default_action :run

resource_name :initialise_libreoffice

property :version, String, default: lazy { node['transformations']['libreoffice']['version'] }
property :initialise_command, String, default: lazy { node['transformations']['libreoffice']['initialise']['command']['full'] }
property :run_user, String, default: lazy { node['transformations']['libreoffice']['tomcat_user'] }
property :user_installation_path, String, default: lazy { node['transformations']['libreoffice']['initialise']['command']['user_installation_path'] }
property :lo_installation_path, String, default: lazy { libre_office_path }

action :run do
  execute 'start_libreoffice' do
    command lazy { "#{lo_installation_path}/program/soffice.bin #{initialise_command}" }
    user run_user
    returns 81
    creates user_installation_path
    notifies :delete, "directory[#{user_installation_path}]", :immediately
    ignore_failure true
  end

  directory user_installation_path do
    recursive true
    action :nothing
    user run_user
  end
end

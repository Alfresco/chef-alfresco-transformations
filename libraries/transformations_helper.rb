module TransformationHelper
  include Chef::Mixin::ShellOut

  # def libre_office_path(version)
  #   if node['platform_family'] == 'rhel'
  #     used_version = version.split('.')[0..1].join('.')
  #     lo_path_cmd = shell_out("rpm -ql libreoffice#{used_version} | head -1")
  #     lo_path_cmd.stdout.to_s.strip!
  #   else
  #     raise 'N/A for this OS'
  #   end
  # end

  def get_rpm_version(rpm_name)
    shell_out("rpm -qa --queryformat \"%{VERSION}\" #{rpm_name}").stdout.to_s.strip!
  end

  def libre_office_path
    full_path = shell_out('whereis -b libreoffice | xargs readlink -z').stdout.to_s.strip!
    full_path_array = full_path.split('/')
    index = full_path_array.index { |s| s.include?('libreoffice') }
    full_path_array[0..index].join('/')
  end
end

Chef::Recipe.send(:include, TransformationHelper)
Chef::Resource.send(:include, TransformationHelper)

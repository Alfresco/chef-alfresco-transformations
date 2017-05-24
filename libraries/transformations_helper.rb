module TransformationHelper
  include Chef::Mixin::ShellOut

  def rpm_version(rpm_name)
    Chef::Log.info("TransformationHelper::rpm_version rpm_name: #{rpm_name}")
    version = shell_out!("rpm -qa --queryformat \"%{VERSION}\" #{rpm_name}").stdout.to_s.strip
    split = version.split('.')
    version = split[0..2].join('.') if split.length > 3
    Chef::Log.info("TransformationHelper::rpm_version result: #{version}")
    version
  end

  def libre_office_path
    full_path = shell_out('whereis -b libreoffice | xargs readlink -z').stdout.to_s.strip
    raise 'Libreoffice Not Installed' if full_path.to_s.empty?
    full_path_array = full_path.split('/')
    index = full_path_array.index { |s| s.include?('libreoffice') }
    result = full_path_array[0..index].join('/')
    Chef::Log.info("TransformationHelper::libre_office_path result: #{result}")
    result
  end

  def folders_name(path, folder)
    Chef::Log.info("TransformationHelper::folders_name path: #{path}, folder: #{folder}")
    result = shell_out!("find #{path} -maxdepth 1 -type d -iname '#{folder}*'").stdout.to_s.strip
    Chef::Log.info("TransformationHelper::folders_name result: #{result}")
    result
  end
end

Chef::Recipe.send(:include, TransformationHelper)
Chef::Resource.send(:include, TransformationHelper)

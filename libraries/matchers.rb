if defined?(ChefSpec)
  ChefSpec.define_matcher :initialise_libreoffice

  def run_initialise_libreoffice(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:initialise_libreoffice, :run, resource_name)
  end

end

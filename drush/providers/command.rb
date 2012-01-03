action :run do
  drush_cmd = "drush #{new_resource.command} "
  drush_args = new_resource.args || []
  drush_options = new_resource.options || []
  if new_resource.site_alias
    drush_cmd += "@#{new_resource.site_alias} "
  end
  if new_resource.site_uri
    drush_options.push("--uri=#{new_resource.site_uri}")
  end
  if new_resource.site_dir
    drush_options.push("--destination=#{new_resource.site_dir}")
  end
  if new_resource.quiet
    drush_options.push("-q")
  end
  if new_resource.default_yes
    drush_options.push("-y")
  end
  if new_resource.args
    new_resource.args.each do |arg|
      drush_args.push(arg)
    end
  end
  if new_resource.options
    drush_cmd += "#{new_resource.options.join(' ')} "
  end
  args = drush_args.join(" ")
  options = drush_options.join(" ")
  execute "#{drush_cmd} #{args} #{options}" do
    command "#{drush_cmd}"
  end
end

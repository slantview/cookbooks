action :run do
  drush_cmd = "drush #{new_resource.command} "
  if new_resource.site_alias
    drush_cmd += "@#{new_resource.site_alias} "
  end
  if new_resource.site_uri
    new_resource.options.push("--uri=#{new_resource.site_uri}")
  end
  if new_resource.site_dir
    new_resource.options.push("--destination=#{new_resource.site_dir}")
  end
  if new_resource.quiet
    new_resource.options.push("-q")
  end
  if new_resource.default_yes
    new_resource.options.push("-y")
  end
  if new_resource.args
    drush_cmd += "#{new_resource.args.join(' ')} "
  end
  if new_resource.options
    drush_cmd += "#{new_resource.options.join(' ')} "
  end
  execute "#{drush_cmd}" do
    command "#{drush_cmd}"
  end
end

action :run do
  drush = {}
  drush.cmd = "drush #{new_resource.command} "
  drush.args = new_resource.args || []
  drush.options = new_resource.options || []
  if new_resource.site_alias
    drush.cmd += "@#{new_resource.site_alias} "
  end
  if new_resource.site_uri
    drush.options.push("--uri=#{new_resource.site_uri}")
  end
  if new_resource.site_dir
    drush.options.push("--destination=#{new_resource.site_dir}")
  end
  if new_resource.quiet
    drush.options.push("-q")
  end
  if new_resource.default_yes
    drush.options.push("-y")
  end
  if new_resource.args
    drush.cmd += "#{new_resource.args.join(' ')} "
  end
  if new_resource.options
    drush.cmd += "#{new_resource.options.join(' ')} "
  end
  execute "#{drush.cmd}" do
    command "#{drush.cmd}"
  end
end

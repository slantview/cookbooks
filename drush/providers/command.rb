action :run do
  drush_cmd = "drush #{new_resource.command} "
  
  if new_resource.site_alias
    drush_cmd += "@#{new_resource.site_alias} "
  end
  if new_resource.site_uri
    drush_cmd += "--uri=#{new_resource.site_uri} "
  end
  if new_resource.quiet
    drush_cmd += "-q "
  end
  if new_resource.default_yes
    drush_cmd += "-y "
  end
  if new_resource.site_dir
    drush_cmd += "--destination=#{new_resource.site_dir} "
  end
  if new_resource.args
    args = new_resource.args.join(" ")
  else
    args = ""
  end
  if new_resource.options
    options = new_resource.options.join(" ")
  else
    options = ""
  end  
  
  Chef::Log.info "Executing command #{drush_cmd} #{args} #{options}"
  
  execute "#{drush_cmd} #{args} #{options}" do
    command "#{drush_cmd} #{args} #{options}"
  end
end

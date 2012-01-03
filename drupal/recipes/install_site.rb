node['drupal']['site_pass'] = secure_password

db_url = ["mysql://#{node['drupal']['db']['username']}:#{node['drupal']['db']['password']}",
          "@#{node['drupal']['db']['hostname']}:#{node['drupal']['db']['port']}",
          "/#{node['drupal']['db']['database']}"].join('')
       
drush_command "install-drupal-#{node['drupal']['install_profile']}" do
  action :run
  command "si"
  args ["--account-name=#{node['drupal']['site_user']}", 
        "--db-prefix=#{node['drupal']['db']['prefix']}",
        "--db-url=#{db_url}",
        "--account-pass=#{node['drupal']['site_pass']}",
        "--account-mail=#{node['drupal']['site_mail']}",
        "--locale=#{node['drupal']['site_locale']}",
        "--clean-url=#{node['drupal']['site_clean_urls']}",
        "--site-name=#{node['fqdn']}",
        "--site-mail=#{node['drupal']['site_mail']}",
        "--sites-subdir=default"]
  notifies :create, "ruby_block[save node data]", :immediately unless Chef::Config[:solo]
end
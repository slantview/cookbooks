#
# Author:: Steve Rude (<steve@slantview.com>)
# Cookbook Name:: drupal
# Attributes:: drupal
#
# Copyright 2011, Slantview Media
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "drupal"

# Setup secure password
node.set_unless[:drupal][:site][:pass] = secure_password
node.set_unless[:drupal][:db][:password] = secure_password

if node.has_key?("ec2")
  node.set_unless[:drupal][:server_name] = node.ec2.public_hostname
else
  node.set_unless[:drupal][:server_name] = node.fqdn
end

node.set_unless[:drupal][:server_aliases] = [node.fqdn]

# Setup releases and shared files, settings directories that mimic the
# capistrano way of linking.  This will be useful later on if we start
# deploying locally using capistrano or deployr.

directory "#{node[:drupal][:dir]}/releases" do
  owner node[:apache][:group]
  group node[:apache][:user]
  mode "0755"
  action :create
  recursive true
  not_if do
    File.exists?("#{node[:drupal][:dir]}/releases")
  end
end

directory "#{node[:drupal][:dir]}/shared/default/files" do
  owner node[:apache][:user]
  group node[:apache][:group]
  mode "0755"
  action :create
  recursive true
  not_if do
    File.exists?("#{node[:drupal][:dir]}/shared/default/files")
  end
end

# Download the latest version of Drupal via drush into the
drush_command "download-drupal-#{node[:drupal][:version]}" do
  action :run
  command "dl"
  args ["drupal-#{node[:drupal][:version]}"]
  site_dir "#{node[:drupal][:dir]}/releases"
  quiet true
  default_yes true
  not_if do
    File.exists?("#{node[:drupal][:dir]}/releases/drupal-#{node[:drupal][:version]}")
  end
end

# Create database if it doesn't already exist.
execute "create #{node[:drupal][:db][:database]} database" do
  command "/usr/bin/mysqladmin -u root -p\"#{node[:mysql][:server_root_password]}\" create #{node[:drupal][:db][:database]}"
  not_if "mysql -u root -p\"#{node[:mysql][:server_root_password]}\" -e 'show databases;' | grep #{node[:drupal][:db][:database]}"
  notifies :create, "ruby_block[save node data]", :immediately unless Chef::Config[:solo]
end

execute "mysql-install-drupal-privileges" do
  command "/usr/bin/mysql -u root -p#{node[:mysql][:server_root_password]} < /etc/drupal_grants.sql"
  action :nothing
end

# Grant "ALL" on database to our new user.
# TODO: Can probably limit this down to specific (SELECT, INSERT, UPDATE, DELETE, CREATE) ?
template "/etc/drupal_grants.sql" do
  path "/etc/drupal_grants.sql"
  source "grants.sql.erb"
  owner "root"
  group "root"
  mode "0600"
  variables(
    :user     => node[:drupal][:db][:username],
    :hostname => node[:drupal][:db][:hostname],
    :password => node[:drupal][:db][:password],
    :database => node[:drupal][:db][:database]
  )
  notifies :run, resources(:execute => "mysql-install-drupal-privileges"), :immediately
end

template "#{node[:drupal][:dir]}/shared/default/settings.php" do
  source "settings.php.erb"
  owner node[:apache][:user]
  group node[:apache][:group]
  mode "0644"
  variables(
    :username => node[:drupal][:db][:username],
    :password => node[:drupal][:db][:password],
    :database => node[:drupal][:db][:database],
    :hostname => node[:drupal][:db][:hostname],
    :prefix => node[:drupal][:db][:prefix],
    :port => node[:drupal][:db][:port]
  )
  not_if do
    File.exists?("#{node[:drupal][:dir]}/shared/default/settings.php")
  end
end

if node[:drupal][:docroot].empty?
  node[:drupal][:docroot] = "#{node[:drupal][:dir]}/#{node[:drupal][:current]}"
end

link "#{node[:drupal][:docroot]}" do
  to "#{node[:drupal][:dir]}/releases/drupal-#{node[:drupal][:version]}"
  not_if do
    File.exists?("#{node[:drupal][:docroot]}")
  end
end

link "#{node[:drupal][:docroot]}/sites/default/files" do
  to "#{node[:drupal][:dir]}/shared/default/files"
  not_if do
    File.exists?("#{node[:drupal][:docroot]}/sites/default/files")
  end
end

link "#{node[:drupal][:docroot]}/sites/default/settings.php" do
  to "#{node[:drupal][:dir]}/shared/default/settings.php"
  not_if do
    File.exists?("#{node[:drupal][:docroot]}/sites/default/settings.php")
  end
end

node[:apache][:listen_ports].each do |port|
  web_app "drupal" do
    # You must have a htuser and htpass if you want to use htaccess.
    if node[:drupal][:htuser].empty? || node[:drupal][:htpass].empty?
      template "drupal_auth.conf.erb"
    else
      template "drupal.conf.erb"
    end
    docroot "#{node[:drupal][:docroot]}"
    server_name node[:drupal][:server_name]
    server_aliases node[:drupal][:server_aliases]
    listen_port port
    variables(
      :htpasswd_file => "#{node[:drupal][:dir]}/shared/htpasswd"
    )
  end
end

if !node[:drupal][:htuser].empty? || !node[:drupal][:htpass].empty?
  require 'digest/sha1'
  require 'base64'

  template "#{node[:drupal][:dir]}/shared/htpasswd" do
    source "htpasswd.erb"
    variables(
      :htuser => node[:drupal][:htuser],
      :htpass => '{SHA}' + Base64.encode64(Digest::SHA1.digest(node[:drupal][:htpass]))
    )
  end
end

apache_site "000-default" do
  enable false
end

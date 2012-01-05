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

include_recipe "apache2"
include_recipe "mysql::server"
include_recipe "php"
include_recipe "php::module_mysql"
include_recipe "apache2::mod_php5"
include_recipe "drush"

if node.has_key?("ec2")
  server_fqdn = node['ec2']['public_hostname']
else
  server_fqdn = node['fqdn']
end

# We must install the pre-requisites in order to support drupal
# TODO: Make sure we are platform agnostic.  FIX THIS.
php_packages = %w{ php-common php php-devel php-cli php-pear php-xml }
php_packages.each do |pkg|
  package pkg do
    action :install
  end
end

# Setup releases and shared files, settings directories that mimic the 
# capistrano way of linking.  This will be useful later on if we start 
# deploying locally using capistrano or deployr.

directory "#{node['drupal']['dir']}/releases" do
  owner "#{node[:apache][:group]}"
  group "#{node[:apache][:user]}"
  mode "0755"
  action :create
  recursive true
  not_if do
    File.exists?("#{node['drupal']['dir']}/releases")
  end
end

directory "#{node['drupal']['dir']}/shared/files" do
  owner node[:apache][:user]
  group node[:apache][:group]
  mode "0755"
  action :create
  recursive true
  not_if do
    File.exists?("#{node['drupal']['dir']}/shared/files")
  end
end

directory "#{node['drupal']['dir']}/shared/settings" do
  owner node[:apache][:user]
  group node[:apache][:group]
  mode "0755"
  action :create
  recursive true
  not_if do
    File.exists?("#{node['drupal']['dir']}/shared/settings")
  end
end

# Download the latest version of Drupal via drush into the 
drush_command "download-drupal-#{node['drupal']['version']}" do
  action :run
  command "dl"
  args ["drupal-#{node['drupal']['version']}"]
  site_dir "#{node['drupal']['dir']}/releases"
  quiet true
  default_yes true
  not_if do
    File.exists?("#{node['drupal']['dir']}/releases/drupal-#{node['drupal']['version']}")
  end
end

# Create database if it doesn't already exist.
execute "create #{node['drupal']['db']['database']} database" do
  command "/usr/bin/mysqladmin -u root -p\"#{node['mysql']['server_root_password']}\" create #{node['drupal']['db']['database']}"
  not_if "mysql -u root -p\"#{node['mysql']['server_root_password']}\" -e 'show databases;' | grep #{node['drupal']['db']['database']}"
  notifies :create, "ruby_block[save node data]", :immediately unless Chef::Config[:solo]
end

# Setup secure password
node.set['drupal']['db']['password'] = secure_password

# Grant "ALL" on database to our new user.
# TODO: Can probably limit this down to specific (SELECT, INSERT, UPDATE, DELETE, CREATE) ?
grant_cmd = ["echo \"GRANT ALL ON #{node['drupal']['db']['database']}.*",
             "TO '#{node['drupal']['db']['username']}'@'#{node['drupal']['db']['hostname']}'",
             "IDENTIFIED BY '#{node['drupal']['db']['password']}'\"",
             "| mysql -u root -p\"#{node['mysql']['server_root_password']}\""].join(' ')

execute "grant #{node['drupal']['db']['username']} database permissions" do
  command grant_cmd 
  only_if "mysql -u root -p\"#{node['mysql']['server_root_password']}\" -e 'show databases;' | grep #{node['drupal']['db']['database']}"
  notifies :create, "ruby_block[save node data]", :immediately unless Chef::Config[:solo]
end

# Save the node data so we have access to our state, including passwords, etc.
unless Chef::Config[:solo]
  ruby_block "save node data" do
    block do
      node.save
    end
    action :create
  end
end

link "#{node['drupal']['dir']}/current" do
  to "#{node['drupal']['dir']}/releases/drupal-#{node['drupal']['version']}"
end

link "#{node['drupal']['dir']}/current/sites/default/files" do
  to "#{node['drupal']['dir']}/shared/files"
end

template "#{node['drupal']['dir']}/shared/settings/settings.php" do
  source "settings.php.erb"
  owner node[:apache][:user]
  group node[:apache][:group]
  mode "0644"
  variables(
    :username => node['drupal']['db']['username'],
    :password => node['drupal']['db']['password'],
    :database => node['drupal']['db']['database'],
    :hostname => node['drupal']['db']['hostname'],
    :prefix => node['drupal']['db']['prefix'],
    :port => node['drupal']['db']['port']
  )
end

link "#{node['drupal']['dir']}/current/sites/default/settings.php" do
  to "#{node['drupal']['dir']}/shared/settings/settings.php"
end

apache_site "000-default" do
  enable false
end

web_app "drupal" do
  template "drupal.conf.erb"
  docroot "#{node['drupal']['dir']}/current"
  server_name server_fqdn
  server_aliases node['drupal']['server_aliases']
end
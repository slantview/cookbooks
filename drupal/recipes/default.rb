#
# Cookbook Name:: drupal
# Recipe:: default
#
# Copyright 2009-2010, Opscode, Inc.
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

if node.has_key?("ec2")
  server_fqdn = node['ec2']['public_hostname']
else
  server_fqdn = node['fqdn']
end

install_profile = node['drupal']['install_profile'] || "standard"

node.set['drupal']['db']['password'] = secure_password

remote_file "#{Chef::Config[:file_cache_path]}/drupal-#{node['drupal']['version']}.tar.gz" do
  checksum node['drupal']['checksum']
  source "http://drupal.org/files/drupal-#{node['drupal']['version']}.tar.gz"
  mode "0644"
end

directory "#{node['drupal']['dir']}" do
  owner "root"
  group "root"
  mode "0755"
  action :create
  recursive true
end

execute "untar-drupal" do
  cwd node['drupal']['dir']
  command "tar --strip-components 1 -xzf #{Chef::Config[:file_cache_path]}/drupal-#{node['drupal']['version']}.tar.gz"
  creates "#{node['drupal']['dir']}/sites/default/default.settings.php"
end

execute "create #{node['drupal']['db']['database']} database" do
  command "/usr/bin/mysqladmin -u root -p\"#{node['mysql']['server_root_password']}\" create #{node['drupal']['db']['database']}"
  not_if do
    require 'mysql'
    m = Mysql.new("localhost", "root", node['mysql']['server_root_password'])
    m.list_dbs.include?(node['drupal']['db']['database'])
  end
  notifies :create, "ruby_block[save node data]", :immediately unless Chef::Config[:solo]
end

# save node data after writing the MYSQL root password, so that a failed chef-client run that gets this far doesn't cause an unknown password to get applied to the box without being saved in the node data.
unless Chef::Config[:solo]
  ruby_block "save node data" do
    block do
      node.save
    end
    action :create
  end
end

log "Navigate to 'http://#{server_fqdn}/install.php?profile=#{install_profile}' to complete Drupal installation" do
  action :nothing
end

template "#{node['drupal']['dir']}/sites/default/settings.php" do
  source "settings.php.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :database        => node['drupal']['db']['database'],
    :user            => node['drupal']['db']['username'],
    :password        => node['drupal']['db']['password']
  )
  notifies :write, "log[Navigate to 'http://#{server_fqdn}/install.php?profile=#{install_profile}' to complete drupal installation]"
end

apache_site "000-default" do
  enable false
end

web_app "drupal" do
  template "drupal.conf.erb"
  docroot "#{node['drupal']['dir']}"
  server_name server_fqdn
  server_aliases node['drupal']['server_aliases']
end

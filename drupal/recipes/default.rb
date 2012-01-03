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

node.set['drupal']['db']['password'] = node['mysql']['server_root_password'] 

directory "#{node['drupal']['dir']}/releases" do
  owner "#{node[:apache][:group]}"
  group "#{node[:apache][:user]}"
  mode "0755"
  action :create
  recursive true
end

directory "#{node['drupal']['dir']}/shared" do
  owner "#{node[:apache][:group]}"
  group "#{node[:apache][:user]}"
  mode "0755"
  action :create
  recursive true
end

directory "#{node['drupal']['dir']}/shared/files" do
  owner "#{node[:apache][:group]}"
  group "#{node[:apache][:user]}"
  mode "0755"
  action :create
  recursive true
end

directory "#{node['drupal']['dir']}/shared/settings" do
  owner "#{node[:apache][:group]}"
  group "#{node[:apache][:user]}"
  mode "0755"
  action :create
  recursive true
end

drush_command "download-drupal" do
  action :run
  command "download"
  args ["drupal-#{node['drupal']['version']}"]
  site_dir "#{node['drupal']['dir']}/releases"
  quiet true
  default_yes true
end
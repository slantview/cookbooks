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

remote_file "#{Chef::Config[:file_cache_path]}/drupal-#{node['drupal']['version']}.tar.gz" do
  checksum node['drupal']['md5']
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

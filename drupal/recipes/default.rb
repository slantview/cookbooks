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
include_recipe "php::module_apc"
include_recipe "php::module_curl"
include_recipe "php::module_xml"
include_recipe "apache2::mod_php5"
include_recipe "drush"

if node.has_key?("ec2")
  server_fqdn = node['ec2']['public_hostname']
else
  server_fqdn = node['fqdn']
end

# We must install the pre-requisites in order to support drupal
# TODO: Make sure we are platform agnostic.  FIX THIS.
#php_packages = %w{ php5-common php5 php5-dev php5-cli php-pear }
#php_packages.each do |pkg|
#  package pkg do
#    action :install
#  end
#end

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

# General settings
default['drupal']['version'] = "7.10"
default['drupal']['dir'] = "/var/www/drupal"
default['drupal']['db']['database'] = "drupaldb"
default['drupal']['db']['username'] = "drupal"
default['drupal']['db']['password'] = "password"
default['drupal']['db']['hostname'] = "localhost"
default['drupal']['db']['port'] = "3306"
default['drupal']['db']['prefix'] = ""
default['drupal']['server_aliases'] = [node['fqdn']]
default['drupal']['install_profile'] = "standard"
default['drupal']['site_user'] = "root"
default['drupal']['site_mail'] = "user@example.com"
default['drupal']['site_pass'] = "password"
default['drupal']['site_locale'] = "en"
default['drupal']['site_clean_urls'] = 1

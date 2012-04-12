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
include_recipe "drupal::install_drupal"

install_profile = node[:drupal][:install_profile] || "standard"

db_url = ["mysql://#{node[:drupal][:db][:username]}:#{node[:drupal][:db][:password]}",
          "@#{node[:drupal][:db][:hostname]}:#{node[:drupal][:db][:port]}",
          "/#{node[:drupal][:db][:database]}"].join('')

drush_command "install-drupal-#{node[:drupal][:install_profile]}" do
  action :run
  command "si"
  args ["--root=#{node[:drupal][:docroot]}",
        "--account-name=#{node[:drupal][:site][:user]}", 
        "--db-prefix=#{node[:drupal][:db][:prefix]}",
        "--db-url=#{db_url}",
        "--account-pass=#{node[:drupal][:site][:pass]}",
        "--account-mail=#{node[:drupal][:site][:mail]}",
        "--locale=#{node[:drupal][:site][:locale]}",
        "--clean-url=#{node[:drupal][:site][:clean_urls]}",
        "--site-name=#{node[:fqdn]}",
        "--site-mail=#{node[:drupal][:site][:mail]}",
        "--sites-subdir=#{node[:drupal][:site][:name]}",
        "--db-su=root",
        "--db-su-pw=#{node[:mysql][:server_root_password]}"]
  notifies :create, "ruby_block[save node data]", :immediately unless Chef::Config[:solo]
  not_if { node.attribute?("drupal_default_site_installed") }
end

# Save the node data so we have access to our state, including passwords, etc.
unless Chef::Config[:solo]
  ruby_block "save node data" do
    block do
      node.set[:drupal_default_site_installed] = true
      node.save
    end
    action :create
  end
end
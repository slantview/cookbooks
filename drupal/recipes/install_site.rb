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

install_profile = node['drupal']['install_profile'] || "standard"
node['drupal']['site_pass'] = secure_password

db_url = ["mysql://#{node['drupal']['db']['username']}:#{node['drupal']['db']['password']}",
          "@#{node['drupal']['db']['hostname']}:#{node['drupal']['db']['port']}",
          "/#{node['drupal']['db']['database']}"].join('')
       
drush_command "install-drupal-#{node['drupal']['install_profile']}" do
  action :run
  command "si"
  args ["--root=#{node['drupal']['dir']}/current",
        "--account-name=#{node['drupal']['site_user']}", 
        "--db-prefix=#{node['drupal']['db']['prefix']}",
        "--db-url=#{db_url}",
        "--account-pass=#{node['drupal']['site_pass']}",
        "--account-mail=#{node['drupal']['site_mail']}",
        "--locale=#{node['drupal']['site_locale']}",
        "--clean-url=#{node['drupal']['site_clean_urls']}",
        "--site-name=#{node['fqdn']}",
        "--site-mail=#{node['drupal']['site_mail']}",
        "--sites-subdir=#{node['drupal']['site_name']}",
        "--db-su=root",
        "--db-su-pw=#{node['mysql']['server_root_password']}"]
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
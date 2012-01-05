# Cookbook Name:: varnish
# Recipe:: default
# Author:: Joe Williams <joe@joetify.com>
#
# Copyright 2008-2009, Joe Williams
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

package "varnish" do
  action :install
end

template "#{node[:varnish][:dir]}/default.vcl" do
  source "default.vcl.erb"
  owner "root"
  group "root"
  mode 0644
end

template "#{node[:varnish][:default]}" do
  source "default.erb"
  owner "root"
  group "root"
  mode 0644
  variables(
    :nfiles => node[:varnish][:nfiles],
    :memlock => node[:varnish][:memlock],
    :daemon_corefile_limit => node[:varnish][:daemon_corefile_limit],
    :reload_vcl => node[:varnish][:reload_vcl],
    :vcl_conf => node[:varnish][:vcl_conf],
    :listen_address => node[:varnish][:listen_address],
    :listen_port => node[:varnish][:listen_port],
    :admin_listen_address => node[:varnish][:admin_listen_address],
    :admin_listen_port => node[:varnish][:admin_listen_port],
    :secret_file => node[:varnish][:secret_file],
    :min_threads => node[:varnish][:min_threads],
    :max_threads => node[:varnish][:max_threads],
    :thread_timeout => node[:varnish][:thread_timeout],
    :storage_file => node[:varnish][:storage_file],
    :storage_size => node[:varnish][:storage_size],
    :storage => node[:varnish][:storage],
    :ttl => node[:varnish][:ttl],
    :user => node[:varnish][:user],
    :group => node[:varnish][:group]
  )
end

template "#{node[:varnish][:dir]}/secret" do
  source "secret.erb"
  owner "root"
  group "root"
  mode 0600
  variables :varnish_secret => node[:varnish][:secret]
end

service "varnish" do
  supports :restart => true, :reload => true
  action [ :enable, :start ]
end

service "varnishlog" do
  supports :restart => true, :reload => true
  action [ :enable, :start ]
end

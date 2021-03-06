#
# Cookbook Name:: munin
# Attributes:: default
#
# Copyright 2010-2011, Opscode, Inc.
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

default['munin']['sysadmin_email'] = "ops@example.com"
default['munin']['server_role'] = 'monitoring'
default['munin']['server_auth_method'] = 'openid'

case node[:platform]
when "arch"
  default['munin']['docroot'] = "/srv/http/munin"
when "centos","redhat"
  default['munin']['docroot'] = "/var/www/html/munin"
else
  default['munin']['docroot'] = "/var/www/munin"
end

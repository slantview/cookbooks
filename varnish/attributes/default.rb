# Cookbook Name:: varnish
# Attributes:: default
# Author:: Steve Rude <steve@slantview.com
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
::Chef::Node.send(:include, Opscode::OpenSSL::Password)

# Set a secure password for the telnet/admin interface.
set_unless[:varnish][:secret] = secure_password

# Set the location of the varnish config, differs based on distro.
case platform
when "debian","ubuntu"
  set[:varnish][:dir]     = "/etc/varnish"
  set[:varnish][:default] = "/etc/default/varnish"
when "centos","redhat"
  set[:varnish][:dir]     = "/etc/varnish"
  set[:varnish][:default] = "/etc/sysconfig/varnish"
end

# Maximum number of open files (for ulimit -n)
set[:varnish][:nfiles] = "131072"

# Maximum size of corefile (for ulimit -c). Default in Fedora is 0
case platform
when "fedora"
  set[:varnish][:daemon_corefile_limit] = "0"
when "centos","redhat","debian","ubuntu"
  set[:varnish][:daemon_corefile_limit] = "unlimited"
end

# Locked shared memory (for ulimit -l)
# Default log size is 82MB + header
set[:varnish][:memlock] = "82000"

# Set this to 1 to make init script reload try to switch vcl without restart.
# To make this work, you need to set the following variables
# explicit: VARNISH_VCL_CONF, VARNISH_ADMIN_LISTEN_ADDRESS,
# VARNISH_ADMIN_LISTEN_PORT, VARNISH_SECRET_FILE
case platform
when "debian","ubuntu"
  set[:varnish][:reload_vcl] = "0"
when "centos","redhat"
  set[:varnish][:reload_vcl] = "1"
end

# Main configuration file.
default[:varnish][:vcl_conf] = "#{node[:varnish][:dir]}/default.vcl"

# Shared secret file for admin interface
default[:varnish][:secret_file] = "#{node[:varnish][:dir]}/secret"

# Default address and port to bind to
# Blank address means all IPv4 and IPv6 interfaces, otherwise specify
# a host name, an IPv4 dotted quad, or an IPv6 address in brackets.
default[:varnish][:listen_address] = ""
default[:varnish][:listen_port] = "6081"

# Telnet admin interface listen address and port
default[:varnish][:admin_listen_address] = "127.0.0.1"
default[:varnish][:admin_listen_port] = "6082"

# The minimum number of worker threads to start
default[:varnish][:min_threads] = "1"

# The Maximum number of worker threads to start
default[:varnish][:max_threads] = "1000"

# Idle timeout for worker threads
default[:varnish][:thread_timeout] = 120

# Cache file location
default[:varnish][:storage_file] = "/var/lib/varnish/varnish_storage.bin"

# Cache file size: in bytes, optionally using k / M / G / T suffix,
# or in percentage of available disk space using the % suffix.
default[:varnish][:storage_size] = "1G"

# Backend storage specification
default[:varnish][:storage] = '"file,${VARNISH_STORAGE_FILE},${VARNISH_STORAGE_SIZE}"'

# Default TTL used when the backend does not specify one
default[:varnish][:ttl] = "120"

# Default user for varnish to run as.
default[:varnish][:user] = "varnish"

# Default group for varnish to run as.
default[:varnish][:group] = "varnish"
Description
===========

Installs and configures varnish high performance web application accelerator.

Varnish Cache is a web application accelerator also known as a caching HTTP 
reverse proxy. You install it in front of any server that speaks HTTP and 
configure it to cache the contents. Varnish Cache is really, really fast. 
It typically speeds up delivery with a factor of 300 - 1000x, depending 
on your architecture. A high level overview of what Varnish does can be 
seen in the video attached to this web page.

http://www.varnish-cache.org/

Changes
=======

## v 1.0.0:

* Current public release.

Requirements
============

## Platform:

Tested on:

* Ubuntu 10.04
* CentOS 6.2

Attributes
==========

* `node['varnish']['dir']` - location of the varnish configuration directory
* `node['varnish']['default']` - location of the `default` file that controls 
   the varnish init script on Debian/Ubuntu systems.
* `node[:varnish][:node]` -  (Default: /etc/default/varnish)
* `node[:varnish][:nfiles]` - Maximum number of open files (for ulimit -n) 
   (Default: 131072)
* `node[:varnish][:daemon_corefile_limit]` - Maximum size of corefile (for 
   ulimit -c). Default in Fedora is 0 (Default: 0)
* `node[:varnish][:memlock]` - Locked shared memory (for ulimit -l). Default 
   log size is 82MB + header (Default: 82000)
* `node[:varnish][:reload_vcl]` - Set this to 1 to make init script reload try 
   to switch vcl without restart.  To make this work, you need to node the 
   following variables explicit: VARNISH_VCL_CONF, 
   VARNISH_ADMIN_LISTEN_ADDRESS, VARNISH_ADMIN_LISTEN_PORT, VARNISH_SECRET_FILE
   (Default: 0)
* `node[:varnish][:varnish_vcl_conf]` - Main configuration file. (Default: 
  `node[:varnish][:dir]`/default.vcl)
* `node[:varnish][:secret_file]` - Shared secret file for admin interface 
   (Default: `default[:varnish][:dir]`/secret)
* `node[:varnish][:listen_port]` - Port to bind to. (Default: 6081)
* `node[:varnish][:admin_listen_address]` - Telnet admin interface listen 
   address. (Default: 127.0.0.1)
* `node[:varnish][:admin_listen_port]` - Telnet admin interface listen port.
   (Default: 6082)
* `node[:varnish][:min_threads]` - The minimum number of worker threads to 
   start (Default: 1)
* `node[:varnish][:max_threads]` - The Maximum number of worker threads to 
   start (Default: 1000)
* `node[:varnish][:storage_size]` - Cache file size: in bytes, optionally 
   using k / M / G / T suffix, or in percentage of available disk space using 
   the % suffix. (Default: 1G)
* `node[:varnish][:ttl]` - TTL used when the backend does not specify one 
   (Default: 120)
* `node[:varnish][:user]` - User for varnish to run as. (Default: varnish)
* `node[:varnish][:group]` - Group for varnish to run as. (Default: varnish)


Recipes
=======

default
-------

Installs the varnish package, manages the default varnish configuration file, 
and the init script defaults file.

Usage
=====

On systems that need a high performance caching server, use `recipe[varnish]`. 
Additional configuration can be done by modifying the `default.vcl.erb` and 
default attributes. By default the `default.erb` is set up
for minimal configuration.

License and Author
==================

Author:: Steve Rude <steve@slantview.com>

Copyright:: 2011, Steve Rude

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

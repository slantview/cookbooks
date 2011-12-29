Description
===========

Installs and configures Wordpress according to the instructions. Does not set up a drupal site. You will need to do this manually by going to http://hostname/install.php (this URL may be different if you change the installation profile value).

Changes
=======  
### v0.1.0:

* Inital version.

Requirements
============

Platform
--------

* Debian, Ubuntu

Tested on:

* Ubuntu 10.04

Cookbooks
---------

* mysql
* php
* apache2
* opensssl (uses library to generate secure passwords)

Attributes
==========

* `node['drupal']['version']` - Set the version to download.
* `node['drupal']['md5']` - md5 of the tarball, make sure this matches for the version!
* `node['drupal']['dir']` - Set the location to place drupal files. Default is /var/www/drupal.
* `node['drupal']['db']['database']` - Wordpress will use this MySQL database to store its data.
* `node['drupal']['db']['username']` - Wordpress will connect to MySQL using this user.
* `node['drupal']['db']['password']` - Password for the Wordpress MySQL user. The default is a randomly generated string.
* `node['drupal']['server_aliases']` - Array of ServerAliases used in apache vhost. Default is `node['fqdn']`.
* `node['drupal']['install_profile]` - The installation profile to use.

The random generation is handled with the secure_password method in the openssl cookbook which is a cryptographically secure random generator and not predictable like the random method in the ruby standard library.

Usage
=====

If a different version than the default is desired, download that version and get the md5 checksum, and set the version and checksum attributes.

Add the "drupal" recipe to your node's run list or role, or include the recipe in another cookbook.

Chef will install and configure mysql, php, and apache2 according to the instructions. Does not set up a drupal site. You will need to do this manually by going to http://hostname/install.php (this URL may be different if you change the installation profile value).

The mysql::server recipe needs to come first, and contain an execute resource to install mysql privileges in this cookbook.

## Note about MySQL

This cookbook will decouple the mysql::server and be smart about detecting whether to use a local database or find a database server in the environment in a later version.

License and Author
==================

Author:: Steve Rude (steve@slantview.com)

Copyright:: 2011, Slantview Media

Originally based on the wordpress recipe by Barry Steinglass, Joshua Timberman, and Seth Chisamore.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

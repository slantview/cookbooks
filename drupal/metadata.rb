maintainer       "Steve Rude"
maintainer_email "steve@slantview.com"
license          "Apache 2.0"
description      "Installs/Configures Drupal"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.14"

recipe "drupal", "Installs and configures Drupal LAMP stack on a single system"

%w{ php openssl }.each do |cb|
  depends cb
end

depends "apache2", ">= 0.99.4"
depends "mysql", ">= 1.0.5"
depends "drush", ">= 0.9.3"

%w{ debian ubuntu }.each do |os|
  supports os
end

attribute "drupal/version",
  :display_name => "Drupal download version",
  :description => "Version of Drupal to download from the Drupal site.",
  :default => "7.10"
  
attribute "drupal/dir",
  :display_name => "Drupal installation directory",
  :description => "Location to place Drupal files.",
  :default => "/var/www/drupal"
  
attribute "drupal/db/database",
  :display_name => "Drupal MySQL database",
  :description => "Drupal will use this MySQL database to store its data.",
  :default => "drupaldb"

attribute "drupal/db/username",
  :display_name => "Drupal MySQL username",
  :description => "Drupal will connect to MySQL using this user.",
  :default => "drupaluser"

attribute "drupal/db/password",
  :display_name => "Drupal MySQL password",
  :description => "Password for the Drupal MySQL user.",
  :default => "randomly generated"
  
attribute "drupal/server_aliases",
  :display_name => "Drupal Server Aliases",
  :description => "Drupal Server Aliases",
  :default => "FQDN"

attribute "drupal/install_profile",
  :display_name => "Drupal installation profile",
  :description => "Drupal installation profile",
  :default => "standard"

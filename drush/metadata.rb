maintainer       "Mark Sonnabaum"
maintainer_email "mark.sonnabaum@acquia.com"
license          "Apache 2.0"
description      "Installs drush head"
version          "0.9.3"
recipe           "drush", "Installs drush head"

%w{ debian ubuntu arch }.each do |os|
  supports os
end

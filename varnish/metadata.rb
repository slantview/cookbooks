maintainer        "Slantview Media"
maintainer_email  "steve@slantview.com"
license           "Apache 2.0"
description       "Instsalls and configures varnish"
version           "0.8.1"

recipe "varnish", "Installs and configures varnish"

%w{ubuntu debian}.each do |os|
  supports os
end

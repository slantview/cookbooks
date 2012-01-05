maintainer        "Steve Rude"
maintainer_email  "steve@slantview.com"
license           "Apache 2.0"
description       "Installs and configures varnish"
version           "1.0.0"

recipe "varnish", "Installs and configures varnish"

%w{ openssl }.each do |cb|
  depends cb
end

%w{ubuntu debian centos redhat fedora}.each do |os|
  supports os
end

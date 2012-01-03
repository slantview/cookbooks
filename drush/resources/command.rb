actions :run
 
attribute :name, :kind_of => String, :name_attribute => true
attribute :command, :kind_of => String
attribute :args, :kind_of => Array
attribute :options, :kind_of => Array
attribute :site_alias, :kind_of => String
attribute :site_dir, :kind_of => String
attribute :site_uri, :kind_of => String
attribute :quiet, :default => true
attribute :default_yes, :default => true
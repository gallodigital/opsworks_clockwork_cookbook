actions :create
default_action :create

attribute :name, :kind_of => String, :name_attribute => true, :required => true
attribute :working_directory, :kind_of => [String, NilClass], :required => true

attribute :user, :kind_of => [String], :required => true
attribute :group, :kind_of => [String, NilClass], :default => 'root'

attribute :clock_file, :kind_of => [String, NilClass], :default => nil
attribute :pid_dir, :kind_of => [String, NilClass], :default => nil
attribute :log_dir, :kind_of => [String, NilClass], :default => nil
attribute :rails_env, :kind_of => [String, NilClass], :default => nil

OpsWorks Clockwork Cookbook
===========================

## Description

This cookbook is for AWS OpsWorks running on Amazon Linux and adds a LWRP you can use for deploying a Clockwork daemon.

## Requirements

* Amazon Linux
* Chef 11 (might work on Chef 0.9)

## Node Attributes

* `node['clockwork']['clock']` - global default clock file (default is clock.rb)
* `node['clockwork']['log_dir']` - global default log directory (default is /var/log/clockwork)
* `node['clockwork']['pid_dir']` - global default PID directory (default is /var/run/clockwork)
* `node['clockwork']['rails_env']` - global default Rails/Rack environment (default is production)

## Resource Attributes

* `clock_file` - the clock file that clockwork should use (clock.rb by default)
* `group` - the group clockwork should run as (same as the Rails app generally)
* `log_dir` - the log directory (/var/log/clockwork by default)
* `name` - the name of this clockworkd (usually the app name) - specified after the resource name
  (see below) like most other Chef resources
* `pid_dir` - the PID directory (/var/run/clockwork by default)
* `rails_env` - the Rails/Rack environment (production by default)
* `user` - the user clockwork should run as (same as the Rails app generally)
* `working_directory` - the directory the app is deployed to (/srv/whatever/current generally)

## Usage

```ruby
opsworks_clockwork "name" do
  working_directory "/srv/path/to/app/current"
  rails_env "production"
  user "deploy"
  group "deploy"
end
```

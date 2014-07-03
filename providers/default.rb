action :create do
  name       = new_resource.name
  user       = new_resource.user
  group      = new_resource.group
  rails_root = new_resource.working_directory
  rails_env  = new_resource.rails_env || node['clockwork']['rails_env']
  clock      = new_resource.clock_file || node['clockwork']['clock']
  clock_name = ::File.basename(clock, ".rb")
  pid_dir    = new_resource.pid_dir || node['clockwork']['pid_dir']
  log_dir    = new_resource.log_dir || node['clockwork']['log_dir']

  pid_file   = "#{pid_dir}/clockworkd.#{clock_name}.pid"
  log_file   = "#{log_dir}/clockworkd.#{clock_name}.output"

  execute "reload-monit-for-clockwork" do
    command "monit -Iv reload"
    action :nothing
  end

  directory pid_dir do
    owner user
    group group
    mode 0775
  end

  directory log_dir do
    mode 0775
  end

  file log_file do
    owner user
    group group
    mode 0755
    action :create_if_missing
  end

  template "/usr/local/bin/stop_clockwork_#{name}.sh" do
    source 'stop_clockwork.sh.erb'
    cookbook 'opsworks_clockwork'
    owner user
    group group
    mode 0755
    variables "pid_dir" => pid_dir,
              "log_dir" => log_dir,
              "user" => user,
              "name" => name,
              "rails_root" => rails_root,
              "rails_env" => rails_env,
              "clock" => clock
  end

  template "/usr/local/bin/start_clockwork_#{name}.sh" do
    source 'start_clockwork.sh.erb'
    cookbook 'opsworks_clockwork'
    owner user
    group group
    mode 0755
    variables "pid_dir" => pid_dir,
              "log_dir" => log_dir,
              "user" => user,
              "name" => name,
              "rails_root" => rails_root,
              "rails_env" => rails_env,
              "clock" => clock
  end

  template "#{node.default["monit"]["conf_dir"]}/clockwork_#{name}.monitrc" do
    source 'clockwork.monitrc.erb'
    cookbook 'opsworks_clockwork'
    owner 'root'
    group 'root'
    mode '0644'
    variables "name" => name,
              "pid_file" => pid_file
    notifies :run, "execute[reload-monit-for-clockwork]", :immediately # Run immediately to ensure the following command works
  end

  # Restart clockwork if it's already running
  execute "restart-clockwork-service" do
    command "monit -Iv restart clockwork_#{name}"
    only_if { ::File.exists?(pid_file) }
  end

  new_resource.updated_by_last_action(true)
end

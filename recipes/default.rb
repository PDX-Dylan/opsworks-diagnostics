#
# Cookbook Name:: opsworks-diagnostics
# Recipe:: default
#
# Copyright (C) 2015 Stephanie King
#
#

# Test recipe for getting important info into S3


directory node[:opsworks_diagnostics][:log_dir] do
  owner 'root'
  group 'root'
  mode '644'
  action :create
end

template "#{node[:opsworks_diagnostics][:log_dir]}/#{node[:opsworks_diagnostics][:log_file]}" do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  source "node_logs.erb"
end

# Diagnostic Commands - each command creates a .log file which will be included in the upload -------------

# do ps aux
bash "ps aux" do
  code "echo \n\"[#{node[:opsworks_diagnostics][:timestamp]}]\"\n >> #{node[:opsworks_diagnostics][:log_dir]}/ps.log; ps aux >> #{node[:opsworks_diagnostics][:log_dir]}/ps.log"
end

# do netstat
bash "netstat" do
  code "echo \n\"[#{node[:opsworks_diagnostics][:timestamp]}]\" >> #{node[:opsworks_diagnostics][:log_dir]}/netstat.log; netstat -antp >> #{node[:opsworks_diagnostics][:log_dir]}/netstat.log"
end
#-----------------------------------------------------------------------------------------------------------

# copy latest opsworks logs into directory if enabled
bash "copy ow logs" do
  cwd node["opsworks_diagnostics"][:log_dir]
  code "cp /var/log/aws/opsworks/*.log ."
  only_if { node[:opsworks_diagnostics][:include_agent_logs] == true }
end
                                                                                                  
# Create tar.gz file to be uploaded to S3
bash "create_archive" do
  cwd node["opsworks_diagnostics"][:log_dir]
  code "tar -czvf #{node[:opsworks_diagnostics][:timestamp]}.tar.gz *.log #{node[:opsworks_diagnostics][:other_logs].join(" ")}"
end

# Clean up individual log files
bash "remove_logs" do
  cwd node["opsworks_diagnostics"][:log_dir]
  code "rm -rf *.log"
end

# Add archive to S3, prefix with ec2 instance ID, then timestampe (ie, i-abcd1234-12345678)                                                                                                                                                                
ruby_block "upload_log_file" do
  block do
    require 'aws-sdk'
    s3 = AWS::S3.new
    key = "#{node[:opsworks_diagnostics][:s3][:key_prefix]}/#{node[:opsworks][:instance][:aws_instance_id]}-#{node[:opsworks_diagnostics][:timestamp]}.tar.gz"
    s3.buckets[node[:opsworks_diagnostics][:s3][:bucket]].objects[key].write(:file => "#{node[:opsworks_diagnostics][:log_dir]}/#{node[:opsworks_diagnostics][:timestamp]}.tar.gz")
  end
  not_if { node[:opsworks_diagnostics][:local_mode] == true }
end


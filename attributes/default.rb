# Attributes
#
#Timestamp used to identify the diagnostics run, could be replaced with any unique string
default[:opsworks_diagnostics][:timestamp] = Time.now.to_i

default[:opsworks_diagnostics][:log_dir] =  "/var/log/opsworks-diagnostics"
default[:opsworks_diagnostics][:log_file] = "opsworks-diagnostics.log"

# Include logs in /var/log/aws/opsworks
default[:opsworks_diagnostics][:include_agent_logs] = false

#full path to existing logs which can be bundled on upload, ex: /var/log/messages, /var/log/httpd/*, /var/lib/aws/opsworks/chef/*
default[:opsworks_diagnostics][:other_logs] = ["/var/lib/aws/opsworks/chef/*"]

#Set to true only if you do NOT want to upload to S3. You will need to log onto the instance to retreive logs manually with this enabled.
default[:opsworks_diagnostics][:local_mode] = false

# S3 Upload location
default[:opsworks_diagnostics][:s3][:bucket] = "somefakebucketIown"
default[:opsworks_diagnostics][:s3][:key_prefix] = "owlogs"

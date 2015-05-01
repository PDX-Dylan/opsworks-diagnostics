# opsworks-diagnostics-cookbook

This cookbook gathers Opsworks-related logs, and the output of troubleshooting commands, and uploads them into S3 for easy access.

## Supported Platforms

Opsworks platform, tested on chef 11.10 for Opsworks

Amazon Linux (tested up to) 2015.03

Ubuntu Linux 14.04

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['opsworks_diagnostics']['log_dir']</tt></td>
    <td>String</td>
    <td>Path to directory to store log files</td>
    <td><tt>/var/log/opsworks-diagnostics</tt></td>
  </tr>
  <tr>
    <td><tt>['opsworks_diagnostics']['log_file']</tt></td>
    <td>String</td>
    <td>Name of file with nod info, (see node_logs.erb template)</td>
    <td><tt>opsworks-diagnostics.log</tt></td>
  </tr>
  <tr>
    <td><tt>['opsworks_diagnostics']['include_agent_logs']</tt></td>
    <td>Boolean</td>
    <td>Whether to bundle contents of /var/log/aws/opsworks with logs</td>
    <td><tt>false</tt></td>
  </tr>
    <tr>
    <td><tt>['opsworks_diagnostics']['other_logs']</tt></td>
    <td>List of strings</td>
    <td>List with each item as a full path to other logs to bundle (ex: /var/log/messages, /var/lib/aws/opsworks/chef/*)</td>
    <td><tt>["/var/lib/aws/opsworks/chef"]</tt></td>
  </tr>
    <tr>
    <td><tt>['opsworks_diagnostics'][':local_mode']</tt></td>
    <td>Boolean</td>
    <td>When set to true, recipe does not attempt to upload logs to S3</td>
    <td><tt>false</tt></td>
  </tr>
  <tr>
    <td><tt>['opsworks_diagnostics']['s3']['bucket']</tt></td>
    <td>String</td>
    <td>Your S3 bucket to upload logs to. Your OW instance role must have permissions to upload here</td>
    <td><tt>somefakebucketIown</tt></td>
  </tr>
  <tr>
    <td><tt>['opsworks_diagnostics']['s3']['key_prefix']</tt></td>
    <td>String</td>
    <td>the prefix to the files in S3, ie "owlogs" will create bucketname/owlogs and put logs there</td>
    <td><tt>owlogs</tt></td>
  </tr>
</table>

## Usage

### opsworks-diagnostics::default

Include `opsworks-diagnostics` in lifecycle event you wish to run it in, or just call it with "execute recipes" from Opsworks.

Make sure the opsworks-ec2-role has permissions to your S3 bucket, like:

```json
{
   "Statement":[
      {
         "Effect":"Allow",
         "Action":[
            "s3:ListAllMyBuckets"
         ],
         "Resource":"arn:aws:s3:::*"
      },
      {
         "Effect":"Allow",
         "Action":[
            "s3:ListBucket",
            "s3:GetBucketLocation"
         ],
         "Resource":"arn:aws:s3:::examplebucket"
      },
      {
         "Effect":"Allow",
         "Action":[
            "s3:PutObject",
            "s3:GetObject",
            "s3:DeleteObject"
         ],
         "Resource":"arn:aws:s3:::examplebucket/*"
      }
   ]
}
```

See more examples here: http://docs.aws.amazon.com/AmazonS3/latest/dev/example-policies-s3.html

## Contributing

1. Fork the repository on Github
2. Create a named feature branch (i.e. `add-new-recipe`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request

## License and Authors

Author:: Stephanie King (sudosteph@gmail.com)

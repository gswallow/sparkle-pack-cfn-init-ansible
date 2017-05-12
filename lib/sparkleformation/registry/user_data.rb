SfnRegistry.register(:user_data) do |_name, _config={}|

  user_data base64!(
    join!(
      "#!/bin/bash\n\n",

      "function my_instance_id\n",
      "{\n",
      "  curl -sL http://169.254.169.254/latest/meta-data/instance-id/\n",
      "}\n\n",

      "function cfn_signal_and_exit\n",
      "{\n",
      "  status=$?\n",
      "  if [ $status -eq 0 ]; then\n",
      "    /usr/local/bin/cfn-signal ",
      "     --role ", _config[:iam_role],
      "     --region ", region!,
      "     --resource ", _config[:resource_id],
      "     --stack ", stack_name!,
      "     --exit-code $status\n",
      "  else\n",
      "    sleep 420\n",
      "    /usr/local/bin/aws autoscaling set-instance-health --instance-id $(my_instance_id) --health-status Unhealthy --region ", region!, "\n",
      "  fi\n",
      "  exit $status\n",
      "}\n\n",

      "if [ ! -f /usr/local/bin/cfn-init ]; then\n",
      "  apt-get -qq update\n",
      "  apt-get -yqq install python-setuptools python-pip python-lockfile unzip\n",
      "  apt-get -yqq install --reinstall ca-certificates\n",
      "  easy_install https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-latest.tar.gz\n",
      "fi\n\n",

      "if [ ! -f /usr/local/bin/aws ]; then\n",
      "  curl -sSL https://s3.amazonaws.com/aws-cli/awscli-bundle.zip -o /tmp/awscli-bundle.zip\n",
      "  unzip -q -d /tmp /tmp/awscli-bundle.zip\n",
      "  /tmp/awscli-bundle/install -i /opt/aws -b /usr/local/bin/aws\n",
      "  rm -rf /tmp/awscli-bundle*\n",
      "fi\n\n",

      "/usr/local/bin/cfn-init -s ", stack_name!, " --resource ", _config[:launch_config],
      "  --region ", region!, " || cfn_signal_and_exit\n\n",

      "cfn_signal_and_exit\n"
    )
  )
end

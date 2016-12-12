# sparkle-pack-cfn-init-ansible
CFN Init Registry to bootstrap an instance with Ansible

Obviously this documentation needs work :)

## iam_instance_profile dynamic

Creates an IAM instance profile allowing the resource to mark itself unhealthy so that its parent auto scaling group can
terminate and try launching a replacement node, and signal CloudFormation to satisfy a stack creation policy.

The creation policy specifies that CloudFormation must get as many success notifications as the desired capacity in an auto scaling group.

_config[:policy_statements] = an array of hashes or symbols.  These objects will be passed to the SparkleFormation's registry! function, as a name, options pair
in the case of a hash, or individually in the case of a symbol.  Basically, create a policy statement as a registry, and pass it in as "extra" policy 
statements to attach to the IAM instance policy you're creating (i.e. modifying route53 entries).

## user_data registry

| Parameter | Purpose |
|-----------|---------|
| _config[:iam_role] | ref!(:your_iam_role) |
| _config[:resource_id] | The logical name of your auto scaling group, as it appears in the compiled JSON template |
| _config[:launch_config] | The logical name of your launch configuration, as it appears in the compiled JSON template |

## ansible_pull registry

You can pass ref!(...) objects or strings, mostly.

| Parameter | Purpose |
|-----------|---------|
| Write | This |

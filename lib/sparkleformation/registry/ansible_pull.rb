SfnRegistry.register(:ansible_pull) do |_name, _config = {}|

  # Yeah, only Ubuntu is supported.  Sorry.
  # Ansible doesn't recommend using an omnibus install
  # method so I'm stuck with either pip, or packages.

  seed = Array.new
  _config.fetch(:ansible_seed, {}).each do |k, v|
    seed << "#{k.upcase}="
    seed << v
    seed << "\n"
  end

  version = Array.new
  if _config.has_key?(:ansible_version)
    version = [ "=", _config[:ansible_version], "~`lsb_release -s -c`" ]
  end

  metadata('AWS::CloudFormation::Init') do
    _camel_keys_set(:auto_disable)
    configSets do |sets|
      sets.default += ['ansible']
    end
    ansible do
      files('/etc/ansible-local/seed') do
        content join!(seed)
        mode '000600'
        owner 'root'
        group 'root'
      end

      files('/tmp/hosts') do
        content registry!(:ansible_inventory)
        mode '000755'
        owner 'root'
        group 'root'
      end

      commands('00-add-ansible-ppa') do
        command 'apt-get update && apt-get -yqq install software-properties-common && apt-add-repository ppa:ansible/ansible && apt-get -q update'
        test 'test ! -e ansible-ubuntu-ansible-xenial.list'
      end

      commands('01-install-ansible') do
        command join!('apt-get -yqq install ansible', *version)
      end

      commands('02-run-ansible-pull') do
        command join!('env $(cat /etc/ansible-local/seed) ansible-pull -U',
                      _config[:ansible_playbook_repo],
                      '-C',
                      _config.fetch(:ansible_playbook_branch, 'master'),
                      '-i',
                      _config.fetch(:ansible_inventory, '/tmp/hosts'),
                      _config.fetch(:ansible_local_yaml_path, 'local.yml'),
                      '-c local',
                      {:options => { :delimiter => ' '}})
      end
    end
  end
end

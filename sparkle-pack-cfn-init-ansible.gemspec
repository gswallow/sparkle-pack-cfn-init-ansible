Gem::Specification.new do |s|
  s.name = 'sparkle-pack-cfn-init-ansible'
  s.version = '0.0.3'
  s.licenses = ['MIT']
  s.summary = 'CFN Init Ansible SparklePack'
  s.description = 'SparklePack to provide cfn-init config set to bootstrap an instance using Ansible'
  s.authors = ['Greg Swallow']
  s.email = 'gswallow@gmail.com'
  s.homepage = 'https://github.com/gswallow'
  s.files = Dir[ 'lib/sparkleformation/registry/*' ] + %w(sparkle-pack-cfn-init-ansible.gemspec lib/sparkle-pack-cfn-init-ansible.rb)
  s.add_runtime_dependency 'sparkle_formation'
end

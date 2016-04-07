# Puppet Master Class
class profile::puppet::master {
  # Hiera config
  class {'::hiera':
    datadir            => '"%{::environmentpath}/%{::environment}/data"',
    hiera_yaml         => "${::settings::codedir}/hiera.yaml",
    puppet_conf_manage => false,
    create_symlink     => false,
    owner              => 'root',
    group              => 'root',
    hierarchy          => [
      '"nodes/%{::trusted.certname}"',
      '"%{::trusted.domainname}/%{::trusted.hostname}"',
      '"roles/%{::trusted.extensions.pp_role}"',
      '"roles/%{role}"',
      'private',
      'common',
    ],
  }

  # Install, configure and run R10K
  class {'::r10k':
    sources  => {
      'main' => {
        'remote'  => 'https://github.com/vladgh/puppet.git',
        'basedir' => $::settings::environmentpath,
        'prefix'  => false,
      },
    },
    cachedir => '/opt/puppetlabs/r10k/cache',
    postrun  => ['/bin/bash', '-c', "${::settings::environmentpath}/${environment}/hooks/post-run"],
    provider => 'puppet_gem',
    version  => '2.2.0',
  }
}

# Docker Profile
class profile::docker {
  # Docker
  if $::virtual == 'docker' {
    warning('Docker in Docker is not yet supported!')
  } else {
    class { '::docker':
      tcp_bind    => 'tcp://0.0.0.0:2375',
      socket_bind => 'unix:///var/run/docker.sock',
    }

    # Docker Compose
    $docker_compose_version = hiera('docker_compose_version')
    class {'::docker::compose': version => $docker_compose_version}

    # Docker Machine
    $docker_machine_version = hiera('docker_machine_version')
    wget::fetch {'Docker-Machine Binary':
      source      => "https://github.com/docker/machine/releases/download/v${docker_machine_version}/docker-machine-${::kernel}-${::os['hardware']}",
      destination => '/usr/local/bin/docker-machine',
    }
    file {'/usr/local/bin/docker-machine':
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      require => [Wget::Fetch['Docker-Machine Binary']],
    }

    # AWS ECS
    if $::ec2_metadata {
      file { '/var/log/ecs':
        ensure => 'directory',
      } ->
      file { '/var/lib/ecs':
        ensure => 'directory',
      } ->
      file { '/var/lib/ecs/data':
        ensure => 'directory',
      }
    }
  }
}

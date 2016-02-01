# AMI Profile
class profile::ec2 {
  include ::profile::base

  # Ensure essential packages
  ensure_packages([
    'curl',
    'nfs-common',
    'mysql-client',
    'python-pip',
    'wget',
  ])

  # Latest GIT
  apt::ppa {'ppa:git-core/ppa': package_manage => true}
  class {'::git':
    require => [
      Apt::Ppa['ppa:git-core/ppa'],
      Class['apt::update']
      ],
  }

  # AWS CLI
  package {'awscli':
    ensure   => present,
    provider => 'pip',
    require  => Package['python-pip'],
  }

  # AWS CloudFormation scripts
  package {'AWS CloudFormation':
    ensure   => present,
    name     => 'aws-cfn-bootstrap',
    source   => 'https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-latest.tar.gz',
    provider => 'pip',
    require  => Package['python-pip'],
  }

  #AWS CodeDeploy
  if ($::os['name'] == 'Ubuntu') {
    ensure_packages([
      'ruby2.0',
      'gdebi-core',
    ])
    wget::fetch {'CodeDeploy Deb':
      source      => 'https://aws-codedeploy-us-east-1.s3.amazonaws.com/latest/codedeploy-agent_all.deb',
      destination => '/usr/local/src/codedeploy-agent_all.deb',
    }
    package {'CodeDeploy Agent':
      ensure   => present,
      name     => 'codedeploy-agent',
      source   => '/usr/local/src/codedeploy-agent_all.deb',
      provider => dpkg,
      require  => [
        Wget::Fetch['CodeDeploy Deb'],
        Package['ruby2.0', 'gdebi-core']
      ],
    }
    service {'CodeDeploy Service':
      ensure  => running,
      enable  => true,
      name    => 'codedeploy-agent',
      require => Package['CodeDeploy Agent'],
    }
  }

  #AWS Simple Systems Manager Agent
  if ($::os['name'] == 'Ubuntu') {
    wget::fetch {'AWS SSM Agent Deb':
      source      => 'https://amazon-ssm-us-east-1.s3.amazonaws.com/latest/debian_amd64/amazon-ssm-agent.deb',
      destination => '/usr/local/src/amazon-ssm-agent.deb',
    }
    package {'AWS SSM Agent':
      ensure   => present,
      name     => 'amazon-ssm-agent',
      source   => '/usr/local/src/amazon-ssm-agent.deb',
      provider => dpkg,
      require  => [
        Wget::Fetch['AWS SSM Agent Deb'],
      ],
    }
    service {'AWS SSM Agent':
      ensure  => running,
      enable  => true,
      name    => 'amazon-ssm-agent',
      require => Package['AWS SSM Agent'],
    }
  }
}

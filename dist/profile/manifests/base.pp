# Base Profile
class profile::base {
  # Include classes
  include ::stdlib
  include ::apt
  include ::ntp

  # Ensure essential packages
  ensure_packages([
    'curl',
    'nfs-common',
    'mysql-client',
    'wget',
    'tmux',
    'vim',
    'unzip',
  ])

  # SSH Keys
  $ssh_authorized_keys = hiera_hash('ssh_authorized_keys', {})
  create_resources(ssh_authorized_key, $ssh_authorized_keys)

  # Papertrail Logging
  $log_server_address = hiera('log_server_address', undef)
  $log_server_port = hiera('log_server_address', undef)
  if ($log_server_port and $log_server_port) {
    class{'::rsyslog::client':
      remote_servers => [
        {
          host    => $log_server_address,
          port    => $log_server_port,
          pattern => '*.*',
        },
      ],
    }
  }
}

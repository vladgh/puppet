# Mini Role (Vlad's Media Server)
class role::mini {
  include ::profile::base
  include ::profile::ca_certs
  include ::profile::log
  include ::profile::monitor
  include ::profile::git
  include ::profile::puppet::agent
  include ::profile::docker
  include ::profile::samba
}

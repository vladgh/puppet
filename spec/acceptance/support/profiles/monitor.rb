shared_examples 'profile::monitor' do
  describe file('/usr/local/bin/node_exporter') do
    it { is_expected.to be_symlink }
    it { is_expected.to be_executable }
  end

  describe file('/var/lib/prometheus_node_exporter') do
    it { is_expected.to be_directory }
  end

  describe service('node_exporter') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end
end

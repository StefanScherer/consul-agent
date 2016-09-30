require "serverspec"
require "json"

set :backend, :cmd
set :os, :family => 'windows'

package = JSON.parse(File.read('../../../package.json'))

describe "Ports" do
  if package['packaging'].has_key?('firewallExceptions')
    describe "Firewall ports" do
      package['packaging']['firewallExceptions'].each do |firewall_exception|
        describe port(firewall_exception['port'].to_i) do
          it { should be_listening }
        end
      end
    end
  end

  describe "UI port" do
    describe port(8500) do
      it { should be_listening }
    end
  end
end

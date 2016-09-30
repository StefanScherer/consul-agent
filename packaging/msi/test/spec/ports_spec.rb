require "serverspec"
require "json"

set :backend, :cmd
set :os, :family => 'windows'

package = JSON.parse(File.read('../../../package.json'))

if package['packaging'].has_key?('firewallExceptions')
  describe "Ports" do
    package['packaging']['firewallExceptions'].each do |firewall_exception|
      describe port(firewall_exception['port'].to_i) do
        it { should be_listening }
      end
    end
  end
end

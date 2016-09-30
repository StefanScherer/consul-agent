require "serverspec"

set :backend, :cmd
set :os, :family => 'windows'

describe "UI Files" do
  describe file("#{ENV['ProgramFiles']}/HashiCorp/Consul/consul-agent/ui/") do
    it { should be_directory }
  end

  describe file("#{ENV['ProgramFiles']}/HashiCorp/Consul/consul-agent/ui/index.html") do
    it { should exist }
  end
end

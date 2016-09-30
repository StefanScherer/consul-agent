require "serverspec"

set :backend, :cmd
set :os, :family => 'windows'

describe "Configuration" do
  describe file("#{ENV['ProgramData']}/HashiCorp/Consul/config/") do
    it { should be_directory }
  end

  describe file("#{ENV['ProgramData']}/HashiCorp/Consul/config/consul.json") do
    it { should exist }
  end
end

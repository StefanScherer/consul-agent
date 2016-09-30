require "serverspec"

set :backend, :cmd
set :os, :family => 'windows'

describe "Logging" do
  describe file("#{ENV['ProgramData']}/HashiCorp/Consul/log/") do
    it { should be_directory }
  end
end

require "serverspec"

set :backend, :cmd
set :os, :family => 'windows'

describe "MSI package" do
  describe package("consul-agent #{ENV['MSI_VERSION']}") do
    it { should be_installed}
  end

  describe "Service" do
    describe service("consul-agent") do
      it { should be_running }
      it { should have_start_mode("Automatic") }
    end
  end
end

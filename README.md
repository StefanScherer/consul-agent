# consul-agent [![Build status](https://ci.appveyor.com/api/projects/status/rue46i4p5y9i2p4t?svg=true)](https://ci.appveyor.com/project/StefanScherer/consul-agent)

Consul MSI installer to install a Consul agent as a Windows service.

## Introduction

The MSI installer will install:

1. The `consul.exe` in Program Files\HashiCorp\Consul\consul-agent
2. `nssm.exe` in Program Files\HashiCorp\Consul\consul-agent
3. The `consul.json` in ProgramData\HashiCorp\Consul\consul-agent
4. Register nssm + consul as a Windows service

## Building

The MSI is built at AppVeyor CI, so have a look at the `appveyor.yml` for details.

## License

This project is licensed under the MIT license. See the [LICENSE](./LICENSE) file for more info.

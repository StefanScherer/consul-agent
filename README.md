# consul-agent

Consul MSI installer to install a Consul agent as a Windows service.

## Introduction

The MSI installer will install:

1. The `consul.exe` in Program Files\HashiCorp\consul-agent
2. `nssm.exe` in Program Files\HashiCorp\consul-agent
3. The `consul.json` in ProgramData\HashiCorp\consul-agent
4. Register nssm + consul as a Windows service

## Building

The MSI is built at AppVeyor CI, so have a look at the `appveyor.yml` for details.

## License

This project is licensed under the MIT license. See the [LICENSE](./LICENSE) file for more info.

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

## Deployment

AppVeyor builds the MSI, but deploys it only if is a tag push.

So releasing a new MSI looks like this.

1. Editing the source tree,
2. `git push` to build (and test in the future)
3. `git tag 0.6.3`
4. `git push --tags`

AppVeyor then builds the MSI again and creates a GitHub release.

## Future work

* Add example for code signing to nssm.exe, consul.exe and as well the MSI package
* Add better banner images and logos

## License

This project is licensed under the MIT license. See the [LICENSE](./LICENSE) file for more info.

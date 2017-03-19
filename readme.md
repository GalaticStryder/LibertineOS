_**LibertineOS**_ for LeEco devices
==========================

> A build system for **EUI** official **ROMs** for _LeEco/LeTV_ devices.

A bunch of scripts, binaries and helpers built-in one repository that will download, extract, modify and repack the upstream operating system for distribution. It's planned and organized for _any_ **LeEco** device, not only the **Le Pro3** which is my personal device.

The build system approach shines on the lines of [_FreedomOS_](https://gitlab.com/Nevax/FreedomOS) which is not intrusive and not as specific as the Android Kitchen build system, which needs to rebase the third party work on every major release and doesn't support a variety of devices in the same tree.

It's fundamental, though, to say that this build system only supports the **GNU/Linux** platform for many reasons we shall not describe here. So, all you'd need to build **_LibertineOS_** is a _GNU/Linux_ distribution with the proper packages installed, more on that in the _Building_ part of the **Documentation** section below.

## Documentation

#### Organization

The _carnival_ happens at first glance in the _configuration_ folder, which consists in several variables that will get passed to the build scripts.

##### Variables:

The configuration folder sets up the variables for the device we'll build for and the target EUI version.

- configuration/
  - ${device}-${version}.ini

The fundamental variable is **$IDENTIFIER** which is automatically created by agglutinating two other variables **$CODENAME** and **$ROM_ID**.

The **$CODENAME** varible is the shot term for the device set by the manufacturer most of the time, e.g.: _x2_, _zl1_. This provices us an easy way to filter what we can ship for different devices and EUI versions, e.g.: _21s has Google services support, 20s does not_.

##### Logic:

Inspecting the _configuration_ folder will give you the "officialy" supported devices and their respective EUI versions, a device can have multiple versions and variants that may change how we will handle the installer and the software that we'll remove from the _system.img_.

    ./liberty.sh -a ${device}-${version} # Download, extract and analyze the system.img file.
    ./liberty.sh -b ${device}-${version} # Download, extract, remove and modify the contents of system.img file to create a flashable zip file.

#### Building

Guide will be placed here.

#### Credits

- [**xpirt**](https://github.com/xpirt): System convertion binaries.
- [**Nevax**](https://github.com/Nevax07): Most build scripts and organization idea.
- [**amarullz**](https://github.com/amarullz): Customizable aroma installer.
- [**Chainfire**](https://github.com/Chainfire): SuperSU modification package.
- [**Cloudyfa**](https://github.com/Cloudyfa): G3 aroma theme.
- [**Kickoff**](https://github.com/Kickoff): Redblack aroma theme.

## License

The **_LibertineOS_** project is licensed under the [GNU General Public Licence - Version 3](license.md).

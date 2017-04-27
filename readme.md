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

The configuration folder sets up the variables for the device we'll build for and the target EUI version, e.g.: _Pro3-23S.ini_.

The fundamental variable is **$IDENTIFIER** which is automatically created by agglutinating two other variables **$CODENAME** and **$ROM_ID**.

**$CODENAME** varible is the short term for the device set by the manufacturer most of the time, e.g.: _x2_, _zl1_. This provices us an easy way to filter what we can ship for different devices.

| Variable      | Description           | Example       |
| ------------- | --------------------- | ------------- |
| **$IDENTIFIER** | Automatically created by agglutinating two other variables **$CODENAME** and **$ROM_ID** | **zl1_23s** |
| **$CODENAME** | Short term for the device set by the manufacturer | **zl1** |
| **$ROM_ID** | Lowercase EUI minor release version | 5.9.**23s** |

##### Logic:

Inspecting the _configuration_ folder will give you the "officialy" supported devices and their respective EUI versions, a device can have multiple versions and variants that may change how we will handle the installer and the software that we'll remove from the _system.img_.

	./liberty.sh -a ${device}-${version} # Download, extract and analyze the system.img file.
	./liberty.sh -b ${device}-${version} # Download, extract, remove and modify the contents of system.img file to create a flashable zip file.

#### Dependencies

The following packages need to be installed on your **GNU/Linux** machine in order to "compile" _LibertineOS_ properly.

###### Arch Linux

	sudo pacman -S aria2 cpio zip wget rsync python python2 python-virtualenv openssl ncurses

###### Ubuntu/Debian

	sudo apt-get install aria2 cpio zip wget rsync python python-virtualenv openssl libncurses-dev

It's also handy to have other software available such as **adb**, **apktool** and **java** installed.

#### Building

First of all, make sure you have the needed [dependencies](#dependencies).

Then, clone the repository somewhere, _--recursive_ flag will pull the needed modules.

	git clone --recursive https://github.com/GalaticStryder/LibertineOS.git libertine-os

#### Credits

- [**xpirt**](https://github.com/xpirt): System convertion binaries.
- [**Nevax07**](https://github.com/Nevax07): Most build scripts and organization idea.
- [**amarullz**](https://github.com/amarullz): Customizable aroma installer.
- [**Chainfire**](https://github.com/Chainfire): SuperSU modification package.
- [**Cloudyfa**](https://github.com/Cloudyfa): G3 aroma theme.
- [**Kickoff**](https://github.com/Kickoff): Redblack aroma theme.

## License

The **_LibertineOS_** project is licensed under the [GNU General Public Licence - Version 3](license.md).

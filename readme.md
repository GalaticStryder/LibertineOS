_**LibertineOS**_ for LeEco devices
==========================

> A build system for **EUI** official **ROMs** for _LeEco/LeTV_ devices.

A bunch of scripts, binaries and helpers built-in one repository that will download, extract, modify and repack the upstream operating system for distribution. It's planned and organized for _any_ **LeEco** device, not only the **Le Pro3** which is my personal device.

The build system approach shines on the lines of [_FreedomOS_](https://gitlab.com/Nevax/FreedomOS) which is not intrusive and not as specific as the Android Kitchen build system, which needs to rebase the third party work on every major release and doesn't support a variety of devices in the same tree.

It's fundamental, though, to say that this build system only supports the **GNU/Linux** platform for many reasons we shall not describe here. So, all you'd need to build **_LibertineOS_** is a _GNU/Linux_ distribution with the proper packages installed, more on that in the _Building_ part of the **Documentation** section below.

## Documentation

This documentation is used for "compiling" supported devices and porting new devices by creating new configuration files for them under **configuration** folder. The **configuration file** is the main component needed for creating a new _LibertineOS_ product, understanding the variables and how the scripts work is the only obstable you might find yourself in when porting LibertineOS your device. Fortunately, we have a great documentation in place, _just for you_.

#### Variables

They are all set in the configuration for the device and EUI version we'll be building. Check the following table to have a deeper knowledge on the main variables the build system supports.

| Variable      | Description           | Example       |
| ------------- | --------------------- | ------------- |
| **$IDENTIFIER** | Automatically created by agglutinating two other variables **$CODENAME** and **$ROM_ID** | **zl1_23s** |
| **$DEVICE** | User's globally adopted device name convention | **Pro3** |
| **$CODENAME** | Short term for the device set by the manufacturer | **zl1** |
| **$ROM_ID** | Lowercase EUI minor release version | 5.9.**23s** |
| **$ROM_NAME** | Zip file produced by the OEM build system | **LE_ZL1_LEX720-CN-FN-WAXCNFN5902303282S-5.9.023S** |
| **$ROM_LINK** | Downloadable zip file from OEM servers | **[URL](https://bbs.le.com/zt/eui/index.html)/$ROM_NAME** |
| **$ROM_MD5** | Hash for checking if the download is not corrupted | **0006f6ca49090764695186b36bc1acfe** |
| **$ASSERT** | Build product and device safety check before flashing process | **le_zl1** |
| **$RELTYPE** | Release type to complement the build ID property | **release-keys** |
| **$SYSTEMIMAGE_PARTITION_SIZE** | Amount of system partition's blocks **[???](#blocks)** | **4294967296** |

#### Modes

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

Change directory to the folder _libertine-os_ folder.

	cd libertine-os

Run the _[liberty.sh](liberty.sh)_ script in build mode, indicated by _-b_ flag with the **configuration file** right after.

	./liberty.sh -b Pro3-23S

#### Credits

- [**xpirt**](https://github.com/xpirt): System convertion binaries.
- [**Nevax07**](https://github.com/Nevax07): Most build scripts and organization idea.
- [**amarullz**](https://github.com/amarullz): Customizable aroma installer.
- [**Chainfire**](https://github.com/Chainfire): SuperSU modification package.
- [**Cloudyfa**](https://github.com/Cloudyfa): G3 aroma theme.
- [**Kickoff**](https://github.com/Kickoff): Redblack aroma theme.

## License

The **_LibertineOS_** project is licensed under the [GNU General Public Licence - Version 3](license.md).

# Titanium Legacy for Android Icecream

This docker box is for compiling Android 4.0.X compatible Titanium SDK Projects. If for any reason you need to use Titanium's legacy 3.5.2 SDK, this is for you.

## Getting Started

### Prerequisites
Any version of docker

* [Windows 10 Pro 1607+](https://docs.docker.com/docker-for-windows/install/)
* [64-Bit Windows 7/8](https://docs.docker.com/toolbox/toolbox_install_windows/)
* [OSX El Captain+](https://docs.docker.com/docker-for-mac/install/)
* [OSX Mountain Lion to Yosemite](https://docs.docker.com/toolbox/toolbox_install_mac/)
* [Linux](https://docs.docker.com/install/linux/docker-ce/ubuntu/)

### Setup
Open your terminal and run
## Linux
1. ```sudo docker pull rishooty/titanium_legacy_icecream```
2. ```sudo docker run -u $UID:$GID -d --privileged --net host -v /dev/bus/usb:/dev/bus/usb --name <NAME_OF_PROJECT> rishooty/titanium_legacy_icecream```

## Windows
1. ```docker pull rishooty/titanium_legacy_icecream```
2. ```docker run -d --name <NAME_OF_PROJECT> rishooty/titanium_legacy_icecream```

This creates a container that:

* Starts an adb server.
* Mounts your currently plugged in USB devices or running emulators. **(Linux/OSX)**
* Runs *fixuid*, so that you own any files created or modified outside of the container rather than root.

### Building
## Linux
1. ```git clone https://github.com/rishooty/titanium_legacy_icecream.git```
2. ```sudo docker build -t rishooty/titanium_legacy_icecream <PATH_TO_REPO>```

## Windows
1. ```git clone https://github.com/rishooty/titanium_legacy_icecream.git```
2. ```docker build -t rishooty/titanium_legacy_icecream <PATH_TO_REPO>```

### Usage
## Linux
```sudo docker run --privileged --rm --net host -v <TITANIUM_PROJECT_PATH>:/home/docker/Code rishooty/titanium_legacy_icecream <COMMANDS_TO_RUN>```
## Windows
```docker run --rm -v <TITANIUM_PROJECT_PATH>:/home/docker/Code rishooty/titanium_legacy_icecream <COMMANDS_TO_RUN>```

Due to the way fixuid works, titanium can't be set as an entrypoint. This means it will take any argument passed to it. You can check the inner workings of the box with ease if you wish.

Of course, the real reason we are here is to compile legacy titanium projects. So typical usage would be:

## Linux
```sudo docker run --privileged --rm --net host -v <TITANIUM_PROJECT_PATH>:/home/docker/Code rishooty/titanium_legacy_icecream titanium build --device-id=<DEVICE_ID> --platform=android --target=device --project-dir=Code```
## Windows
```docker run --rm -v <TITANIUM_PROJECT_PATH>:/home/docker/Code rishooty/titanium_legacy_icecream titanium build --build-only --platform=android --target=device --project-dir=Code```

This will build your project and send it straight to the emulator or phone you specified. If you only want to build apks, you can use *--build-only* instead of *--device_id*. In the case of Windows, this is your only option. This is because **usb passthrough isn't possible on either version of Windows docker**. In either case, you'll find your built apks in <TITANIUM_PROJECT_PATH>/build/android/bin.

### FAQ
## It isn't detecting my phone/emulator!
If you have adb installed on your host, make sure it isn't running. Run ```adb kill-server``` and try again. If using Windows, you're sadly out of luck.

## I can't seem to mount my project in Windows!
It's a little different depending on which version of docker you installed. If you installed the latest Docker for Windows, you can use regular windows paths:

```-v C:\Users\child\legacyTitaniumProject:/home/docker/Code```

But, if you're using the older Docker Toolbox, you'll need to use unix style paths:

```-v /c/Users/child/legacyTitaniumProject:/home/docker/Code```

## Built With
* Android Tools r25.2.5
* Android SDK 19
* Android NDK r10e-rc4
* bitnami/minideb image
* Docker
* fixuid
* NodeJS LTS && 0.12.18
* NPM 2.15.10
* Oracle Java 8(1.8.0_171)
* Titanium SDK 3.5.2.v20160311103211
* Titantium CLI 5.0.8

## Author
**Nicholas Ricciuti** - [rishooty](https://github.com/rishooty)

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

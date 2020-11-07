# meta-awsota-raspberrypi
This Yocto meta layer contains necessary recipes for integrate AWS IoT, Mender and Raspberry Pi 4 Model B for full system updates.

### Usage

In order to start building own Yocto images you need setup local environment

```bash
git clone --recursive git@github.com:vitalibo/meta-awsota-raspberrypi.git
vagrant up
```

After clone sources and setup VM, you can login to VM using following command:

```bash
vagrant ssh
```

Inside VM, you can perform following command to build images (also, available `core-image-minimal`, `core-image-base`, etc).

```
vagrant@ubuntu-bionic:$ bitbake core-image-full-cmdline
```

Now you can create a package feed, for this you need to update repo package indexes.

```
vagrant@ubuntu-bionic:$ bitbake package-index
```

After successful build setup HTTP server to browse build artifacts. 
Server by default accessible on [http://192.168.0.33:8000](http://192.168.0.33:8000) address.

```bash
vagrant@ubuntu-bionic:$ python3 -m http.server
```

Interesting for us are the two files:

- `tmp/deploy/images/raspberrypi4/core-image-full-cmdline-raspberrypi4.sdimg`
- `tmp/deploy/images/raspberrypi4/core-image-full-cmdline-raspberrypi4.mender`

The first one (with `.sdimg` suffix) is disk image that need to use for initial provision a new device (see [official instruction](https://projects.raspberrypi.org/en/projects/raspberry-pi-setting-up/2)).
Follow this instruction copying an operating system image to an SD card using Mac OS.

```bash
diskutil unmountDisk /dev/diskN     # replace N with SD card device number
sudo dd bs=1m if=core-image-full-cmdline-raspberrypi4.sdimg of=/dev/rdiskN; sync
```

Another (with `.mender` suffix) can be used for OTA updates. This command should perform on a device.

```bash
pi@rpi4:$ mender -install http://192.168.0.33:8000/tmp/deploy/images/raspberrypi4/core-image-full-cmdline-raspberrypi4.mender
```

Then reboot device and wait to starting from new partition.
Now, you can `commit` or `rollback` changes.

```bash
pi@rpi4:$ mender -commit # or -rollback
```

To destroy VM use:

```bash
vagrant destroy
```

### Resources
- [AWS IoT Jobs and Mender integration Demo](https://github.com/aws-samples/aws-iot-jobs-full-system-update)

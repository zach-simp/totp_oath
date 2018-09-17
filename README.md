# totp_oath
Running configure on a CentOS 7 client will download, install and configure the
pam_oath module to add totp support to pam for all signins. Defaults to a key
of 000001, but this should be changed immediately. The config file where this
key is located is `/etc/liboath/users.oath`

## usage
1) `chmod 755 configure.sh`
2) `sudo ./configure.sh [-u, --yumupdate]`

Note: This installation script must be run as root!

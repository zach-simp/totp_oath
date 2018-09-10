# totp_oath
Running configure on a CentOS 7 client will download, install and configure the
pam_oath module to add totp support to pam for all signins. Defaults to a key
of 000001, but this should be changed immediately. The config file where this
key is located is `/etc/liboath/users.oath`

Note: This installation script must be run as root!

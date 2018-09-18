# totp_oath
Running configure on a CentOS 7 client will download, install and configure the
pam_oath module to add totp support to pam for all local signins, as well as sshd. 

__The installation defaults to a key of 000001, but this should be changed
immediately.__

The config file where this
keys are located is `/etc/liboath/users.oath`.
More information on the format of this file can be found in the `Files` section
of the README.

*Note: This installation script must be run as root!*

## usage
1) `git clone https://github.com/zach-simp/totp_oath.git`
2) `cd totp_oath`
3) `chmod 755 configure.sh`
4) `sudo ./configure.sh [-u, --yumupdate]`

## Files
Configuration files are located in `/etc/liboath/`
1) `exclude_users.oath` - List of users, one per line, that will be exempt from
totp sign-in. By default root is excluded as to not break the system if
installation errors occur.
2) `exclude_groups.oath` - List of groups, one per line, that will be exempt
from totp sign-in. File is empty by default.
3) `users.oath` - List of users, one per line, and their totp or hotp settings
and keys. 

`HOTP/T30/6` sets the user on that line to TOTP with 30 second cycles and 6 digit codes.

`HOTP` sets the user on that line to HOTP, which is supported by pam_oath, but
not configured by default.

`HOTP/T30/6 <user> - <key>` is the required line format for the
configuration file. The program is whitespace delimited, so tabs or spaces will
both work. Last code, timestamp and reformat are done by the pam_oath.so module
at every successful TOTP entry. This write is also the reason why the
installation has to alter the selinux context for `/etc/liboath` and it's
children. 


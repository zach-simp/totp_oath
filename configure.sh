#!/bin/bash

cp files/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo

# set an initial value (no/don't update) for the flag
YUM_UPDATE=0

# read the options
TEMP=`getopt -o u:: --long yumupdate:: -- "$@"`
eval set -- "$TEMP"

while true ; do
    case "$1" in
        -u|--yumupdate) YUM_UPDATE=1 ; break ;;
	--) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done

if [ "$YUM_UPDATE" -eq "1" ]; then
	yum -y update
fi

pkgs=("epel-release" "pam_oath")
for pkg in ${pkgs[@]};do 
	if !(rpm -q $pkg)
	then
		yum -y install $pkg
	else
		continue
	fi
done

# Changes selinux context for liboath dir and contained users.oath config to avoid selinux AVC denials 
chcon -R -u system_u -t var_auth_t /etc/liboath

cp files/users.oath /etc/liboath/
cp files/exclude_users.oath /etc/liboath/
cp files/exclude_groups.oath /etc/liboath/

if grep -xq "auth	 \[success=2 default=ignore\] pam_listfile.so item=user sense=allow file=/etc/liboath/exclude_users.oath" "/etc/pam.d/password-auth"
then
	echo "Skipping..."
else
	if grep -xq "auth     \[default=die\] pam_faillock.so authfail deny=5 even_deny_root audit unlock_time=900 root_unlock_time=60" "/etc/pam.d/password-auth"
	then
		# patch  with faillock in orig
		patch -r - -N -u /etc/pam.d/password-auth patches/00010-password-auth-nofail.patch
	else
		# patch  without failock in orig
		patch -r - -N -u /etc/pam.d/password-auth patches/00010-password-auth.patch
		echo "You seem to have an out of date password-auth file."
		echo "Patched for TOTP but does not have faillock enabled"
	fi
fi

if grep -xq "auth	 \[success=2 default=ignore\] pam_listfile.so item=user sense=allow file=/etc/liboath/exclude_users.oath" "/etc/pam.d/system-auth"
then
	echo "Skipping..."
else
	if grep -xq "auth     \[default=die\] pam_faillock.so authfail deny=5 even_deny_root audit unlock_time=900 root_unlock_time=60" "/etc/pam.d/system-auth"
	then
		# patch  with faillock in orig
		patch -r - -N -u /etc/pam.d/system-auth patches/00010-system-auth-nofail.patch
	else
		# patch  without failock in orig
		patch -r - -N -u /etc/pam.d/system-auth patches/00010-system-auth.patch
	fi
fi

patch -r - -N -u /etc/pam.d/password-auth patches/00020-password-auth.patch
patch -r - -N -u /etc/pam.d/system-auth patches/00020-system-auth.patch

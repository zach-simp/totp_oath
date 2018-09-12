#!/bin/bash

cp files/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo
yum -y update
yum -y install epel-release
yum -y install pam_oath

chcon -R -u system_u -t ssh_home_t /etc/liboath

cp files/users.oath /etc/liboath/users.oath

patch /etc/pam.d/password-auth patches/00010-password-auth.patch
patch /etc/pam.d/system-auth patches/00010-system-auth.patch

#semodule -i lib/pam_oath_context.pp


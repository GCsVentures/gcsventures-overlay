# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="LibreOffice Online"
ACCT_USER_ID=345
ACCT_USER_GROUPS=( lool )
ACCT_USER_HOME="/var/lib/libreoffice-online"
ACCT_USER_HOME_OWNER="lool:lool"
ACCT_USER_HOME_PERMS="0750"
ACCT_USER_SHELL="/bin/bash"

acct-user_add_deps

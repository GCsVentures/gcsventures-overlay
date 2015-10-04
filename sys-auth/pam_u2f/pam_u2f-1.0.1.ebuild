# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit multilib autotools-multilib flag-o-matic

DESCRIPTION="Library for authenticating against PAM with a Yubikey"
HOMEPAGE="https://github.com/Yubico/pam-u2f"
SRC_URI="https://developers.yubico.com/${PN/_/-}/Releases/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	app-crypt/libu2f-host
	app-crypt/libu2f-server
	virtual/pam"

DEPEND="${RDEPEND}"

src_prepare() {
	# TODO Prevent libu2f.la to be installed instead of preventing its deletion
	epatch ${FILESDIR}/no_install_unlink.patch

	autotools-multilib_src_prepare
}

src_configure() {
	autotools-multilib_src_configure
}

multilib_src_configure() {
	# Workaround for the broken include path
	append-flags -I/usr/include/u2f-host

	[[ ${AUTOTOOLS_IN_SOURCE_BUILD} ]] && local ECONF_SOURCE=${BUILD_DIR}

	local myeconfargs=(
		--with-pam-dir=/$(get_libdir)/security
	)

	autotools-utils_src_configure "${_at_args[@]}"
}

src_install() {
	autotools-multilib_src_install
}


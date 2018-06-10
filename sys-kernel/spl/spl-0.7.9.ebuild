# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

SRC_URI="https://github.com/zfsonlinux/zfs/releases/download/zfs-${PV}/${P}.tar.gz"
KEYWORDS="~amd64"

inherit flag-o-matic linux-info linux-mod autotools-utils

DESCRIPTION="The Solaris Porting Layer provides many of the Solaris kernel APIs"
HOMEPAGE="http://zfsonlinux.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE="custom-cflags debug kernel-builtin"
RESTRICT="debug? ( strip ) test"

COMMON_DEPEND="dev-lang/perl
	virtual/awk"

DEPEND="${COMMON_DEPEND}"

RDEPEND="${COMMON_DEPEND}
	!sys-devel/spl"

AT_M4DIR="config"
AUTOTOOLS_IN_SOURCE_BUILD="1"
DOCS=( AUTHORS DISCLAIMER )

pkg_setup() {
	linux-info_pkg_setup
	CONFIG_CHECK="
		!DEBUG_LOCK_ALLOC
		KALLSYMS
		!PAX_KERNEXEC
		ZLIB_DEFLATE
		ZLIB_INFLATE
	"
#		!PAX_SIZE_OVERFLOW

	use debug && CONFIG_CHECK="${CONFIG_CHECK}
		FRAME_POINTER
		DEBUG_INFO
		!DEBUG_INFO_REDUCED
	"

	kernel_is ge 2 6 32 || die "Linux 2.6.32 or newer required"

	[ ${PV} != "9999" ] && \
		{ kernel_is le 4 16 || die "Linux 4.16 is the latest supported version."; }

	check_extra_config
}

src_prepare() {
	# Workaround for hard coded path
	sed -i "s|/sbin/lsmod|/bin/lsmod|" "${S}/scripts/check.sh" || \
		die "Cannot patch check.sh"

	# splat is unnecessary unless we are debugging
	use debug || { sed -e 's/^subdir-m += splat$//' -i "${S}/module/Makefile.in" || die ; }

	# Set module revision number
	[ ${PV} != "9999" ] && \
		{ sed -i "s/\(Release:\)\(.*\)1/\1\2${PR}-gentoo/" "${S}/META" || die "Could not set Gentoo release"; }

	if [ "$KV_EXTRA" == "-gcsventures" ] && kernel_is ge 4 14 ; then
		ewarn "4.14+ -gcsventures kernel: disabling configure-time -Werror compile flag"
		epatch "${FILESDIR}/0.7.7-no-werror.patch"
		eautoreconf
	fi
	autotools-utils_src_prepare
}

src_configure() {
	use custom-cflags || strip-flags
	filter-ldflags -Wl,*

	set_arch_to_kernel
	local myeconfargs=(
		--bindir="${EPREFIX}/bin"
		--sbindir="${EPREFIX}/sbin"
		--with-config=all
		--with-linux="${KV_DIR}"
		--with-linux-obj="${KV_OUT_DIR}"
		$(use_enable debug)
		$(use_enable kernel-builtin linux-builtin)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install INSTALL_MOD_PATH="${INSTALL_MOD_PATH:-$EROOT}"
}

pkg_postinst() {
	linux-mod_pkg_postinst

	# Remove old modules
	if [ -d "${EROOT}lib/modules/${KV_FULL}/addon/spl" ]
	then
		ewarn "${PN} now installs modules in ${EROOT}lib/modules/${KV_FULL}/extra/spl"
		ewarn "Old modules were detected in ${EROOT}lib/modules/${KV_FULL}/addon/spl"
		ewarn "Automatically removing old modules to avoid problems."
		rm -r "${EROOT}lib/modules/${KV_FULL}/addon/spl" || die "Cannot remove modules"
		rmdir --ignore-fail-on-non-empty "${EROOT}lib/modules/${KV_FULL}/addon"
	fi
}

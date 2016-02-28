# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
ETYPE="sources"
inherit kernel-2
K_PREPATCHED="1"

KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86"
HOMEPAGE="https://github.com/GCsVentures/gcsventures-overlay"
IUSE="deblob"

DESCRIPTION="Non-hardened Kernel sources used on the GCsVentures infrastructure"
SRC_URI="https://gcs-ventures.com/distfiles/linux-${PVR}-gcsventures.tar.xz"

# until we really follow the kernel-2 eclass' expectations, revert to the default unpacking method
src_unpack() {
	if [ ${A} != "" ]; then
		unpack ${A}
	fi
}

pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "For more info on this patchset, and how to report problems, see:"
	einfo "${HOMEPAGE}"
}

pkg_postrm() {
	kernel-2_pkg_postrm
}

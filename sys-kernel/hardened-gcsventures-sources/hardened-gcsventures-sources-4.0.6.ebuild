# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/gentoo-sources/gentoo-sources-4.0.5.ebuild,v 1.3 2015/06/17 18:58:50 zlogene Exp $

EAPI="5"
ETYPE="sources"
inherit kernel-2

K_PREPATCHED="1"
KV_FULL="${PVR}-hardened-gcsventures"
S=${WORKDIR}/linux-${KV_FULL}

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
HOMEPAGE="https://github.com/GCsVentures/gcsventures-overlay"
IUSE="deblob experimental"

DESCRIPTION="Kernel sources used on the GCsVentures infrastructure. Contains the hardened gentoo patchset for the ${KV_MAJOR}.${KV_MINOR} kernel tree and ZFS 0.6.4.2"
SRC_URI="https://gcs-ventures.com/distfiles/linux-${PVR}-hardened-gcsventures.tar.xz"

RDEPEND=">=sys-devel/gcc-4.5"

# until we really follow the kernel-2 eclass' expectations, revert to the default unpacking method
src_unpack() {
    if [ "${A}" != "" ]; then
        unpack ${A}
    fi
}

pkg_postinst() {
	kernel-2_pkg_postinst

	local GRADM_COMPAT="sys-apps/gradm-3.1*"

	ewarn
	ewarn "Users of grsecurity's RBAC system must ensure they are using"
	ewarn "${GRADM_COMPAT}, which is compatible with ${PF}."
	ewarn "It is strongly recommended that the following command is issued"
	ewarn "prior to booting a ${PF} kernel for the first time:"
	ewarn
	ewarn "emerge -na =${GRADM_COMPAT}"
	ewarn
	einfo
	einfo "For more info on this patchset, and how to report problems, see:"
	einfo "${HOMEPAGE}"
}

pkg_postrm() {
	kernel-2_pkg_postrm
}

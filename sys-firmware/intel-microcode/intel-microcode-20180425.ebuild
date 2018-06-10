# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit linux-info

# Find updates by searching and clicking the first link (hopefully it's the one):
# http://www.intel.com/content/www/us/en/search.html?keyword=Processor+Microcode+Data+File

NUM="27776"
DESCRIPTION="Intel IA32/IA64 microcode update data"
HOMEPAGE="http://inertiawar.com/microcode/ https://downloadcenter.intel.com/Detail_Desc.aspx?DwnldID=${NUM}"
SRC_URI="https://downloadmirror.intel.com/${NUM}/eng/microcode-${PV}.tgz"

LICENSE="intel-ucode"
SLOT="0"
KEYWORDS="-* amd64 x86"

# We're breaking the expectations set by the official Gentoo ebuilds but we're
# keeping the USE flags so that we can either warn users or die in case they
# try an unsupported configuration.
IUSE="initramfs +split-ucode"
REQUIRED_USE="|| ( initramfs split-ucode )"

DEPEND="sys-apps/iucode_tool"
RDEPEND="${DEPEND}"

S=${WORKDIR}

pkg_pretend() {
	if [[ "${MICROCODE_SIGNATURES}x" != "x" ]]; then
		ewarn "this ebuild does not support MICROCODE_SIGNATURES customization."
		ewarn "the MICROCODE_SIGNATURES setting will be ignored."
	fi
}

src_install() {
	use initramfs && die "This ebuild does not support the normally supported initramfs USE flag"

	MICROCODE_SRC=(
		"${S}"/intel-ucode/
	)
	if kernel_is ge 4 14 34 || ! use kernel_linux ; then
		MICROCODE_SRC+=("${S}"/intel-ucode-with-caveats/)
	else
		ewarn "Using Linux < 4.14.34. Preventing installation of microcodes requiring newer kernel loading code"
	fi

	insinto /lib/firmware/intel-ucode
	for d in "${MICROCODE_SRC[@]}"; do
		rm -f "${d}"/list
		(cd "${d}" ; ls | xargs -n1 doins)
	done

	dodoc releasenote
}

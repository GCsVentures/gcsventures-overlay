# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit autotools toolchain-funcs multilib-minimal

DESCRIPTION="Jemalloc is a general-purpose scalable concurrent allocator"
HOMEPAGE="http://jemalloc.net/ https://github.com/jemalloc/jemalloc"
SRC_URI="https://github.com/jemalloc/jemalloc/releases/download/${PV}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0/2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x64-solaris"
IUSE="debug stats xmalloc"
HTML_DOCS=( doc/jemalloc.html )
PATCHES=( "${FILESDIR}/${PN}-5.3.0-gentoo-fixups.patch" )

MULTILIB_WRAPPED_HEADERS=( /usr/include/jemalloc/jemalloc.h )

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	local myconf=(
		$(use_enable debug)
		$(use_enable stats)
		$(use_enable xmalloc)
		--disable-libdl
	)

	ECONF_SOURCE="${S}" econf "${myconf[@]}"
}

multilib_src_compile() {
	default
	emake -j1 check
}

multilib_src_install() {
	# Copy man file which the Makefile looks for
	cp "${S}/doc/jemalloc.3" "${BUILD_DIR}/doc" || die
	emake DESTDIR="${D}" install
}

multilib_src_install_all() {
	if [[ ${CHOST} == *-darwin* ]] ; then
		# fixup install_name, #437362
		install_name_tool \
			-id "${EPREFIX}"/usr/$(get_libdir)/libjemalloc.2.dylib \
			"${ED}"/usr/$(get_libdir)/libjemalloc.2.dylib || die
	fi
	find "${ED}" -name '*.a' -delete || die
}

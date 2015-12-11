# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1 eutils

DESCRIPTION="Versatile replacement for vmstat, iostat and ifstat"
HOMEPAGE="http://dag.wieers.com/home-made/dstat/"
SRC_URI="http://dag.wieers.com/home-made/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 hppa ~ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE="wifi"

RDEPEND="wifi? ( net-wireless/python-wifi )"
DEPEND=""

src_compile() {
	true
}

src_install() {
	emake DESTDIR="${ED}" install
	python_fix_shebang "${ED}usr/bin/dstat"

	dodoc \
		AUTHORS ChangeLog README TODO \
		examples/{mstat,read}.py docs/*.txt
	dohtml docs/*.html
}

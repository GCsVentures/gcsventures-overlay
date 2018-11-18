# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

DESCRIPTION="A dependancy manager for PHP"
HOMEPAGE="http://getcomposer.org"

SRC_URI="http://getcomposer.org/download/${PV}/composer.phar -> ${P}.phar"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/php-5.3.4"
RDEPEND="dev-lang/php[zip,gmp,xmlreader]"

src_unpack() {
	cp "${DISTDIR}/${A}" "${WORKDIR}"
	S=${WORKDIR}
}

src_install() {
	mv "${WORKDIR}/${A}" "${WORKDIR}/composer"
	dobin composer
}

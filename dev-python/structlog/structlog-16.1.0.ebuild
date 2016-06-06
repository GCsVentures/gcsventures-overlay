# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_4 python3_5 )
inherit distutils-r1

DESCRIPTION="Structured logging for Python"
HOMEPAGE="https://pypi.python.org/pypi/structlog"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0 MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dev"

DEPEND="
  dev-python/six
"
RDEPEND="${DEPEND}
  dev? ( dev-python/colorama )
"

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_4 python3_5 )
inherit distutils-r1

DESCRIPTION="Graphite-web, without the interface. Just the rendering HTTP API."
HOMEPAGE="https://pypi.python.org/pypi/graphite-api"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cache cyanite sentry statsd"

DEPEND="
  dev-python/flask
  dev-python/pyyaml
  dev-python/cairocffi
  >=dev-python/pyparsing-1.5.7
  dev-python/pytz
  dev-python/six
  dev-python/structlog
  dev-python/tzlocal
"
RDEPEND="
  ${DEPEND}
  cache? ( dev-python/flask-cache )
  cyanite? ( dev-python/cyanite )
  sentry? ( dev-python/raven[flask] )
  statsd? ( dev-python/statsd )
"

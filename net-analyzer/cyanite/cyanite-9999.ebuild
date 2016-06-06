# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3 java-utils-2 user


DESCRIPTION="Cyanite graphite-compatible, cassandra-backed timeseries storage engine"
HOMEPAGE="http://cyanite.io/"
EGIT_REPO_URI="git://github.com/pyr/cyanite"

LICENSE="MISC-FREE"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
  dev-java/leiningen-bin
  virtual/jdk:1.8
"
RDEPEND="${DEPEND}"

pkg_setup() {
  enewgroup cyanite
  enewuser cyanite -1 -1 -1 cyanite
}

src_compile() {
  cd "${S}"
  lein uberjar
}

src_install() {
  java-pkg_newjar "${S}/target/cyanite-0.5.1-standalone.jar"

  insinto /etc/
  doins "${FILESDIR}/cyanite.yml"
  fowners cyanite:cyanite /etc/cyanite.yml
  fperms 0640 /etc/cyanite.yml

  newconfd "${FILESDIR}/confd" cyanite
  newinitd "${FILESDIR}/initd" cyanite

  diropts -m0750 -o cyanite -g cyanite
  keepdir /var/log/cyanite
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit unpacker user eutils flag-o-matic cmake-utils

SRC_URI="https://github.com/mariadb-corporation/MaxScale/archive/${PV}.tar.gz"
KEYWORDS=""
SLOT="0"

DESCRIPTION="MaxScale is an intelligent proxy"
HOMEPAGE="https://github.com/mariadb-corporation/MaxScale"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="binlog-router jemalloc rabbitmq log-sessions-at-message-level tcmalloc"

RDEPEND=""
DEPEND="${RDEPEND}
dev-libs/libaio
>=dev-libs/libedit-2.11
>=sys-devel/gcc-4.6.3
>=sys-libs/glibc-2.16.0
>=dev-util/cmake-2.8.12
dev-db/mariadb[embedded]
sys-devel/bison
sys-devel/flex
virtual/mysql[embedded]
jemalloc? ( dev-libs/jemalloc )
tcmalloc? ( dev-util/google-perftools )
rabbitmq? ( net-libs/rabbitmq-c )"

REQUIRED_USE="
    ${REQUIRED_USE} tcmalloc? ( !jemalloc ) jemalloc? ( !tcmalloc )
"

MAKEOPTS="-j1"

pkg_setup() {
	enewgroup maxscale
	enewuser maxscale -1 -1 -1 maxscale
}

S="${WORKDIR}/MaxScale-${PVR}"

src_prepare() {
#  if use log-sessions-at-message-level; then
#    epatch "${FILESDIR}"/session.c.log_session_start_at_message_level.patch
#  fi
#
#  epatch "${FILESDIR}"/remove_dangerous_rpath_12.patch
  eapply "${FILESDIR}"/141_logmanager.patch
  eapply "${FILESDIR}"/141_rpath.patch
  eapply_user
}

src_configure() {
	local mycmakeargs=(
		-DSTATIC_EMBEDDED=OFF
		-DWITH_SCRIPTS=OFF
		-DBUILD_BINLOG=$(usex binlog-router)
		-DBUILD_RABBITMQ=$(usex rabbitmq)
		-DWITH_JEMALLOC=$(usex jemalloc)
		-DWITH_TCMALLOC=$(usex tcmalloc)
		-DMODULE_INSTALL_PATH=$(get_libdir)/${PN}
		-DCMAKE_INSTALL_RPATH="${ROOT}/usr/lib64/maxscale:${ROOT}/usr/lib64/mysql/plugin:${ROOT}/usr/lib64/mysql"
	)
	cmake-utils_src_configure
}

#src_compile() {
#    #append-ldflags "-Wl,-rpath,/usr/lib64"
#	# TODO TODO TODO : Check cmake args for 1.4.1
#    cmake_args="-DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_RPATH=/usr/lib64/mysql/ -DSTATIC_EMBEDDED=FALSE -DINSTALL_SYSTEM_FILES=FALSE -DWITH_SCRIPTS=FALSE"
#
#	mkdir ${S}/build
#	cd ${S}/build
#	cmake $cmake_args ..
#	emake || die
#}

src_install() {
	#cd ${S}/build
	#emake install DESTDIR="${D}" || die
	#chown -R maxscale:maxscale "${D}"
	newinitd "${FILESDIR}/init-server-12" ${PN}
	newconfd "${FILESDIR}/confd-server-12" ${PN}
	local DOCS=( README "${BUILD_DIR}"/Changelog.txt "${BUILD_DIR}"/ReleaseNotes.txt )
	cmake-utils_src_install
	# Remove badly placed documents
	rm "${D}usr/share/${PN}/README" "${D}usr/share/${PN}/Changelog.txt" \
		"${D}usr/share/${PN}/LICENSE" "${D}usr/share/${PN}/COPYRIGHT" \
		"${D}usr/share/${PN}/ReleaseNotes.txt" || die
	#newinitd "${FILESDIR}/${PN}-init.d" ${PN}
	keepdir /var/log/maxscale /var/lib/maxscale/data
	fowners maxscale:maxscale /var/log/maxscale \
		/var/lib/maxscale/data \
		/var/lib/maxscale
}

pkg_postinst() {
	ewarn ""
	ewarn "Before you can start Maxscale, you have to"
	ewarn "create /etc/maxscale.cnf"
	ewarn ""
	ewarn "You can use /etc/maxscale_template.cnf"
	ewarn "as an example."
}

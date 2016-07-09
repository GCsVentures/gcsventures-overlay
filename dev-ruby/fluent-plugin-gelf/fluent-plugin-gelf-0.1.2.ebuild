# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
USE_RUBY="ruby22 ruby23"

inherit ruby-fakegem

DESCRIPTION="Gelf output plugin for fluentd"
HOMEPAGE="https://github.com/Home24/fluent-plugin-gelf"
SRC_URI="https://github.com/Home24/fluent-plugin-gelf/archive/${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/gelf-2.0.0"

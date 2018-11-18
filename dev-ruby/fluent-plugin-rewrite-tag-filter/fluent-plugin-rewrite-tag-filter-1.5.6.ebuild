# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby22 ruby23 ruby24"

inherit ruby-fakegem

DESCRIPTION="Re-emit a record with rewrited tag using regex matches"
HOMEPAGE="https://github.com/fluent/fluent-plugin-rewrite-tag-filter"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_rdepend "app-admin/fluentd"

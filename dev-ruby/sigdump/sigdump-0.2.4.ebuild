# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby22 ruby23 ruby24"

inherit ruby-fakegem

DESCRIPTION="Setup signal handler for running threads backtrace dumps and allocation stats"
HOMEPAGE="https://rubygems.org/gems/sigdump"

LICENSE="GPL-2+ Ruby"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

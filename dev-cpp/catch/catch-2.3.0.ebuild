# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{5,6,7} )

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
inherit cmake-utils python-any-r1

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/catchorg/Catch2.git"
else
	MY_P=${PN^}2-${PV}
	SRC_URI="https://github.com/catchorg/Catch2/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"
	KEYWORDS="~amd64 x86"

	S=${WORKDIR}/${MY_P}
fi

DESCRIPTION="Modern C++ header-only framework for unit-tests"
HOMEPAGE="https://github.com/catchorg/Catch2"

LICENSE="Boost-1.0"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( ${PYTHON_DEPS} )"

PATCHES=(
	"${FILESDIR}"/${PN}-2.3.0-python-automagic.patch
)

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DCATCH_ENABLE_WERROR=OFF
		-DBUILD_TESTING=$(usex test)
		-DCMAKE_INSTALL_DOCDIR="share/doc/${PF}"
		-DPYTHON_EXECUTABLE="${PYTHON}"
	)
	cmake-utils_src_configure
}

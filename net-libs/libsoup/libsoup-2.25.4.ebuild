# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI=2

inherit autotools gnome2

DESCRIPTION="An HTTP library implementation in C"
HOMEPAGE="http://www.gnome.org/"

LICENSE="LGPL-2"
SLOT="2.4"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="debug doc gnome ssl"

RDEPEND="
	>=dev-libs/glib-2.15.3
	>=dev-libs/libxml2-2
	gnome? ( 
		net-libs/libproxy
		dev-db/sqlite:3 )
	ssl? ( >=net-libs/gnutls-1 )"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9
	doc? ( >=dev-util/gtk-doc-1 )"

DOCS="AUTHORS ChangeLog NEWS README"

# FIXME: test fails in "forms-test"; nothing wrong with libsoup?
# ./forms-test -d
# MD5 tests (POST, multipart/form-data)
#   via curl: WRONG!
#   expected '0507f7de0b4f20cbab3f7a18d01912ec', got ''
#   via libsoup: OK!
#
# forms-test: 1 error(s).

pkg_setup() {
	# Do NOT build with --disable-debug/--enable-debug=no
	if use debug ; then
		G2CONF="${G2CONF} --enable-debug=yes"
	fi

	G2CONF="${G2CONF}
		$(use_with gnome)
		$(use_with gnome libproxy)
		$(use_enable ssl)"
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-fix-libproxy-automagic.patch"
	eautoreconf
}

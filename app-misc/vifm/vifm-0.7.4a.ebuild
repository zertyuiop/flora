# Distributed under the terms of the GNU General Public License v2

EAPI=4
inherit base

DESCRIPTION="Console file manager with vi(m)-like keybindings"
HOMEPAGE="http://vifm.sourceforge.net/"
SRC_URI="mirror://sourceforge/vifm/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~s390 ~x86"
IUSE="+X +extended-keys +magic +gtk vim-plugin vim-syntax"

DEPEND="
	>=sys-libs/ncurses-5.7-r7
	magic? ( sys-apps/file )
	gtk? ( x11-libs/gtk+:2 )
	X? ( x11-libs/libX11 )
"
RDEPEND="
	${DEPEND}
	vim-plugin? ( >=app-editors/vim-7.3 )
	vim-syntax? ( || ( app-editors/vim app-editors/gvim ) )
"

DOCS=( AUTHORS TODO README )

src_configure() {
	econf \
		$(use_enable extended-keys) \
		$(use_with magic libmagic) \
		$(use_with gtk) \
		$(use_with X X11)
}

src_install() {
	base_src_install

	# file below is needed for enabling vimhelp
	insinto /usr/share/${PN}
	doins "${S}"/data/vim/doc/vifm.txt

	if use vim-syntax; then
		local t
		for t in ftdetect ftplugin syntax; do
			insinto /usr/share/vim/vimfiles/"${t}"
			doins "${S}"/data/vim/"${t}"/"${PN}".vim
		done
	fi

	if use vim-plugin; then
		local t
		for t in doc plugin; do
			insinto /usr/share/vim/vimfiles/"${t}"
			doins "${S}"/data/vim/"${t}"/"${PN}".*
		done
	fi
}

pkg_postinst() {
	elog "To use vim to view the vifm help, copy /usr/share/${PN}/vifm.txt"
	elog "	to ~/.vim/doc/ and run ':helptags ~/.vim/doc' in vim,"
	elog "then edit ~/.vifm/vifmrc and set vimhelp instead of novimhelp"
	elog ""
	elog "To use the vifm plugin in vim, copy /usr/share/vim/vimfiles/vifm.vim to"
	elog "	/usr/share/vim/vimXX/"
}
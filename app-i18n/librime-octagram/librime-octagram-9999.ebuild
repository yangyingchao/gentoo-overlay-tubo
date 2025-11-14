# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
LUA_COMPAT=( lua5-{3..4} )

inherit cmake git-r3

EGIT_REPO_URI="https://github.com/lotem/librime-octagram"
DESCRIPTION="Lua module for RIME"
HOMEPAGE="https://github.com/lotem/librime-octagram"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

BDEPEND=""
RDEPEND="app-i18n/librime
 dev-libs/utfcpp"
DEPEND="${RDEPEND}
	dev-libs/boost:0"

src_prepare() {
	sed \
		-e "1icmake_minimum_required(VERSION 3.0)\nproject(${PN})\n" \
		-e "s/ PARENT_SCOPE//" \
		-e "\$a\\\n" \
		-e "\$aadd_library(\${plugin_modules} MODULE \${plugin_objs})" \
		-e "\$aset_target_properties(\${plugin_modules} PROPERTIES PREFIX \"\")" \
		-e "\$atarget_link_libraries(\${plugin_modules} rime \${plugin_deps})" \
		-e "\$ainstall(TARGETS \${plugin_modules} DESTINATION $(get_libdir)/rime-plugins)" \
		-i CMakeLists.txt || die
	sed \
		-e "\$atarget_link_libraries(build_grammar glog rime \${rime_library} \${rime_dict_library})" \
		-e "\$ainstall(TARGETS build_grammar DESTINATION bin)" \
		-i tools/CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	cmake_src_configure
}

EAPI=8

inherit cmake

DESCRIPTION="The hyprland cursor format, library and utilities"
HOMEPAGE="https://github.com/hyprwm/hyprutils"
SRC_URI="https://github.com/hyprwm/hyprutils/archive/v${PV}.tar.gz -> ${P}.tar.gz"
		 # https://github.com/hyprwm/hyprutils/releases/download/v0.1.2/v0.1.2.tar.gz

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64"

# Disable tests since as per upstream, tests require a theme to be installed
# See also https://github.com/hyprwm/hyprcursor/commit/94361fd8a75178b92c4bb24dcd8c7fac8423acf3
RESTRICT="test"

RDEPEND="
	dev-cpp/tomlplusplus
	>=dev-libs/hyprlang-0.4.2
	dev-libs/libzip
	gnome-base/librsvg:2
	x11-libs/cairo
"

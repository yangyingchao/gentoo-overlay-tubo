EAPI=7

DESCRIPTION="dependecies for emacs."
HOMEPAGE="HOMEPAGE"

SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="+cairo +gif +jit +jpeg +json +libxml2 +svg +png +sqlite +threads +tiff +webp +wide-int +xft +zlib"

RDEPEND="jit? (
		sys-devel/gcc:=[jit(-)]
		sys-libs/zlib
	)
	json? ( dev-libs/jansson:= )
	libxml2? ( >=dev-libs/libxml2-2.2.0 )
	sqlite? ( dev-db/sqlite:3 )
	zlib? ( sys-libs/zlib )
	gif? ( media-libs/giflib:0= )
	jpeg? ( media-libs/libjpeg-turbo:0= )
	png? ( >=media-libs/libpng-1.4:0= )
	svg? ( >=gnome-base/librsvg-2.0 )
	tiff? ( media-libs/tiff:= )
	webp? ( media-libs/libwebp:0= )
	"

DEPEND="${RDEPEND}"

BDEPEND=""

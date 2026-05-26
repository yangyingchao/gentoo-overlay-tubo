die() { echo >&2 "$*" && exit 1; }
[[ -f ~/.local/share/shell/yc-common.sh ]] && source ~/.local/share/shell/yc-common.sh

unpack_banner() { echo ">>> Unpacking ${1##*/} to ${PWD}"; }

# Unpack those pesky makeself generated files ...
unpack_makeself() {
	local src=$1
	local skip=$2
	local exe=$3

	[[ -z ${src} ]] && die "Could not locate source for '${src}'"

	unpack_banner "${src}"

	if [[ -z ${skip} ]]; then
		local ver=$(grep -m1 -a '#.*Makeself' "${src}" | awk '{print $NF}')
		local skip=0
		exe="tail"
		case ${ver} in
			1.5.* | 1.6.0-nv*) skip=$(grep -a ^skip= "${src}" | cut -d= -f2) ;;
			2.0 | 2.0.1) skip=$(grep -a ^$'\t'tail "${src}" | awk '{print $2}' | cut -b2-) ;;
			2.1.1)
				skip=$(grep -a ^offset= "${src}" | awk '{print $2}' | cut -b2-)
				((skip++))
				;;
			2.1.2)
				skip=$(grep -a ^offset= "${src}" | awk '{print $3}' | head -n 1)
				((skip++))
				;;
			2.1.3)
				skip=$(grep -a ^offset= "${src}" | awk '{print $3}')
				((skip++))
				;;
			2.1.4 | 2.1.5 | 2.1.6 | 2.2.0 | 2.3.0 | 2.4.0)
				skip=$(grep -a "offset=.*head.*wc" "${src}" | awk '{print $3}' | head -n 1)
				skip=$(head -n "${skip}" "${src}" | wc -c)
				exe="dd"
				;;
			*) die "makeself version '${ver}' not supported" ;;
		esac
		pinfo "Detected Makeself version ${ver} ... using ${skip} as offset"
	fi

	# shellcheck disable=SC2128
	case "${exe}" in
		tail) exe=(tail -n "+${skip}" "${src}") ;;
		dd) exe=(dd ibs="${skip}" skip=1 if="${src}") ;;
		*) die "makeself cant handle exe '${exe}'" ;;
	esac

	# lets grab the first few bytes of the file to figure out what kind of archive it is
	local filetype tmpfile="${FUNCNAME[0]}"
	"${exe[@]}" 2> /dev/null | head -c 512 > "${tmpfile}"
	filetype=$(file -b "${tmpfile}") || die
	rm "${tmpfile}"
	case ${filetype} in
		*tar | archive*) "${exe[@]}" | tar --no-same-owner -xf - ;;
		bzip2*) "${exe[@]}" | bzip2 -dc | tar --no-same-owner -xf - ;;
		gzip*) "${exe[@]}" | tar --no-same-owner -xzf - ;;
		compress*) "${exe[@]}" | gunzip | tar --no-same-owner -xf - ;;
		XZ*) "${exe[@]}" | unxz | tar --no-same-owner -xf - ;;
		*)
			echo "Unknown filetype \"${filetype}\" ?"
			false
			;;
	esac
}

# Unpack a Debian .deb archive in style.
unpack_deb() {
	[ $# -eq 1 ] || die "Usage: ${FUNCNAME[0]} <file>"
	local deb="$1"
	unpack_banner "${deb}"
	ar x "${deb}" || die
	unpacker ./data.tar*

	rm -f debian-binary {control,data}.tar*
}

# Unpack a cpio archive, file "-" means stdin.
unpack_cpio() {
	[[ $# -eq 1 ]] || die "Usage: ${FUNCNAME[0]} <file>"

	# needed as cpio always reads from stdin
	local cpio_cmd=(cpio --make-directories --extract --preserve-modification-time)
	if [[ $1 == "-" ]]; then
		unpack_banner "stdin"
		"${cpio_cmd[@]}"
	else
		local cpio="$1"
		unpack_banner "${cpio}"
		"${cpio_cmd[@]}" < "${cpio}"
	fi
}

# Unpack zip archives.
unpack_zip() {
	[[ $# -eq 1 ]] || die "Usage: ${FUNCNAME[0]} <file>"

	local zip="$1"
	unpack_banner "${zip}"

	command -v 7z > /dev/null 2>&1 && unpack_7z "$1" || unzip -qo "${zip}"

	[[ $? -le 1 ]] || die "unpacking ${zip} failed (arch=unpack_zip)"
}

# Unpack 7z archives.
unpack_7z() {
	[[ $# -eq 1 ]] || die "Usage: ${FUNCNAME[0]} <file>"

	local p7z="$1"
	unpack_banner "${p7z}"
	7z x -y "$p7z" || die "unpacking ${p7z} failed (arch=unpack_7z)"
}

# Unpack RAR archives.
unpack_rar() {
	[[ $# -eq 1 ]] || die "Usage: ${FUNCNAME[0]} <file>"

	local rar="$1"
	unpack_banner "${rar}"
	unrar x -idq -o+ "${rar}" || die "unpacking ${rar} failed (arch=unpack_rar)"
}

# Unpack LHA/LZH archives.
unpack_lha() {
	[[ $# -eq 1 ]] || die "Usage: ${FUNCNAME[0]} <file>"

	local lha="$1"
	unpack_banner "${lha}"
	lha xfq "${lha}" || die "unpacking ${lha} failed (arch=unpack_lha)"
}

# Unpack the contents of the specified rpms like the unpack() function.
unpack_rpm() {
	[[ $# -eq 0 ]] && set -- "${A}"
	local a
	for a in "$@"; do
		echo ">>> Unpacking ${a} to ${PWD}"
		if command -v rpm2tar > /dev/null 2>&1; then
			rpm2tar -O "${a}" | tar xf -
		elif command -v rpm2cpio > /dev/null 2>&1; then
			rpm2cpio "${a}" | cpio --make-directories --extract --preserve-modification-time
		else
			die "Requires rpm2tar or rpm2cpio"
		fi
	done
}

unpacker() {
	[[ $# -eq 1 ]] || die "Usage: ${FUNCNAME[0]} <file>"

	local a=$1
	local m=$(echo "${a}" | tr '[:upper:]' '[:lower:]')

	# first figure out the decompression method
	local comp=""
	case ${m} in
		*.bz2 | *.tbz | *.tbz2) comp="bzip2 -dc" ;;
		*.z | *.gz | *.tgz) comp="gzip -dc" ;;
		*.lzma | *.xz | *.txz) comp="xz -dc" ;;
		*.lz) comp="plzip -dc" ;;
		*.lz4) comp="lz4 -dc" ;;
		*.zst) comp="zstd -dfc" ;;
	esac

	# then figure out if there are any archiving aspects
	local arch=""
	local args=()
	case ${m} in
		*.tgz | *.tbz | *.tbz2 | *.txz | *.tar.* | *.tar) arch="tar --no-same-owner -xof" ;;
		*.cpio.* | *.cpio) arch="unpack_cpio" ;;
		*.deb) arch="unpack_deb" ;;
		*.whl | *.zip | *.jar) arch="unpack_zip" ;;
		*.rpm) arch="unpack_rpm" ;;
		*.7z | *.docx) arch="unpack_7z" ;;
		*.rar | *.RAR) arch="unpack_rar" ;;
		*.LHA | *.LHa | *.lha | *.lzh) arch="unpack_lha" ;;
		*.sh) head -n 30 "${a}" | grep -qs '#.*Makeself' && arch="unpack_makeself" ;;
		*.bin | *.run) # Makeself archives can be annoyingly named
			magic=$(hexdump -n 4 "$a" | head -n 1)
			case "${magic}" in
				"0000000 4b50 0403") arch="unpack_zip" ;;
				*)
					if head -c 512 "${a}" | grep -qs '#.*Makeself'; then
						arch="unpack_makeself"
					else
						skip=$(awk '/\x1f/{print NR;exit}' "${a}")
						if [ -n "${skip}" ] && [ "${skip}" -le 512 ]; then
							arch="unpack_makeself"
							args+=("$skip" "tail")
						fi
					fi
					;;
			esac
			;;
	esac

	# finally do the unpack
	[[ -z ${arch}${comp} ]] && die " Don't know how to unpack file: $1"
	[[ ${arch} != unpack_* ]] && unpack_banner "${a}"

	if [[ -z ${arch} ]]; then
		local _a=${a%.*}
		${comp} "${a}" > "${_a##*/}"
	elif [[ -z ${comp} ]]; then
		${arch} "${a}" "${args[@]}"
	else
		echo "${comp} \"${a}\" | ${arch} -"
		${comp} "${a}" | ${arch} -
	fi
}

my_unpack() {
	for fn in "$@"; do
		unpacker "$fn"
	done
}

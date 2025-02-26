#!/usr/bin/env bash

# FILE: As helper of utils.bash that sources this file.

# Identify Hugo edition in a string, then reformat for further process.
# Example: `asdf latest hugo ex-0.103` → "extended-0.103".
# @arg $1 string As local query.
# @stdout "$edition$release".
#   Edition can be "extended-" or empty.
#   Release is just remaining part of the argument, or empty.
format_query() {
	local query="$1"

	if [[ "$query" == '[0-9]' ]]; then
		# printf "Default in cli. i.e. No user input.\n" >&2
		echo ""
		return # early.
	fi

	local edition release

	if [[ "$query" =~ ^e(x(t(e(n(d(e(d)?)?)?)?)?)?)(-(.*))?$ ]]; then
		# printf "Case matched: ex(tended) or ex(tended)-something\n" >&2
		release="${BASH_REMATCH[9]}"
		if [[ -z "$release" ]]; then
			edition='extended'
		else
			edition='extended-'
		fi
		# for i in "${!BASH_REMATCH[@]}"; do
		# 	printf "BASH_REMATCH[%s] : %s\n" "$i" "${BASH_REMATCH[$i]}" >&2
		# done
		# printf "Query edition=\"%s\" release=\"%s\"\n" "$edition" "$release" >&2
		echo "${edition}${release}"
		return # early.
	fi

	# printf "Query edition=\"\" release=\"%s\"\n" "$query" >&2
	echo "$query"
}

parse_version() {
	local version="$1" # Requested $version in utils.bash file. Example: "extended-0.104.3".
	local parsed_version

	if [[ "${ASDF_HUGO_INSTALL_EXTENDED:-}" = true ]]; then
		# Users may manually input "extended-" during install.
		parsed_version="extended-${version#extended-}"
	else
		parsed_version="$version"
	fi

	echo "$parsed_version"
}

get_kernel() {
	local kernel='unsupported_kernel'
	local uname_kernel
	uname_kernel="$(uname -s | tr '[:upper:]' '[:lower:]')"

	case "$uname_kernel" in
		'linux' | 'darwin' | 'dragonfly' | 'freebsd' | 'netbsd' | 'openbsd')
			kernel="$uname_kernel"
			;;
	esac

	echo "$kernel"
}

get_arch() {
	local arch='unsupported_arch'
	local uname_arch
	uname_arch="$(uname -m | tr '[:upper:]' '[:lower:]')"
	case "$uname_arch" in
		'amd64' | 'x86_64' | 'i686-64' | 'k1om')
			arch='amd64'
			;;
		'386' | 'i686' | 'i386' | 'x86')
			arch='386'
			;;
		'arm64' | 'aarch64')
			arch='arm64'
			;;
		'arm' | 'armv7l' | 'armv6l')
			arch='arm'
			;;
	esac

	echo "$arch"
}

# Param $1 as local gh_repo. The $GH_REPO in utils.bash file.
# Param $2 as local version. Requested $version in utils.bash file. Example: "extended-0.104.3".
# Returns {string} Example: "https://github.com/gohugoio/hugo/releases/download/v0.104.3/hugo_extended_0.104.3_darwin-universal.tar.gz".
create_release_url() {
	local gh_repo="$1"
	local version
	version="$(parse_version "$2")"

	local current_script_dir
	current_script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
	local release_version
	release_version="${version#extended-}" # Example: 0.104.3
	local kernel
	kernel="$(get_kernel)" # aka the GOOS.
	local arch
	arch="$(get_arch)" # aka the GOARCH.

	if [[ "$kernel" == unsupported* ]]; then
		echo "Detected kernel \"$(uname -s)\" but not supported."
		return 1 # early.
	fi
	if [[ "$arch" == unsupported* ]]; then
		echo "Detected arch \"$(uname -m)\" but not supported."
		return 1 # early.
	fi

	# If version <= 0.102:

	local major_version
	major_version=$(echo "$release_version" | cut -d. -f1)
	local minor_version
	minor_version=$(echo "$release_version" | cut -d. -f2)
	local csv_file_path="$current_script_dir/hugo_releases.csv"
	if [[ "$major_version" -eq 0 && "$minor_version" -lt 103 ]]; then
		local ex
		[[ "$version" == extended* ]] && ex='hasEx' || ex='noEx'
		local query_keyword="${kernel},${arch},${ex},${release_version}"
		local query_result
		query_result=$(grep -m 1 -- "$query_keyword" "$csv_file_path")
		if [[ -z $query_result ]]; then
			echo 'Version not exist in Hugo release'
			return 1 # early.
		fi
		local filename="${query_result#"$query_keyword,"}"
		# printf "query_keyword: %s\n" "$query_keyword" >&2
		# printf "query_result: %s\n" "$query_result" >&2
		# printf "filename: %s\n" "$filename" >&2
		echo "${gh_repo}/releases/download/v${release_version}/${filename}"
		return # early.
	fi

	# Else case:

	# Fix for macOS:
	if [[ "$kernel-$arch" == 'darwin-amd64' || "$kernel-$arch" == 'darwin-arm64' ]]; then
		arch="universal"
	fi

	local file_version="${version/#extended-/extended_}"
	# Example: "hugo_extended_0.104.3_darwin-universal.tar.gz"
	local filename="hugo_${file_version}_${kernel}-${arch}.tar.gz"

	echo "${gh_repo}/releases/download/v${release_version}/${filename}"
}

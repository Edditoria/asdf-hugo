#!/usr/bin/env bash

set -euo pipefail

# NOTE: Ensure this is the correct GitHub homepage where releases can be downloaded for hugo.
GH_REPO="https://github.com/gohugoio/hugo"
TOOL_NAME="hugo"
TOOL_TEST="hugo version"

# Import some functions for asdf-hugo.
current_script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
source "$current_script_dir/hugo_utils.bash"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if hugo is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
	# NOTE: By default, asdf simply lists the tag names from GitHub releases; In hugo-asdf, we add "extended-*" for each version.
	list_github_tags | sed 'p; s/^/extended-/'
}

download_release() {
	local version filename url
	version="$1"
	filename="$2"

	# NOTE: Adapted the release URL convention for hugo
	url=$(create_release_url "$GH_REPO" "$version") || fail "Could not download: $url"

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download: $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		# NOTE: Modified `cp` command: No `-r` and only copy the `hugo` binary.
		cp "$ASDF_DOWNLOAD_PATH"/hugo "$install_path"

		# NOTE: Asserted hugo executable exists.
		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}

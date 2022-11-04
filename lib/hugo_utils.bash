#!/usr/bin/env bash

# FILE: As helper of utils.bash that sources this file.

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
  local uname_kernel="$(uname -s | tr '[:upper:]' '[:lower:]')"

  case "$uname_kernel" in
    'linux' | 'darwin' | 'dragonfly' | 'freebsd' | 'netbsd' | 'openbsd')
      kernel="$uname_kernel"
      ;;
  esac

  echo "$kernel"
}

get_arch() {
  local arch='unsupported_arch'
  local uname_arch="$(uname -m | tr '[:upper:]' '[:lower:]')"
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
  local version="$(parse_version "$2")"

  local current_script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
  local release_version="${version#extended-}" # Example: 0.104.3
  local kernel="$(get_kernel)"                 # aka the GOOS.
  local arch="$(get_arch)"                     # aka the GOARCH.

  if [[ "$kernel" == unsupported* ]]; then
    echo "Detected kernel \"$(uname -s)\" but not supported."
    return 1 # early.
  fi
  if [[ "$arch" == unsupported* ]]; then
    echo "Detected arch \"$(uname -m)\" but not supported."
    return 1 # early.
  fi

  # If version <= 0.102:

  local major_version=$(echo $release_version | cut -d. -f1)
  local minor_version=$(echo $release_version | cut -d. -f2)
  local csv_file_path="$current_script_dir/hugo_releases.csv"
  if [[ "$major_version" -eq 0 && "$minor_version" -lt 103 ]]; then
    local ex
    [[ "$version" == extended* ]] && ex='hasEx' || ex='noEx'
    local query_keyword="${kernel},${arch},${ex},${release_version}"
    # echo "Query keyword: $query_keyword"
    local query_result="$(cat "$csv_file_path" | grep "$query_keyword" | head -1)"
    if [[ -z $query_result ]]; then
      echo 'Version not exist in Hugo release'
      return 1 # early.
    fi
    # echo "Query result: $query_result"
    local filename="${query_result#$query_keyword\,}"
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

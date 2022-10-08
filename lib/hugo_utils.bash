#!/usr/bin/env bash

# FILE: As helper of utils.bash that sources this file.

get_kernel() {
  local kernel='unsupported_kernel'
  local uname_kernel="$(uname -s | tr '[:upper:]' '[:lower:]')"

  case "$uname_kernel" in
    'linux'|'darwin'|'dragonfly'|'freebsd'|'netbsd'|'openbsd')
      kernel="$uname_kernel"
    ;;
  esac

  echo "$kernel"
}

get_arch() {
  local arch='unsupported_arch'
  local uname_arch="$(uname -m | tr '[:upper:]' '[:lower:]')"
  case "$uname_arch" in
    'amd64'|'x86_64'|'i686-64'|'k1om')
      arch='amd64'
    ;;
    '386'|'i686'|'i386'|'x86')
      arch='386'
    ;;
    'arm64'|'aarch64')
      arch='arm64'
    ;;
    'arm'|'armv7l'|'armv6l')
      arch='arm'
    ;;
  esac

  echo "$arch"
}

# TODO: Temp only work with Hugo `0.104.*`.
# Returns {string} Example: "https://github.com/gohugoio/hugo/releases/download/v0.104.3/hugo_extended_0.104.3_darwin-universal.tar.gz".
create_release_url() {
  local gh_repo="$1" # $GH_REPO in utils.bash file.
  local version="$2" # Requested $version in utils.bash file. Example: "extended-0.104.3".

  local release_version="${version#extended-}"
  local file_version="${version/#extended-/extended_}"

  local kernel="$(get_kernel)" # aka the GOOS.
  local arch="$(get_arch)" # aka the GOARCH.
  if [[ "$kernel" == unsupported* ]]; then
    echo "Detected kernel \"$(uname -s)\" but not supported."
    return 1
  fi
  if [[ "$arch" == unsupported* ]]; then
    echo "Detected arch \"$(uname -m)\" but not supported."
    return 1
  fi

  # Fix for macOS:
  if [[ "$kernel-$arch" == 'darwin-amd64' || "$kernel-$arch" == 'darwin-arm64' ]]; then
    arch="universal"
  fi

  # Example: "hugo_extended_0.104.3_darwin-universal.tar.gz"
  local filename="hugo_${file_version}_${kernel}-${arch}.tar.gz"

  echo "${gh_repo}/releases/download/v${release_version}/${filename}"
}

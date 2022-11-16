#!/bin/sh
# shellcheck disable=SC2155
set -eu
readonly curdir="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)"
"$curdir/src/erlang_otp_6435.escript" "$@"

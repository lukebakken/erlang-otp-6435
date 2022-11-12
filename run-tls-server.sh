#!/bin/sh
# shellcheck disable=SC2155
set -eu
readonly curdir="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)"
readonly logger_level="${1:-error}"
readonly tls_module="${2:-tls_server}"
erlc +debug "$curdir/src/$tls_module.erl"
erl -noinput -kernel logger_level "$logger_level" -s tls_server start

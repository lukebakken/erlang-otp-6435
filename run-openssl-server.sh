#!/bin/sh

set -eu

readonly curdir="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)"
readonly tlshost='localhost'
readonly tlsport=9999
readonly certs_dir="$curdir/certs"
readonly ca_file="$certs_dir/rootCA.pem"
readonly cert_file="$certs_dir/cert.pem"
readonly key_file="$certs_dir/key.pem"

# -tls1_3
# -no_ssl3 -no_tls1 -no_tls1_1
echo "[INFO] running 'openssl s_server -accept \"$tlshost:$tlsport\" -Verify 8 -verify_return_error\n\t-CAfile \"$ca_file\"\n\t-cert \"$cert_file\"\n\t-key \"$key_file\" \"$@\""

openssl s_server -accept "$tlshost:$tlsport" \
    -Verify 8 -verify_return_error \
    -CAfile "$ca_file" -cert "$cert_file" -key "$key_file" "$@"

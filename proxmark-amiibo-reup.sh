#!/bin/bash

AMIIBO_BIN=$1
if [ ! -f "$AMIIBO_BIN" ]; then
	echo "usage: $0 [amiibo.bin]"
	exit
fi

AMIIBO_TOOL=$(which amiibo)
if [ ! -n "$AMIIBO_TOOL" ]; then
	echo "PyAmiibo must be installed!"
	exit
fi

PM3_TOOL=$(which pm3)
if [ ! -n "$PM3_TOOL" ]; then
	echo "pm3 must be installed!"
	exit
fi

if [ ! -f "unfixed-info.bin" ]; then
	echo "PyAmiibo expects unfixed-info.bin in $(pwd)"
	exit
fi
if [ ! -f "locked-secret.bin" ]; then
	echo "PyAmiibo expects locked-secret.bin in $(pwd)"
	exit
fi

rm -rf /tmp/amiibo.bin

while true; do
	_UID=$(echo -n 04 && head -c6 < /dev/urandom | xxd -p -u)
	$AMIIBO_TOOL uid "$AMIIBO_BIN" "$_UID" /tmp/amiibo.bin
	printf '\x0F\xE0' | dd of=/tmp/amiibo.bin bs=1 seek=10 count=2 conv=notrunc 2>/dev/null
	$PM3_TOOL -c 'script run hf_mfu_amiibo_sim -f /tmp/amiibo.bin'
done

rm -rf /tmp/amiibo.bin

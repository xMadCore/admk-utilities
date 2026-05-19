#!/bin/bash
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
OUTPUT_DIR=~/

chmod +x $SCRIPT_DIR/help.sh
chmod +x $SCRIPT_DIR/switchbar.sh
chmod +x $SCRIPT_DIR/timefix.sh

cp -f $SCRIPT_DIR/help.sh $OUTPUT_DIR/.
cp -f $SCRIPT_DIR/switchbar.sh $OUTPUT_DIR/.
cp -f $SCRIPT_DIR/timefix.sh $OUTPUT_DIR/.

#!/bin/bash
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
OUTPUT_DIR=~/

cp -f $SCRIPT_DIR/help.sh $OUTPUT_DIR/.
cp -f $SCRIPT_DIR/switchbar.sh $OUTPUT_DIR/.
cp -f $SCRIPT_DIR/timefix.sh $OUTPUT_DIR/.

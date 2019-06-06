#!/bin/bash
# Copy this script to the folder native of your neon plugin (see location in run.sh)
# This script gets run by the docker container after all dependencies have been unpacked and before the compiling starts
# 


cp $SYSROOT/usr/include/arm-linux-gnueabihf/openssl/opensslconf.h $SYSROOT/usr/include/openssl/
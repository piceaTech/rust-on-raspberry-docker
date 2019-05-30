#!/bin/bash
set -e;

printf "*** Extracting target dependencies ***\n";

export SYSROOT="$HOME/pi-tools/arm-bcm2708/arm-linux-gnueabihf/arm-linux-gnueabihf/sysroot"
if [ -d "$HOME/deb-deps" ]; then
	cd $SYSROOT;

	for i in `find $HOME/deb-deps -name "*.deb" -type f`; do
    	echo "Extracting: $i";
    	ar -p $i data.tar.xz > "$i.tar.xz";
			tar xf "$i.tar.xz"
	done
fi

printf "\n*** Misc other steps ***\n";

if [ -f $HOME/project/native/intermediate.sh ]; then
    $HOME/project/native/intermediate.sh;
fi

printf "\n*** Cross compiling project ***\n";
cd $HOME/project;

if [ $(uname -m) == 'x86_64' ]; then
  TOOLCHAIN="/home/node/pi-tools/arm-bcm2708/arm-linux-gnueabihf/bin";
else
	TOOLCHAIN=$TOOLCHAIN_32;
fi



#Include the cross compilation binaries
export PATH="/home/node/.cargo/bin:$TOOLCHAIN:$PATH";


export TARGET_CROSS="${TOOLCHAIN}/arm-linux-gnueabihf-" # Damit ich es nicht überall doppelt angeben muss

export CC="gcc-sysroot" # muss so sein, weil die crates das mit Parametern nicht unterstützen
export CXX="g++-sysroot"  # $OPTS
export AR="${TARGET_CROSS}ar"
export RANLIB=${TARGET_CROSS}ranlib
export LINK="g++-sysroot"  # $OPTS
export STRIP=${TARGET_CROSS}strip
export OBJCOPY=${TARGET_CROSS}objcopy
export LD="g++-sysroot"  # $OPTS
export OBJDUMP=${TARGET_CROSS}objdump
export NM=${TARGET_CROSS}nm
export AS=${TARGET_CROSS}as

export PKG_CONFIG_ALLOW_CROSS=1
export PKG_CONFIG_SYSROOT_DIR=$SYSROOT
export PKG_CONFIG_PATH=$SYSROOT/usr/lib/arm-linux-gnueabihf/pkgconfig/


export CCFLAGS='-fPIC'
export CPPPATH=${SYSROOT}usr/include/
export LIBPATH=${SYSROOT}usr/lib/

node ./node_modules/neon-cli/bin/cli.js +stable build -r

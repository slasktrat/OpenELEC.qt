################################################################################
#
##  This Program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  #  the Free Software Foundation; either version 2, or (at your option)
#  any later version.
#  #
#  This Program is distributed in the hope that it will be useful,
#  #  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  #  GNU General Public License for more details.
#
##  You should have received a copy of the GNU General Public License
#  along with OpenELEC.tv; see the file COPYING.  If not, write to
#  #  the Free Software Foundation, 51 Franklin Street, Suite 500, Boston, MA 02110, USA.
#  http://www.gnu.org/copyleft/gpl.html
#  ################################################################################

PKG_NAME="qt5"
PKG_VERSION="5.2.1"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://qt-project.org"
PKG_URL="http://download.qt-project.org/official_releases/qt/5.2/5.2.1/single/qt-everywhere-opensource-src-5.2.1.tar.gz"
PKG_DEPENDS="bcm2835-driver bzip2 Python zlib:host zlib libpng tiff dbus glib fontconfigeglibc liberation-fonts-ttf font-util font-xfree86-type1 font-misc-misc gstreamer gst-plugins-base gst-plugins-good gst-omx gst-plugins-bad alsa"
PKG_BUILD_DEPENDS_TARGET="bcm2835-driver bzip2 Python zlib:host zlib libpng tiff dbus glib fontconfig mysql openssl linux-headers eglibc gstreamer gst-plugins-base gst-plugins-good gst-omx gst-plugins-bad alsa"

PKG_PRIORITY="optional"
PKG_SECTION="lib"
PKG_SHORTDESC="gstreamer good plugins"
PKG_LONGDESC="gstreamer good plugins"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS="-v \
				    -prefix ${ROOT}/${BUILD}/image/system/usr \
				    -hostprefix ${SYSROOT_PREFIX}/usr \
					-release \
					-opensource \
					-confirm-license \
					-no-pch \
					-no-rpath \
					-optimized-qmake \
					-compile-examples \
					-skip qtwebkit \
					-silent \
					-device linux-rasp-pi-g++ \
					-device-option CROSS_COMPILE=${ROOT}/${TOOLCHAIN}/bin/armv6zk-openelec-linux-gnueabi- \
					-opengl \
					-I $SYSROOT_PREFIX/usr/include/interface/vmcs_host \
					-I $SYSROOT_PREFIX/usr/include/gstreamer-1.0 \
					-I $SYSROOT_PREFIX/usr/include/glib-2.0 \
					-I $SYSROOT_PREFIX/usr/lib/glib-2.0/include \
					-make libs \
					-nomake tests"

unpack() {

  tar -xzf $SOURCES/${PKG_NAME}/qt-everywhere-opensource-src-${PKG_VERSION}.tar.gz -C $BUILD/
  mv $BUILD/qt-everywhere-opensource-src-${PKG_VERSION} $BUILD/${PKG_NAME}-${PKG_VERSION}
}

configure_target() {

	unset CC CXX AR OBJCOPY STRIP CFLAGS CXXFLAGS CPPFLAGS LDFLAGS LD RANLIB
	export QT_FORCE_PKGCONFIG=yes
	unset QMAKESPEC

	cp $SYSROOT_PREFIX/usr/include/interface/vcos/pthreads/vcos_platform_types.h $SYSROOT_PREFIX/usr/include/interface/vcos/
	cp $SYSROOT_PREFIX/usr/include/interface/vcos/pthreads/vcos_platform.h $SYSROOT_PREFIX/usr/include/interface/vcos/
	cp $SYSROOT_PREFIX/usr/include/interface/vmcs_host/linux/vchost_config.h $SYSROOT_PREFIX/usr/include/interface/vmcs_host/

	pushd ${ROOT}/${BUILD}/${PKG_NAME}-${PKG_VERSION}
	./configure ${PKG_CONFIGURE_OPTS}
	popd
}

make_target() {
	unset CC CXX AR OBJCOPY STRIP CFLAGS CXXFLAGS CPPFLAGS LDFLAGS LD RANLIB
	export QT_FORCE_PKGCONFIG=yes
	unset QMAKESPEC

	pushd ${ROOT}/${BUILD}/${PKG_NAME}-${PKG_VERSION}
    make
	popd
}

makeinstall_target() {
	unset CC CXX AR OBJCOPY STRIP CFLAGS CXXFLAGS CPPFLAGS LDFLAGS LD RANLIB
	export QT_FORCE_PKGCONFIG=yes
	unset QMAKESPEC

	pushd ${ROOT}/${PKG_BUILD}
	make install
	popd
}

pre_install() {
	makeinstall_target
}

post_install() {
	# need to remove libc.so and libpthread.so linker scripts to enable cross compilation with qmake.
	# otherwise it would try to fail when linking with the wrong libraries.
	
	rm $ROOT/$INSTALL/usr/lib/libc.so
	rm $ROOT/$INSTALL/usr/lib/libpthread.so
}


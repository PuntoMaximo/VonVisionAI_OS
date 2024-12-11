################################################################################
#
# ffmpeg
#
################################################################################

FFMPEG_VERSION = ba84e56c51d9cde1f3b1fead2a21e4d271028709
FFMPEG_SITE = https://github.com/nyanmisaka/ffmpeg-rockchip
FFMPEG_SITE_METHOD = git

FFMPEG_INSTALL_STAGING = YES

FFMPEG_LICENSE = LGPL-2.1+, libjpeg license
FFMPEG_LICENSE_FILES = LICENSE.md COPYING.LGPLv2.1
ifeq ($(BR2_PACKAGE_FFMPEG_GPL),y)
FFMPEG_LICENSE += and GPL-2.0+
FFMPEG_LICENSE_FILES += COPYING.GPLv2
endif

FFMPEG_CPE_ID_VENDOR = ffmpeg

FFMPEG_CONF_OPTS = \
	--enable-rkmpp \
	--enable-rkrga \
	--enable-libdrm \
	--enable-avdevice \
	--enable-avfilter \
	--enable-avformat \
	--enable-swscale \
	--enable-avcodec \
	--enable-version3 \
	--prefix=/usr \
	--enable-openssl 

FFMPEG_DEPENDENCIES += host-pkgconf
FFMPEG_DEPENDENCIES += mpp
FFMPEG_DEPENDENCIES += rockchip-rga

# Explicitly disable everything that doesn't match for ARM
# FFMPEG "autodetects" by compiling an extended instruction via AS
# This works on compilers that aren't built for generic by default
ifeq ($(BR2_ARM_CPU_ARMV4),y)
FFMPEG_CONF_OPTS += --disable-armv5te
endif
ifeq ($(BR2_ARM_CPU_ARMV6)$(BR2_ARM_CPU_ARMV7A),y)
FFMPEG_CONF_OPTS += --enable-armv6
else
FFMPEG_CONF_OPTS += --disable-armv6 --disable-armv6t2
endif
ifeq ($(BR2_ARM_CPU_HAS_VFPV2),y)
FFMPEG_CONF_OPTS += --enable-vfp
else
FFMPEG_CONF_OPTS += --disable-vfp
endif
ifeq ($(BR2_ARM_CPU_HAS_NEON),y)
FFMPEG_CONF_OPTS += --enable-neon
else ifeq ($(BR2_aarch64),y)
FFMPEG_CONF_OPTS += --enable-neon
else
FFMPEG_CONF_OPTS += --disable-neon
endif

ifeq ($(BR2_mips)$(BR2_mipsel)$(BR2_mips64)$(BR2_mips64el),y)
ifeq ($(BR2_MIPS_SOFT_FLOAT),y)
FFMPEG_CONF_OPTS += --disable-mipsfpu
else
FFMPEG_CONF_OPTS += --enable-mipsfpu
endif

# Fix build failure on several missing assembly instructions
FFMPEG_CONF_OPTS += --disable-asm
endif # MIPS

ifeq ($(BR2_POWERPC_CPU_HAS_ALTIVEC):$(BR2_powerpc64le),y:)
FFMPEG_CONF_OPTS += --enable-altivec
else ifeq ($(BR2_POWERPC_CPU_HAS_VSX):$(BR2_powerpc64le),y:y)
# On LE, ffmpeg AltiVec support needs VSX intrinsics, and VSX
# is an extension to AltiVec.
FFMPEG_CONF_OPTS += --enable-altivec
else
FFMPEG_CONF_OPTS += --disable-altivec
endif

# Uses __atomic_fetch_add_4
ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
FFMPEG_CONF_OPTS += --extra-libs=-latomic
endif

ifeq ($(BR2_STATIC_LIBS),)
FFMPEG_CONF_OPTS += --enable-pic
else
FFMPEG_CONF_OPTS += --disable-pic
endif

# Default to --cpu=generic for MIPS architecture, in order to avoid a
# warning from ffmpeg's configure script.
ifeq ($(BR2_mips)$(BR2_mipsel)$(BR2_mips64)$(BR2_mips64el),y)
FFMPEG_CONF_OPTS += --cpu=generic
else ifneq ($(GCC_TARGET_CPU),)
FFMPEG_CONF_OPTS += --cpu="$(GCC_TARGET_CPU)"
else ifneq ($(GCC_TARGET_ARCH),)
FFMPEG_CONF_OPTS += --cpu="$(GCC_TARGET_ARCH)"
endif

FFMPEG_CFLAGS = $(TARGET_CFLAGS)

ifeq ($(BR2_TOOLCHAIN_HAS_GCC_BUG_85180),y)
FFMPEG_CONF_OPTS += --disable-optimizations
FFMPEG_CFLAGS += -O0
endif

FFMPEG_CONF_ENV += CFLAGS="$(FFMPEG_CFLAGS)"
FFMPEG_CONF_OPTS += $(call qstrip,$(BR2_PACKAGE_FFMPEG_EXTRACONF))

# Override FFMPEG_CONFIGURE_CMDS: FFmpeg does not support --target and others
define FFMPEG_CONFIGURE_CMDS
	(cd $(FFMPEG_SRCDIR) && rm -rf config.cache && \
	$(TARGET_CONFIGURE_OPTS) \
	$(TARGET_CONFIGURE_ARGS) \
	$(FFMPEG_CONF_ENV) \
	./configure \
		--enable-cross-compile \
		--cross-prefix=$(TARGET_CROSS) \
		--sysroot=$(STAGING_DIR) \
		--host-cc="$(HOSTCC)" \
		--arch=$(BR2_ARCH) \
		--target-os="linux" \
		--disable-stripping \
		--pkg-config="$(PKG_CONFIG_HOST_BINARY)" \
		$(SHARED_STATIC_LIBS_OPTS) \
		$(FFMPEG_CONF_OPTS) \
	)
endef
	
FFMPEG_MAKE_OPTS = examples
	


$(eval $(autotools-package))

################################################################################
#
# rockchip-mali
#
################################################################################
	
ROCKCHIP_MALI_UPDATE_VERSION = tree/master		
ROCKCHIP_MALI_UPDATE_SITE_METHOD = git
ROCKCHIP_MALI_UPDATE_SITE = https://github.com/tsukumijima/libmali-rockchip.git
ROCKCHIP_MALI_UPDATE_LICENSE = Proprietary
ROCKCHIP_MALI_UPDATE_LICENSE_FILES = END_USER_LICENCE_AGREEMENT.txt
ROCKCHIP_MALI_UPDATE_INSTALL_STAGING = YES

ROCKCHIP_MALI_UPDATE_LIB = libmali-bifrost-g52-g2p0-x11.so
ROCKCHIP_MALI_UPDATE_PKGCONFIG_FILES = egl gbm glesv2 mali
ROCKCHIP_MALI_UPDATE_ARCH_DIR = $(if $(BR2_arm)$(BR2_armeb),arm-linux-gnueabihf,aarch64-linux-gnu)
ROCKCHIP_MALI_UPDATE_HEADERS = EGL FBDEV GLES GLES2 GLES3 KHR gbm.h

# We need to create:
# - The symlink that matches the library SONAME (libmali.so.1)
# - The .so symlinks needed at compile time by the compiler (*.so)
ROCKCHIP_MALI_UPDATE_LIB_SYMLINKS = \
	libmali.so.1 \
	libMali.so \
	libEGL.so \
	libgbm.so \
	libGLESv1_CM.so \
	libGLESv2.so

ifeq ($(BR2_PACKAGE_WAYLAND),y)
ROCKCHIP_MALI_UPDATE_SUFFIX = -wayland-gbm
ROCKCHIP_MALI_UPDATE_PKGCONFIG_FILES += wayland-egl
ROCKCHIP_MALI_UPDATE_LIB_SYMLINKS += libwayland-egl.so
ROCKCHIP_MALI_UPDATE_DEPENDENCIES += wayland
else
ROCKCHIP_MALI_UPDATE_SUFFIX = -gbm
endif

define ROCKCHIP_MALI_UPDATE_INSTALL_CMDS
# 	Install the library
	$(INSTALL) -D -m 0755 \
		$(@D)/lib/$(ROCKCHIP_MALI_UPDATE_ARCH_DIR)/$(ROCKCHIP_MALI_UPDATE_LIB) \
		$(1)/usr/lib/$(ROCKCHIP_MALI_UPDATE_LIB)

# 	Ensure it has a proper soname
	$(HOST_DIR)/bin/patchelf --set-soname libmali.so.1 \
		$(1)/usr/lib/$(ROCKCHIP_MALI_UPDATE_LIB)

#	Generate and install the .pc files
	mkdir -p $(1)/usr/lib/pkgconfig
	$(foreach pkgconfig,$(ROCKCHIP_MALI_UPDATE_PKGCONFIG_FILES), \
		sed -e 's%@CMAKE_INSTALL_LIBDIR@%lib%;s%@CMAKE_INSTALL_INCLUDEDIR@%include%' \
			$(@D)/pkgconfig/$(pkgconfig).pc.cmake > \
			$(1)/usr/lib/pkgconfig/$(pkgconfig).pc
	)

#	Install all headers
	$(foreach d,$(ROCKCHIP_MALI_UPDATE_HEADERS), \
		cp -dpfr $(@D)/include/$(d) $(1)/usr/include/
	)

#	Create symlinks
	$(foreach symlink,$(ROCKCHIP_MALI_UPDATE_LIB_SYMLINKS), \
		ln -sf $(ROCKCHIP_MALI_UPDATE_LIB) $(1)/usr/lib/$(symlink)
	)
endef

define ROCKCHIP_MALI_UPDATE_INSTALL_TARGET_CMDS
	$(call ROCKCHIP_MALI_UPDATE_INSTALL_CMDS,$(TARGET_DIR))
endef

define ROCKCHIP_MALI_UPDATE_INSTALL_STAGING_CMDS
	$(call ROCKCHIP_MALI_UPDATE_INSTALL_CMDS,$(STAGING_DIR))
endef

$(eval $(generic-package))

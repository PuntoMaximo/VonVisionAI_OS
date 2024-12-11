################################################################################
#
# rockchip-mali
#
################################################################################
	
ROCKCHIP_MALI_VERSION = 92183c8482e6173fa510f228e62b1c73c99be87d
ROCKCHIP_MALI_SITE = $(call github,JeffyCN,mirrors,$(ROCKCHIP_MALI_VERSION))
ROCKCHIP_MALI_LICENSE = Proprietary
ROCKCHIP_MALI_LICENSE_FILES = END_USER_LICENCE_AGREEMENT.txt
ROCKCHIP_MALI_INSTALL_STAGING = YES

ROCKCHIP_MALI_LIB = libmali-bifrost-g52-g2p0-x11-gbm.so
ROCKCHIP_MALI_PKGCONFIG_FILES = egl gbm glesv2 mali
ROCKCHIP_MALI_ARCH_DIR = $(if $(BR2_arm)$(BR2_armeb),arm-linux-gnueabihf,aarch64-linux-gnu)
ROCKCHIP_MALI_HEADERS = EGL GLES GLES2 GLES3 KHR

# We need to create:
# - The symlink that matches the library SONAME (libmali.so.1)
# - The .so symlinks needed at compile time by the compiler (*.so)
ROCKCHIP_MALI_LIB_SYMLINKS = \
	libmali.so.1 \
	libMali.so \
	libEGL.so \
	libgbm.so \
	libGLESv1_CM.so \
	libGLESv2.so \
	libGLESv2.so.2 \
	libEGL.so.1

ifeq ($(BR2_PACKAGE_WAYLAND),y)
ROCKCHIP_MALI_SUFFIX = -wayland-gbm
ROCKCHIP_MALI_PKGCONFIG_FILES += wayland-egl
ROCKCHIP_MALI_LIB_SYMLINKS += libwayland-egl.so
ROCKCHIP_MALI_DEPENDENCIES += wayland
else
ROCKCHIP_MALI_SUFFIX = -gbm
endif

define ROCKCHIP_MALI_INSTALL_CMDS
# 	Install the library
	$(INSTALL) -D -m 0755 \
		$(@D)/lib/$(ROCKCHIP_MALI_ARCH_DIR)/$(ROCKCHIP_MALI_LIB) \
		$(1)/usr/lib/$(ROCKCHIP_MALI_LIB)

# 	Ensure it has a proper soname
	$(HOST_DIR)/bin/patchelf --set-soname libmali.so.1 \
		$(1)/usr/lib/$(ROCKCHIP_MALI_LIB)

#	Generate and install the .pc files
	mkdir -p $(1)/usr/lib/pkgconfig
	$(foreach pkgconfig,$(ROCKCHIP_MALI_PKGCONFIG_FILES), \
		sed -e '' $(@D)/build/meson-private/$(pkgconfig).pc > \
			$(1)/usr/lib/pkgconfig/$(pkgconfig).pc
	)

#	Install all headers
	$(foreach d,$(ROCKCHIP_MALI_HEADERS), \
		cp -dpfr $(@D)/include/$(d) $(1)/usr/include/
	)

#	Create symlinks
	$(foreach symlink,$(ROCKCHIP_MALI_LIB_SYMLINKS), \
		ln -sf $(ROCKCHIP_MALI_LIB) $(1)/usr/lib/$(symlink)
	)
endef 	

define ROCKCHIP_MALI_INSTALL_TARGET_CMDS
	$(call ROCKCHIP_MALI_INSTALL_CMDS,$(TARGET_DIR))
endef

define ROCKCHIP_MALI_INSTALL_STAGING_CMDS
	$(call ROCKCHIP_MALI_INSTALL_CMDS,$(STAGING_DIR))
endef

$(eval $(generic-package))

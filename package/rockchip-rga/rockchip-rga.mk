################################################################################
#
# rockchip-rga
#
################################################################################

ROCKCHIP_RGA_VERSION = v1.9.0
ROCKCHIP_RGA_SITE = https://github.com/airockchip/librga
ROCKCHIP_RGA_SITE_METHOD = git
ROCKCHIP_RGA_POST_INSTALL_TARGET_HOOKS = ROCKCHIP_RGA_INSTALL_CMDS

ROCKCHIP_RGA_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_LIBDRM),y)
ROCKCHIP_RGA_DEPENDENCIES += libdrm
ROCKCHIP_RGA_CONF_OPTS += -Dlibdrm=true
endif

define ROCKCHIP_RGA_INSTALL_CMDS

#	Since source files for the blob are not provided, the compiled blob is copied over
	cp $(@D)/libs/Linux/gcc-aarch64/librga.so $(O)/staging/usr/lib/librga.so.2.1.0
	cp $(@D)/libs/Linux/gcc-aarch64/librga.so $(O)/target/usr/lib/librga.so.2.1.0

endef

$(eval $(meson-package))

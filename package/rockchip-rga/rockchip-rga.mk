################################################################################
#
# rockchip-rga
#
################################################################################

ROCKCHIP_RGA_VERSION = origin/v1.3.2_release
ROCKCHIP_RGA_SITE = https://github.com/airockchip/librga
ROCKCHIP_RGA_SITE_METHOD = git

ROCKCHIP_RGA_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_LIBDRM),y)
ROCKCHIP_RGA_DEPENDENCIES += libdrm
ROCKCHIP_RGA_CONF_OPTS += -Dlibdrm=true
endif

$(eval $(meson-package))

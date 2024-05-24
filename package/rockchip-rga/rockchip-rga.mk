################################################################################
#
# rockchip-rga
#
################################################################################

ROCKCHIP_RGA_VERSION = jellyfin-rga
ROCKCHIP_RGA_SITE = https://github.com/nyanmisaka/rk-mirrors
ROCKCHIP_RGA_SITE_METHOD = git

ROCKCHIP_RGA_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_LIBDRM),y)
ROCKCHIP_RGA_DEPENDENCIES += libdrm
ROCKCHIP_RGA_CONF_OPTS += -Dlibdrm=true
endif

$(eval $(meson-package))

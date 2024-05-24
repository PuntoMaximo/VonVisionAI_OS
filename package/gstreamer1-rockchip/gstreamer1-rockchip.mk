################################################################################
#
#  Rockchip's GSTREAMER-1
#
################################################################################
GSTREAMER1_ROCKCHIP_VERSION = develop
GSTREAMER1_ROCKCHIP_SITE = https://github.com/MOHAMED-BEN-OTHMEN/gstreamer-rockchip-1.git
GSTREAMER1_ROCKCHIP_SITE_METHOD = git
MPP_INSTALL_STAGING = YES
MPP_INSTALL_TARGET = YES
GSTREAMER1_ROCKCHIP_AUTORECONF = YES
GSTREAMER1_ROCKCHIP_DEPENDENCIES = gstreamer1
GSTREAMER1_ROCKCHIP_DEPENDENCIES = gst1-plugins-base

ifeq ($(BR2_PACKAGE_MPP),y)
GSTREAMER1_ROCKCHIP_DEPENDENCIES += mpp
endif

ifeq ($(BR2_PACKAGE_LINUX_RGA),y)
GSTREAMER1_ROCKCHIP_DEPENDENCIES += linux-rga
GSTREAMER1_ROCKCHIP_CONF_OPTS += -Drga=enabled
endif

ifeq ($(BR2_PACKAGE_XORG7),y)
GSTREAMER1_ROCKCHIP_DEPENDENCIES += xlib_libX11 libdrm

endif
$(eval $(autotools-package))

################################################################################
#
# xdriver_xf86-video-armsoc
#
################################################################################

XDRIVER_XF86_VIDEO_ARMSOC_VERSION = origin/master		
XDRIVER_XF86_VIDEO_ARMSOC_SITE_METHOD = git
XDRIVER_XF86_VIDEO_ARMSOC_SITE = https://github.com/mth/xf86-video-armsoc.git
XDRIVER_XF86_VIDEO_ARMSOC_LICENSE = MIT
XDRIVER_XF86_VIDEO_ARMSOC_LICENSE_FILES = COPYING

XDRIVER_XF86_VIDEO_ARMSOC_POST_INSTALL_TARGET_HOOKS += XDRIVER_XF86_VIDEO_ARMSOC_INSTALL_CMDS

XDRIVER_XF86_VIDEO_ARMSOC_AUTORECONF += YES

define XDRIVER_XF86_VIDEO_ARMSOC_INSTALL_CMDS
	$(INSTALL) -D -m 644 $(@D)/xorg.conf $(TARGET_DIR)/etc/X11	
endef

$(eval $(autotools-package))

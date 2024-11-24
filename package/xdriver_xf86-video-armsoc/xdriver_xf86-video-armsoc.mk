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


XDRIVER_XF86_VIDEO_ARMSOC_AUTORECONF += YES

$(eval $(autotools-package))

################################################################################
#
# ffrknn
#
################################################################################

FFRKNN_VERSION = main
FFRKNN_SITE = https://github.com/avafinger/ff-rknn.git
FFRKNN_SITE_METHOD = git
FFRKNN_INSTALL_STAGING = YES

TARGET_CONFIGURE_OPTS += O=$(O)	

define FFRKNN_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) CC="$(TARGET_CC)" LD="$(TARGET_LD)" -C $(@D) 
endef




$(eval $(generic-package))

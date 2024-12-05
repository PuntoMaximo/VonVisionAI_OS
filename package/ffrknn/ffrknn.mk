################################################################################
#
# ffrknn
#
################################################################################

FFRKNN_VERSION = main
FFRKNN_SITE = https://github.com/avafinger/ff-rknn.git
FFRKNN_SITE_METHOD = git
FFRKNN_POST_INSTALL_TARGET_HOOKS += FFRKNN_INSTALL_CMDS

TARGET_CONFIGURE_OPTS += O=$(O)	

define FFRKNN_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) CC="$(TARGET_CC)" LD="$(TARGET_LD)" -C $(@D) 
endef

define FFRKNN_INSTALL_CMDS
	$(INSTALL) -D -m 644 $(@D)/ff-rknn $(TARGET_DIR)/usr/bin
endef



$(eval $(generic-package))

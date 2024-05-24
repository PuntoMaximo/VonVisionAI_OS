################################################################################
#
# rknpu2
#
################################################################################
RKNPU2_VERSION = v1.4.0
RKNPU2_SITE = https://github.com/rockchip-linux/rknpu2.git
RKNPU2_SITE_METHOD = git
RKNPU2_INSTALL_STAGING = YES
RKNPU2_INSTALL_TARGET = YES
RKNPU2_SOC = RK356X


NPU_PLATFORM_ARCH = aarch64

define RKNPU2_INSTALL_TARGET_CMDS
	cp -r $(@D)/runtime/$(RKNPU2_SOC)/Linux/rknn_server/$(NPU_PLATFORM_ARCH)/* \
		$(TARGET_DIR)/
	cp -r $(@D)/runtime/$(RKNPU2_SOC)/Linux/librknn_api/$(NPU_PLATFORM_ARCH)/* \
		$(TARGET_DIR)/usr/lib/
endef

define RKNPU2_INSTALL_STAGING_CMDS
	cp -r $(@D)/runtime/$(RKNPU2_SOC)/Linux/librknn_api/$(NPU_PLATFORM_ARCH)/* \
		$(STAGING_DIR)/usr/lib/
	cp -rT $(@D)/runtime/$(RKNPU2_SOC)/Linux/librknn_api/include \
		$(STAGING_DIR)/usr/include/rknn
endef

ifeq ($(BR2_PACKAGE_RKNPU2_EXAMPLE),)
$(eval $(generic-package))
else
RKNPU2_POST_INSTALL_TARGET_HOOKS += RKNPU2_INSTALL_TARGET_EXAMPLE
$(eval $(cmake-package))

ifeq ($(BR2_PACKAGE_RKNPU2_EXAMPLE_CM_TEST),y)
RKNPU2_SUBDIR = examples/rknn_common_test
RKNPU2_CONF_OPTS += -DTARGET_SOC=$(call LOWERCASE,$(RKNPU2_SOC))

define RKNPU2_INSTALL_TARGET_EXAMPLE
	cp -r $(@D)/runtime/$(RKNPU2_SOC)/Linux/librknn_api/$(NPU_PLATFORM_ARCH)/* \
		$(STAGING_DIR)/usr/lib/
	cp -rT $(@D)/runtime/$(RKNPU2_SOC)/Linux/librknn_api/include \
		$(STAGING_DIR)/usr/include/rknn

	cp $(@D)/$(RKNPU2_SUBDIR)/rknn_common_test $(TARGET_DIR)/usr/bin/
	cp -r $(@D)/$(RKNPU2_SUBDIR)/model $(TARGET_DIR)/usr/share/
endef

else ifeq ($(BR2_PACKAGE_RKNPU2_EXAMPLE_YOLOV5),y)
RKNPU2_DEPENDENCIES = opencv4
RKNPU2_DEPENDENCIES += opencv4_lib_imgproc
RKNPU2_DEPENDENCIES += opencv4_lib_imgcodecs
RKNPU2_DEPENDENCIES += opencv4_lib_video
RKNPU2_DEPENDENCIES += opencv4_lib_videoio
RKNPU2_DEPENDENCIES += opencv4_lib_highgui

RKNPU2_SUBDIR = examples/rknn_yolov5_demo
RKNPU2_BUILD_DIR := $(BUILD_DIR)/rknpu2-$(RKNPU2_VERSION)
RKNPU2_CONF_OPTS += -DTARGET_SOC=$(call LOWERCASE,$(RKNPU2_SOC))

define RKNPU2_INSTALL_TARGET_EXAMPLE
	$(MAKE) -C $(RKNPU2_BUILD_DIR)/$(RKNPU2_SUBDIR) install 	
	cp -r $(@D)/runtime/$(RKNPU2_SOC)/Linux/librknn_api/$(NPU_PLATFORM_ARCH)/* \
		$(STAGING_DIR)/usr/lib/
	cp -rT $(@D)/runtime/$(RKNPU2_SOC)/Linux/librknn_api/include \
		$(STAGING_DIR)/usr/include/rknn

	cp $(@D)/$(RKNPU2_SUBDIR)/install/rknn_yolov5_demo_Linux/rknn_yolov5_demo $(TARGET_DIR)/usr/bin/
	cp -r $(@D)/$(RKNPU2_SUBDIR)/install/rknn_yolov5_demo_Linux/model/* $(TARGET_DIR)/usr/share/
	cp -r $(@D)/$(RKNPU2_SUBDIR)/install/rknn_yolov5_demo_Linux/lib/* $(TARGET_DIR)/usr/lib/
	
endef
endif
endif


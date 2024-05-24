
################################################################################
#
#  Rockchip's MPP(Multimedia Processing Platform)
#
################################################################################
MPP_VERSION = jellyfin-mpp
MPP_SITE = https://github.com/nyanmisaka/mpp.git
MPP_SITE_METHOD = git
MPP_INSTALL_TARGET = YES
MPP_INSTALL_STAGING = YES
MPP_CONF_OPTS = "-DRKPLATFORM=ON"
MPP_DEPENDENCIES += libdrm

MPP_INSTALL_STAGING = YES

MPP_CONF_OPTS += \
	-DCMAKE_INSTALL_PREFIX=/usr \
	-DCMAKE_BUILD_TYPE=Release \
	-DBUILD_SHARED_LIBS=ON


ifeq ($(BR2_PACKAGE_MPP_ALLOCATOR_DRM),y)
MPP_CONF_OPTS += "-DHAVE_DRM=ON"
endif

ifeq ($(BR2_PACKAGE_MPP_TESTS),y)
MPP_CONF_OPTS += "-DBUILD_TEST=ON"
endif

define MPP_LINK_GIT
	rm -rf $(@D)/.git
	ln -s $(SRCDIR)/.git $(@D)/
endef
MPP_POST_RSYNC_HOOKS += MPP_LINK_GIT

define MPP_REMOVE_NOISY_LOGS
	sed -i -e "/pp_enable %d/d" \
		$(@D)/mpp/hal/vpu/jpegd/hal_jpegd_vdpu2.c || true
	sed -i -e "/reg size mismatch wr/i    if (0)" \
		$(@D)/osal/driver/vcodec_service.c || true
endef
MPP_POST_RSYNC_HOOKS += MPP_REMOVE_NOISY_LOGS

$(eval $(cmake-package))

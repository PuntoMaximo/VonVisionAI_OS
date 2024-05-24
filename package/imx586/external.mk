IMX586_MODULE_VERSION = 1.0
IMX586_MODULE_SITE = ($BR2_EXTERNAL_RK3308_PATH)/package/imx586
IMX586_MODULE_SITE_METHOD = local

IMX586_MODULE_SUBDIRS = driver

$(eval $(kernel-module))
$(eval $(generic-package))


define IMX586_EXTRACT_CMDS
				cp -r $(BR2_EXTERNAL_RK3308_PATH)/package/imx586/driver $(@D)
endef
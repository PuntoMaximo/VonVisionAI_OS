
GL4ES_VERSION = origin/master
GL4ES_SITE = https://github.com/ptitSeb/gl4es
GL4ES_SITE_METHOD = git
GL4ES_INSTALL_STAGING = YES
GL4ES_CONF_OPTS += -DODROID=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo

GL4ES_POST_INSTALL_TARGET_HOOKS += GL4ES_INSTALL_CMDS

define GL4ES_INSTALL_CMDS

#	Install headers
	cp -dpfr $(@D)/include/GL $(O)/staging/usr/include/

#	Install pkg config file, this implementation will work independently of package version
	cp $(@D)/gl.pc $(O)/staging/usr/lib/pkgconfig/

#	Create symlink for default lib folder
	ln -sf ./gl4es/libGL.so.1 $(O)/staging/usr/lib/libGL.so
	ln -sf ./gl4es/libGL.so.1 $(O)/target/usr/lib/libGL.so

endef

$(eval $(cmake-package))

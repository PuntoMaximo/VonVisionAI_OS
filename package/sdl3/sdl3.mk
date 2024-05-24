################################################################################
#
# sdl
#
################################################################################

SDL3_VERSION = a94d724f17d7236e9307a02ec946997aa192778e
SDL3_SITE = https://github.com/libsdl-org/SDL.git
SDL3_SITE_METHOD = git
SDL3_INSTALL_STAGING = YES
SDL3_CONF_OPTS = -DCMAKE_BUILD_TYPE=Release -S $(O)/build/sdl3-$(SDL3_VERSION)/outoftree -B $(O)/build/sdl3-$(SDL3_VERSION)


SDL3_DEPENDENCIES += host-automake host-autoconf host-libtool alsa-lib
HOST_SDL3_DEPENDENCIES += host-automake host-autoconf host-libtool



define SDL3_EXTRACT_CMDS   
	mkdir $(@D)/outoftree
	tar xvf $(DL_DIR)/sdl3/$(SDL3_SOURCE) -C $(@D)/outoftree
	mv $(@D)/outoftree/sdl3-$(SDL3_VERSION)/{.,}* /$(@D)/outoftree || true

endef

$(eval $(cmake-package))
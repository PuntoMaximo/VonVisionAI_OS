################################################################################
#
# ffrknn_SDL3
#
################################################################################

FFRKNN_SDL3_VERSION = main
FFRKNN_SDL3_SITE = https://github.com/PuntoMaximo/ff-rknn-sdl3
FFRKNN_SDL3_SITE_METHOD = git
FFRKNN_SDL3_DEPENDENCIES = ffmpeg
FFRKNN_SDL3_DEPENDENCIES = SDL_FontCache
FFRKNN_SDL3_DEPENDENCIES = opencv4
FFRKNN_SDL3_POST_INSTALL_TARGET_HOOKS += FFRKNN_SDL3_INSTALL_CMDS

define FFRKNN_SDL3_INSTALL_CMDS
	cp -r $(@D)/model $(TARGET_DIR)/usr/share
endef	


$(eval $(cmake-package))

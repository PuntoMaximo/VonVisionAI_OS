################################################################################
#
# ffrknn_sdl2
#
################################################################################

FFRKNN_SDL2_VERSION = main
FFRKNN_SDL2_SITE = https://github.com/PuntoMaximo/ff-rknn-sdl2
FFRKNN_SDL2_SITE_METHOD = git
FFRKNN_SDL2_DEPENDENCIES = ffmpeg
FFRKNN_SDL2_DEPENDENCIES = SDL_FontCache
FFRKNN_SDL2_DEPENDENCIES = opencv4
FFRKNN_SDL2_POST_INSTALL_TARGET_HOOKS += FFRKNN_SDL2_INSTALL_CMDS

define FFRKNN_SDL2_INSTALL_CMDS
	cp -r $(@D)/model $(TARGET_DIR)/usr/share
endef	


$(eval $(cmake-package))

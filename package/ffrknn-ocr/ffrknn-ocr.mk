################################################################################
#
# FFRKNN_OCR
#
################################################################################

FFRKNN_OCR_VERSION = main
FFRKNN_OCR_SITE = https://github.com/PuntoMaximo/ffrknn-ocr
FFRKNN_OCR_SITE_METHOD = git

FFRKNN_OCR_DEPENDENCIES = ffmpeg
FFRKNN_OCR_DEPENDENCIES = SDL_FontCache
FFRKNN_OCR_DEPENDENCIES = opencv4
FFRKNN_OCR_POST_INSTALL_TARGET_HOOKS += FFRKNN_OCR_INSTALL_CMDS

define FFRKNN_OCR_INSTALL_CMDS
	cp -r $(@D)/model $(TARGET_DIR)/usr/share
endef	


$(eval $(cmake-package))

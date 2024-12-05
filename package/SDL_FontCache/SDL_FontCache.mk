################################################################################
#
# SDL Font Cache
#
################################################################################

SDL_FONTCACHE_VERSION = origin/master
SDL_FONTCACHE_SITE = https://github.com/grimfang4/SDL_FontCache
SDL_FONTCACHE_SITE_METHOD = git
SDL_FONTCACHE_INSTALL_STAGING = YES
SDL_FONTCACHE_INSTALL_TARGET = NO



$(eval $(cmake-package))

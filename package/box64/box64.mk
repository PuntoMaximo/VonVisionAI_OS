
BOX64_VERSION = main
BOX64_SITE = https://github.com/ptitSeb/box64
BOX64_SITE_METHOD = git
BOX64_INSTALL_STAGING = YES

BOX64_CONF_OPTS += -D RK3588=1 -D CMAKE_BUILD_TYPE=RelWithDebInfo

$(eval $(cmake-package))

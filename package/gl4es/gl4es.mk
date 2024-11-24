
GL4ES_VERSION = origin/master
GL4ES_SITE = https://github.com/ptitSeb/gl4es
GL4ES_SITE_METHOD = git

GL4ES_CONF_OPTS += -DODROID=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo


$(eval $(cmake-package))

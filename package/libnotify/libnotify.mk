
LIBNOTIFY_VERSION = origin/master
LIBNOTIFY_SITE = https://github.com/GNOME/libnotify
LIBNOTIFY_SITE_METHOD = git
LIBNOTIFY_INSTALL_STAGING = YES
LIBNOTIFY_DEPENDENCIES = libgtk3
LIBNOTIFY_DEPENDENCIES = gobject-introspection

LIBNOTIFY_CONF_OPTS +=  --prefix=/usr \
			--buildtype=release \
			-Dgtk_doc=false \
			-Dman=false 

$(eval $(meson-package))

include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI interface for SSH over WebSocket (TLS/Non-TLS)
LUCI_DESCRIPTION:=A web-based control panel for SSH over WebSocket VPN with TLS, DNS, and Payload support
LUCI_PKGARCH:=all

PKG_NAME:=luci-app-sshwss
PKG_VERSION:=1.0
PKG_RELEASE:=1

PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=
PKG_MAINTAINER:=dotycat <support@dotycat.com>

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/luci.mk

define Package/$(PKG_NAME)
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=$(LUCI_TITLE)
  PKGARCH:=$(LUCI_PKGARCH)
  MAINTAINER:=$(PKG_MAINTAINER)
  DEPENDS:=+luci-base +luci-compat +uci +rpcd +libuci +libubus +libjson-script +sshwss +websocketd +stunnel +bash +coreutils +ca-certificates
endef

define Package/$(PKG_NAME)/description
$(LUCI_DESCRIPTION)
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view/sshwss
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_DIR) $(1)/etc/config

	# Install LuCI files
	$(INSTALL_DATA) ./luasrc/controller/sshwss.lua $(1)/usr/lib/lua/luci/controller/sshwss.lua
	$(INSTALL_DATA) ./luasrc/model/cbi/sshwss.lua $(1)/usr/lib/lua/luci/model/cbi/sshwss.lua
	$(INSTALL_DATA) ./luasrc/view/sshwss/status.htm $(1)/usr/lib/lua/luci/view/sshwss/status.htm

	$(INSTALL_BIN) ./files/sshwss.init $(1)/etc/init.d/sshwss

	$(INSTALL_CONF) ./files/sshwss.config $(1)/etc/config/sshwss
endef

$(eval $(call BuildPackage,$(PKG_NAME)))

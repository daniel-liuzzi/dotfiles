// Don't allow Firefox to install or run studies
user_pref("app.shield.optoutstudies.enabled", false);

// Don't warn when accessing about:config
user_pref("browser.aboutConfig.showWarning", false);

// Ctrl+Tab cycles through tabs in recently used order
user_pref("browser.ctrlTab.sortByRecentlyUsed", true);

// Don't remember search and form history
user_pref("browser.formfill.enable", false);

// Bookmarks Toolbar > Never Show
user_pref("browser.toolbars.bookmarks.visibility", "never");

// Never offer to translate
user_pref("browser.translations.automaticallyPopup", false);

// Don't allow Firefox to send technical or interaction data to Mozilla
user_pref("datareporting.healthreport.uploadEnabled", false);

// DevTools
user_pref("devtools.browserconsole.contentMessages", true);
user_pref("devtools.browserconsole.filter.css", true);
user_pref("devtools.browserconsole.filter.net", true);
user_pref("devtools.browserconsole.filter.netxhr", true);
user_pref("devtools.cache.disabled", true);
user_pref("devtools.chrome.enabled", true);
user_pref("devtools.everOpened", true);
user_pref("devtools.netmonitor.persistlog", true);
user_pref("devtools.theme.show-auto-theme-info", false);
user_pref("devtools.webconsole.filter.css", true);
user_pref("devtools.webconsole.filter.net", true);
user_pref("devtools.webconsole.filter.netxhr", true);
user_pref("devtools.webconsole.persistlog", true);
user_pref("devtools.webconsole.timestampMessages", true);

// Don't save or fill payment methods
user_pref("extensions.formautofill.creditCards.enabled", false);

// The browser imposes a limit on the number of simultaneous connections that
// can be made to a single server. In Firefox this defaults to 6, but can be
// changed using the network.http.max-persistent-connections-per-server
// preference. If all connections are in use, the browser can’t download more
// resources until a connection is released.
// https://firefox-source-docs.mozilla.org/devtools-user/network_monitor/request_details/#request-timing
user_pref("network.http.max-persistent-connections-per-server", 10);

// Allow Windows single sign-on for Microsoft, work, and school accounts
// https://support.mozilla.org/en-US/kb/windows-sso
user_pref("network.http.windows-sso.enabled", true);

// Firefox gives certificate warning when accessing applications via Forcepoint ONE
// https://support.forcepoint.com/s/article/Configure-Firefox-to-use-Windows-certificate-store-1648249639083
user_pref("security.enterprise_roots.enabled", true);

// Don't ask to save passwords
user_pref("signon.rememberSignons", false);

// Set Firefox to look for userChrome.css at startup
// https://www.userchrome.org/how-create-userchrome-css.html#aboutconfig
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

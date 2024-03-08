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

// Allow Windows single sign-on for Microsoft, work, and school accounts
// https://support.mozilla.org/en-US/kb/windows-sso
user_pref("network.http.windows-sso.enabled", true);

// Firefox gives certificate warning when accessing applications via Forcepoint ONE
// https://support.forcepoint.com/s/article/Configure-Firefox-to-use-Windows-certificate-store-1648249639083
user_pref("security.enterprise_roots.enabled", true);

// Set Firefox to look for userChrome.css at startup
// https://www.userchrome.org/how-create-userchrome-css.html#aboutconfig
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

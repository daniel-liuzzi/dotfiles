// Set Firefox to look for userChrome.css at startup
// https://www.userchrome.org/how-create-userchrome-css.html#aboutconfig
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// Ctrl+Tab cycles through tabs in recently used order
user_pref("browser.ctrlTab.sortByRecentlyUsed", true);

// Bookmarks Toolbar > Never Show
user_pref("browser.toolbars.bookmarks.visibility", "never");

// Don't warn when accessing about:config
user_pref("browser.aboutConfig.showWarning", false);

// Don't remember search and form history
user_pref("browser.formfill.enable", false);

// DevTools
user_pref("devtools.everOpened", true);
user_pref("devtools.theme.show-auto-theme-info", false);

// Don't warn when accessing about:config
user_pref("browser.aboutConfig.showWarning", false);

// Ctrl+Tab cycles through tabs in recently used order
user_pref("browser.ctrlTab.sortByRecentlyUsed", true);

// Don't remember search and form history
user_pref("browser.formfill.enable", false);

// Bookmarks Toolbar > Never Show
user_pref("browser.toolbars.bookmarks.visibility", "never");

// The Browser Console command line is disabled by default. To enable it set the
// devtools.chrome.enabled preference to true in about:config, or set the
// “Enable chrome debugging” option in the developer tool settings.
// https://firefox-source-docs.mozilla.org/devtools-user/browser_console/index.html#browser-console-command-line
user_pref("devtools.chrome.enabled", true);

// DevTools
user_pref("devtools.everOpened", true);
user_pref("devtools.theme.show-auto-theme-info", false);

// Set Firefox to look for userChrome.css at startup
// https://www.userchrome.org/how-create-userchrome-css.html#aboutconfig
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

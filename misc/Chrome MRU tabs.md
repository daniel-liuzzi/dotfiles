# Chrome MRU Tabs

1. Install [Ctrl+tab
MRU](https://chrome.google.com/webstore/detail/ctrl%20tab-mru/ialfjajikhdldpgcfglgndennidgkhik)
extension.

2. Open `chrome://extensions/shortcuts` by pasting that into the location bar
or going to the main menu > More Tools > Extensions, and then clicking the
menu in the top-left to open Keyboard shortcuts.

3. Open the DevTools console by pressing Cmd+Opt+J on macOS or Ctrl+Shift+J on
Windows/Linux.

4. Paste the following code and press Enter:

        document.body.onclick = function(e) {
          gCT = !window.gCT;
          var p = e.path, cn = p[0].textContent,
              s = p.filter(p => p.className == 'shortcut-card')[0],
              n = s && s.children[0].children[1].textContent;
          n && chrome.management.getAll(es => {
            var ext = es.filter(e => e.name == n)[0], id = ext.id;
            chrome.developerPrivate.getExtensionInfo(id, i => {
              var c = i.commands.filter(c => c.description == cn)[0];
              chrome.developerPrivate.updateExtensionCommand({
                extensionId: id,
                commandName: c.name,
                keybinding: 'Ctrl+' + (gCT ? '' : 'Shift+') + 'Tab'
              });
            });
          });
        }

5. Under _Ctrl+tab MRU_, click the _Switch to older tab_ **label** (**not**
the *Type a shortcut* field). Shortcut will be to set to Ctrl+tab.

6. Click _Switch to newer tab_ label. Shortcut will be to set to
Ctrl+Shift+tab (the code alternates between Ctrl+tab and Ctrl+Shift+tab as you
click.)

[Source](https://superuser.com/a/1326712/18964)

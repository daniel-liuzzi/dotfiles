# Ctrl+Tab on Edge

Follow [Use <kbd>ctrl</kbd> <kbd>tab</kbd> as a QuicKey
shortcut](https://fwextensions.github.io/QuicKey/ctrl-tab/) guide, substituting
the following block of code in step 5:

```js
chrome.developerPrivate.updateExtensionCommand({
    extensionId: "mcjciddpjefdpndgllejgcekmajmehnd",
    commandName: "30-toggle-recent-tabs",
    keybinding: "Ctrl+Tab"
});
```

https://github.com/fwextensions/QuicKey/issues/121#issuecomment-2408687377

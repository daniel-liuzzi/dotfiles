// Future versions of Hyper may add additional config options,
// which will not automatically be merged into this file.
// See https://hyper.is#cfg for all currently supported options.

module.exports = {
  config: {
    // Choose either "stable" for receiving highly polished,
    // or "canary" for less polished but more frequent updates
    updateChannel: 'canary',

    // default font size in pixels for all tabs
    fontSize: 17,

    // font family with optional fallbacks
    fontFamily: '"Fira Code Light", Menlo, "DejaVu Sans Mono", Consolas, "Lucida Console", monospace',

    // terminal cursor background color and opacity (hex, rgb, hsl, hsv, hwb or cmyk)
    cursorColor: '#97979b',

    // `BEAM` for |, `UNDERLINE` for _, `BLOCK` for █
    cursorShape: 'BLOCK',

    // set to true for blinking cursor
    cursorBlink: false,

    // color of the text
    foregroundColor: '#eff0eb',

    // terminal background color
    backgroundColor: '#282a36',

    // border color (window, tabs)
    borderColor: '#222430',

    // custom css to embed in the main window
    css: '',

    // custom css to embed in the terminal window
    termCSS: '',

    // set to `true` (without backticks and without quotes) if you're using a
    // Linux setup that doesn't show native menus
    // default: `false` on Linux, `true` on Windows (ignored on macOS)
    showHamburgerMenu: '',

    // set to `false` if you want to hide the minimize, maximize and close buttons
    // additionally, set to `'left'` if you want them on the left, like in Ubuntu
    // default: `true` on windows and Linux (ignored on macOS)
    showWindowControls: '',

    // custom padding (css format, i.e.: `top right bottom left`)
    padding: '12px 14px',

    // the full list. if you're going to provide the full color palette,
    // including the 6 x 6 color cubes and the grayscale map, just provide
    // an array here instead of a color map object
    colors: {
      black: '#282a36',
      red: '#ff5c57',
      green: '#5af78e',
      yellow: '#f3f99d',
      blue: '#57c7ff',
      magenta: '#ff6ac1',
      cyan: '#9aedfe',
      white: '#f1f1f0',
      lightBlack: '#686868',
      lightRed: '#ff5c57',
      lightGreen: '#5af78e',
      lightYellow: '#f3f99d',
      lightBlue: '#57c7ff',
      lightMagenta: '#ff6ac1',
      lightCyan: '#9aedfe',
      lightWhite: '#eff0eb',
    },

    // the shell to run when spawning a new session (i.e. /usr/local/bin/fish)
    // if left empty, your system's login shell will be used by default
    //
    // Windows
    // - Make sure to use a full path if the binary name doesn't work
    // - Remove `--login` in shellArgs
    //
    // Bash on Windows
    // - Example: `C:\\Windows\\System32\\bash.exe`
    //
    // Powershell on Windows
    // - Example: `C:\\WINDOWS\\System32\\WindowsPowerShell\\v1.0\\powershell.exe`
    shell: 'powershell.exe',

    // for setting shell arguments (i.e. for using interactive shellArgs: ['-i'])
    // by default ['--login'] will be used
    shellArgs: ['-NoLogo'],

    // for environment variables
    env: {},

    // set to false for no bell
    bell: 'SOUND',

    // if true, selected text will automatically be copied to the clipboard
    copyOnSelect: false,

    // if true, on right click selected text will be copied or pasted if no
    // selection is present (true by default on Windows)
    // quickEdit: true,

    // URL to custom bell
    // bellSoundURL: 'http://example.com/bell.mp3',

    // for advanced config flags please refer to https://hyper.is/#cfg
  },

  // a list of plugins to fetch and install from npm
  // format: [@org/]project[#version]
  // examples:
  //   `hyperpower`
  //   `@company/project`
  //   `project#1.0.1`
  plugins: [],

  // in development, you can create a directory under
  // `~/.hyper_plugins/local/` and include it here
  // to load it and avoid it being `npm install`ed
  localPlugins: [],

  keymaps: {
    'window:devtools': 'ctrl+shift+i',
    'window:reload': 'ctrl+r',
    'window:reloadFull': 'ctrl+shift+r',
    'window:preferences': 'ctrl+,',
    'zoom:reset': 'ctrl+0',
    'zoom:in': 'ctrl+plus',
    'zoom:out': 'ctrl+-',
    'window:new': 'ctrl+n',
    'window:minimize': '',
    'window:zoom': '',
    'window:toggleFullScreen': 'f11',
    'window:close': 'alt+f4',
    'tab:new': 'ctrl+t',
    'tab:next': 'ctrl+tab',
    'tab:prev': 'ctrl+shift+tab',
    'tab:jump:prefix': 'ctrl',
    'pane:next': 'alt+pageup',
    'pane:prev': 'alt+pagedown',
    'pane:splitVertical': 'ctrl+shift+d',
    'pane:splitHorizontal': 'ctrl+shift+e',
    'pane:close': 'ctrl+w',
    'editor:undo': 'alt+z', // alt = ctrl
    'editor:redo': 'alt+y', // alt = ctrl; broken (doesn't do anything)
    'editor:cut': 'alt+x', // alt = ctrl
    'editor:copy': 'alt+c', // alt = ctrl; broken (conflicts w/ editor:break)
    'editor:paste': 'alt+v', // alt = ctrl
    'editor:selectAll': 'alt+a', // alt = ctrl
    'editor:movePreviousWord': 'alt+left', // alt = ctrl
    'editor:moveNextWord': 'alt+right', // alt = ctrl
    // 'editor:moveBeginningLine': 'home', // broken (doesn't do anything)
    // 'editor:moveEndLine': 'end', // broken (doesn't do anything)
    'editor:deletePreviousWord': 'alt+backspace', // alt = ctrl; broken (deletes previous char)
    'editor:deleteNextWord': 'alt+del', // alt = ctrl
    'editor:deleteBeginningLine': 'alt+home', // alt = ctrl
    'editor:deleteEndLine': 'alt+end', // alt = ctrl
    'editor:clearBuffer': 'ctrl+k',
    // 'editor:break': 'ctrl+c', // broken (can't exit Node.js)
    'plugins:update': 'ctrl+shift+u',
  },
};

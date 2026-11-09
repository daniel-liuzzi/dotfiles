try {
    Set-PSReadLineOption -PredictionViewStyle ListView -WordDelimiters ' /\'
}
catch {
}

# Fix Ctrl+Left / Ctrl+Right (jump by word) in Herdr terminals.
# Herdr turns those keys into ESC b / ESC f, which PSReadLine receives as
# Alt+b / Alt+f. Without these bindings they just type "b" or "f".
try {
    Set-PSReadLineKeyHandler -Chord 'Alt+b' -Function BackwardWord
    Set-PSReadLineKeyHandler -Chord 'Alt+f' -Function ForwardWord
}
catch {
}

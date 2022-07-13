Import-Module $ProfileDir/modules/base

function s_ { run scoop @args }
function ss { s_ status @args }
function su { s_ update @args }

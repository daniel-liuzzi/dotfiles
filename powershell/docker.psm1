# Credit: https://stackoverflow.com/a/30793515/88709

function Invoke-Whaler {
    run docker run --rm -v /var/run/docker.sock:/var/run/docker.sock alpine/dfimage $args
}

function Invoke-Dive {
    run docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock wagoodman/dive $args
}

Set-Alias -Name 'whaler' -Value 'Invoke-Whaler'
Set-Alias -Name 'dive' -Value 'Invoke-Dive'
Set-Alias -Name 'dc' -Value 'docker-compose'

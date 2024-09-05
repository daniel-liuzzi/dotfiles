function d_ { run docker @args }
function dc { d_ compose @args }

# docker run
function dr { d_ run @args }
function drd { dr --detach @args }
function drdrm { drd --rm @args }
function dri { dr --interactive @args }
function drirm { dri --rm @args }
function drit { dri --tty @args }
function dritrm { drit --rm @args }
function drrm { dr --rm @args }

# docker ps
function dps { d_ ps @args }
function dpsa { dps --all @args }

# docker compose up
function dcu { dc up @args }
function dcud { dcu --detach @args }
function dcudb { dcud --build @args }
function dcudbfr { dcudb --force-recreate @args }

# docker compose down
function dcd { dc down @args }
function dcdv { dcd --volumes @args }

# docker compose ps
function dcps { dc ps @args }
function dcpsa { dcps --all @args }

# misc. - credit: https://stackoverflow.com/a/30793515/88709
function dfimage { drrm --volume /var/run/docker.sock:/var/run/docker.sock alpine/dfimage @args }
function dive { dritrm --volume /var/run/docker.sock:/var/run/docker.sock wagoodman/dive @args }

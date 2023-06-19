Import-Module $ProfileDir/modules/base

function susus {
    run scoop status --local
    run scoop update
    run scoop status --local
    run scoop update --all
    run scoop status --local
}

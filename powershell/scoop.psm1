Import-Module $ProfileDir/base

function susus {
    run scoop status --local
    run scoop update
    run scoop status --local
    run scoop update --all
    run scoop status --local
}

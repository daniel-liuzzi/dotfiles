Import-Module $ProfileDir/base

function susus {
    function status {
        scoop status --local | where Info -NE 'Held package'
    }

    status
    run scoop update
    $status = status
    $status

    # we update one by one because scoop update --all stops upon first error
    $status | foreach { run scoop update $_.Name }

    status
}

# Credit: https://stackoverflow.com/a/30793515/88709

function dc {
    run docker compose @args
}

function dive {
    run docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock wagoodman/dive @args
}

function whaler {
    run docker run --rm -v /var/run/docker.sock:/var/run/docker.sock alpine/dfimage @args
}

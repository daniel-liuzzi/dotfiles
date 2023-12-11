using namespace System.Collections;

$env:DELTA_FEATURES = $null

function Switch-DeltaFeature($item) {
    $list = [ArrayList]($env:DELTA_FEATURES -split ' ').Where({ $_ })
    if (!$list.Contains($item)) {
        $list.Add($item) > $null
    } else {
        $list.Remove($item)
    }
    $env:DELTA_FEATURES = $list
}

function sbs { Switch-DeltaFeature '+side-by-side' }

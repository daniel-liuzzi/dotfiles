Import-Module $ProfileDir/modules/git

function gf { g flow @args }
function gfc { gf config @args }
function gfi { gf init @args }
function gfid { gfi --defaults @args }
function gfl { gf log @args }
function gfv { gf version @args }

# bugfix
function gfb { gf bugfix @args }
function gfbc { gfb checkout @args }
function gfbd { gfb diff @args }
function gfbdel { gfb delete @args }
function gfbf { gfb finish @args }
function gfbl { gfb list @args }
function gfbpub { gfb publish @args }
function gfbpull { gfb pull @args }
function gfbr { gfb rebase @args }
function gfbs { gfb start @args }
function gfbt { gfb track @args }

# feature
function gff { gf feature @args }
function gffc { gff checkout @args }
function gffd { gff diff @args }
function gffdel { gff delete @args }
function gfff { gff finish @args }
function gffl { gff list @args }
function gffpub { gff publish @args }
function gffpull { gff pull @args }
function gffr { gff rebase @args }
function gffs { gff start @args }
function gfft { gff track @args }

# hotfix
function gfh { gf hotfix @args }
function gfhdel { gfh delete @args }
function gfhf { gfh finish @args }
function gfhl { gfh list @args }
function gfhpub { gfh publish @args }
function gfhs { gfh start @args }

# release
function gfr { gf release @args }
function gfrdel { gfr delete @args }
function gfrf { gfr finish @args }
function gfrl { gfr list @args }
function gfrpub { gfr publish @args }
function gfrs { gfr start @args }
function gfrt { gfr track @args }

# support
function gfs { gf support @args }
function gfsl { gfs list @args }
function gfss { gfs start @args }

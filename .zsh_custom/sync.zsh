function sync {
    rsync --remove-source-files -azv $1 $2
    find $1 -type d -empty -delete
}

function sync-pics {
    sync ~/Pictures/Photos\ Library.photoslibrary/originals/ nas:/tank/pictures/jrx/
}

function sync-music {
    sync ~/Music/Soulseek/complete/ nas:/tank/downloads/soulseek/
}

function sync-jdownloader {
    sync ~/Downloads/jdownloader/extracted/ nas:/tank/music/new/
}

function ex2ssh {
    ssh -oHostKeyAlgorithms=+ssh-dss root@ex2
}

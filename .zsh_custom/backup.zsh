function backup-pics {
    rsync --remove-source-files -azv ~/Pictures/Photos\ Library.photoslibrary/originals/ nas:/tank/pictures/jrx/
}

function backup-music {
    rsync --remove-source-files -azv ~/Music/Soulseek/complete/ nas:/tank/music/new/
    find /Users/jruaux/Music/Soulseek/complete/ -type d -empty -delete
}

function ex2ssh {
    ssh -oHostKeyAlgorithms=+ssh-dss root@ex2
}
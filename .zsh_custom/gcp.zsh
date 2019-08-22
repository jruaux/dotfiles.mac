gcpinstances=('julien-node-jrx-1' 'julien-node-jrx-2' 'julien-node-jrx-3' 'julien-loader')
gcpzone='us-west1-b'

function dssh {
    instance=$gcpinstances[$1]
    echo "SSHing to $instance"
    gssh $instance
}

function dstop {
    demo stop
}

function dstart {
    demo start
}

function dlist {
    glist | grep julien
}

function gssh {
    gcloud compute ssh $1 --zone $gcpzone
}

function gstop {
    ginstances stop $1
}

function gstart {
    ginstances start $1
}

function glist {
    gcloud compute instances list
}

function ginstances {
    gcloud compute instances $1 --quiet --async $2 --zone $gcpzone
}

function demo {
    for instance in $gcpinstances; do
        ginstances $1 $instance
    done
}
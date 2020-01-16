gcpinstances=('jrx-node-1' 'jrx-node-2' 'jrx-node-3' 'jrx-client')
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
    glist | grep jrx
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
    gcloud compute instances $1 --verbosity error --quiet --async $2 --zone $gcpzone
}

function demo {
    for instance in $gcpinstances; do
        ginstances $1 $instance
    done
}

export PATH="$PATH":/usr/local/Cellar/easy-tag/2.4.3_1/bin/
SHELL_SESSION_HISTORY=0
HISTFILESIZE=900000
export PS1='\u@\h:\w\$ '
alias ll='ls -lG'
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

function genpasswd {
    pwgen -Bs $1 1 | pbcopy | pbpaste; echo “Has been copied to clipboard”
}

##### AWS #####
function ec2-hostname-from-instance {
    echo $(aws ec2 describe-instances --filters "{\"Name\":\"tag:Name\", \"Values\":[\"$1\"]}" --query='Reservations[0].Instances[0].PublicDnsName' | tr -d '"')
}

function ec2-ip-from-instance {
    echo $(aws ec2 describe-instances --filters "{\"Name\":\"tag:Name\", \"Values\":[\"$1\"]}" --query='Reservations[0].Instances[0].PublicIpAddress' | tr -d '"')
}

function ec2-ssh {
    ssh -i ~/.ssh/julien.pem ubuntu@$(ec2-ip-from-instance "$1")
}

function ec2 {
  case "$1" in
    start | stop)
      aws ec2 describe-instances --filters Name=tag:Role,Values="$2" | jq ".Reservations[].Instances[].InstanceId" -r | xargs aws ec2 $1-instances --instance-ids 
      ;;
  
    ssh)
      ec2-ssh $2
      ;;
  esac
}

##### GCP #####
export demoinstances='jrx-demo-1 jrx-demo-2 jrx-demo-3 jrx-loader'
export gcpzone='us-west1-b'


function dssh {
    gssh $(demo-instance-by-index)
}

function dstop {
    demo stop
}

function dstart {
    demo start
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

function ginstances {
    gcloud compute instances $1 --async $2 --zone $gcpzone
}

function demo {
    instances=($demoinstances)
    for instance in "${instances[@]}"
    do
        ginstances $1 $instance
    done
}

function demo-instance-by-index {
    instances=($demoinstances)
    echo ${instances[$1]}
}



export PATH="$PATH":/usr/local/Cellar/easy-tag/2.4.3_1/bin/
SHELL_SESSION_HISTORY=0
HISTFILESIZE=900000
#export CLICOLOR=1
#export LSCOLORS=GxFxCxDxBxegedabagaced
export PS1='\u@\h:\w\$ '
alias ll='ls -lG'

alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

genpasswd() { pwgen -Bs $1 1 |pbcopy |pbpaste; echo “Has been copied to clipboard”
}

function ec2-hostname-from-instance() {
    echo $(aws ec2 describe-instances --filters "{\"Name\":\"tag:Name\", \"Values\":[\"$1\"]}" --query='Reservations[0].Instances[0].PublicDnsName' | tr -d '"')
}

function ec2-ip-from-instance() {
    echo $(aws ec2 describe-instances --filters "{\"Name\":\"tag:Name\", \"Values\":[\"$1\"]}" --query='Reservations[0].Instances[0].PublicIpAddress' | tr -d '"')
}

function ec2-ssh() {
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

function gssh {
    gcloud compute ssh $1 --zone us-west1-b
}

function dssh {
    gssh jrx-demo-$1
}

function gstop {
    ginstances stop $1
}

function gstart {
    ginstances start $1
}

function ginstances {
    gcloud compute instances $1 --async $2 --zone us-west1-b
}

function dstop {
    gstop jrx-demo-1
    gstop jrx-demo-2
    gstop jrx-demo-3
}

function dstart {
    gstart jrx-demo-1
    gstart jrx-demo-2
    gstart jrx-demo-3
}

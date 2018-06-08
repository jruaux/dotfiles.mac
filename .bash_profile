export PATH="$PATH":~/bin
SHELL_SESSION_HISTORY=0
HISTFILESIZE=20000
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
export PS1='\u@\h:\w\$ '

alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

function hostname_from_instance() {
    echo $(aws ec2 describe-instances --filters "{\"Name\":\"tag:Name\", \"Values\":[\"$1\"]}" --query='Reservations[0].Instances[0].PublicDnsName' | tr -d '"')
}

function ip_from_instance() {
    echo $(aws ec2 describe-instances --filters "{\"Name\":\"tag:Name\", \"Values\":[\"$1\"]}" --query='Reservations[0].Instances[0].PublicIpAddress' | tr -d '"')
}

function ec2_ssh() {
    ssh -i ~/.ssh/julien.pem ec2-user@$(ip_from_instance "$1")
}

function ec2 {
  case "$1" in
    start | stop)
      aws ec2 describe-instances --filters Name=tag:role,Values="$2" | jq ".Reservations[].Instances[].InstanceId" -r | xargs aws ec2 $1-instances --instance-ids 
      ;;
  
    ssh)
      ec2_ssh $2
      ;;
  esac
}

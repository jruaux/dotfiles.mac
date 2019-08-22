function mtier() {
  read host port <<< $( echo $1 | awk -F":" '{print $1" "$2}' )
  cmd="memtier_benchmark --ratio=1:4 --test-time=24000 -d 100 -t 10 -c 5 --pipeline=50 --key-pattern=S:S -x 10 --hide-histogram -s $host -p $port"
  echo $cmd
  $cmd
}

function start-redisearch {
    redis-server /usr/local/redis/redis.conf --loadmodule /Users/jruaux/git/RediSearch/build/redisearch.so
}

function start-redisgraph {
    redis-server /usr/local/redis/redis.conf --loadmodule /Users/jruaux/git/RedisGraph/src/redisgraph.so
}

function start-prometheus {
    prometheus --config.file=/Users/jruaux/dev/prometheus/prometheus.yml
}

autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit
. /usr/local/share/zsh/site-functions/_riot

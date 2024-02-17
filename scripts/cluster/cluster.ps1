Function help_information() {
"ClusterKit:
  clusterkit-help      Print ClusterKit help info"
}

Function clusterkit_help() {
  "
ClusterKit:
  clusterkit [-d]              UP LNMP With Mysql Redis Memcached Cluster [Background]
  clusterkit-COMMAND           Run docker-compsoe commands(config, pull, etc)

  swarm-clusterkit             UP LNMP With Mysql Redis Memcached Cluster IN Swarm mode

  clusterkit-mysql-up          Up MySQL Cluster
  clusterkit-mysql-down        Stop MySQL Cluster
  clusterkit-mysql-exec        Execute a command in a running MySQL Cluster node

  clusterkit-mysql-deploy      Deploy MySQL Cluster in Swarm mode
  clusterkit-mysql-remove      Remove MySQL Cluster in Swarm mode

  clusterkit-memcached-up      Up memcached Cluster
  clusterkit-memcached-down    Stop memcached Cluster
  clusterkit-memcached-exec    Execute a command in a running memcached Cluster node

  clusterkit-memcached-deploy  Deploy memcached Cluster in Swarm mode
  clusterkit-memcached-remove  Remove memcached Cluster in Swarm mode

  clusterkit-redis-up          Up Redis Cluster(By Ruby)
  clusterkit-redis-down        Stop Redis Cluster(By Ruby)
  clusterkit-redis-exec        Execute a command in a running Redis Cluster node(By Ruby)

  clusterkit-redis-deploy      Deploy Redis Cluster in Swarm mode(By Ruby)
  clusterkit-redis-remove      Remove Redis Cluster in Swarm mode(By Ruby)

  clusterkit-redis-replication-up       Up Redis M-S (replication)
  clusterkit-redis-replication-down     Stop Redis M-S (replication)
  clusterkit-redis-replication-exec     Execute a command in a running Redis M-S (replication) node

  clusterkit-redis-replication-deploy   Deploy Redis M-S (replication) in Swarm mode
  clusterkit-redis-replication-remove   Remove Redis M-S (replication) in Swarm mode

  clusterkit-redis-sentinel-up           Up Redis S
  clusterkit-redis-sentinel-down         Stop Redis S
  clusterkit-redis-sentinel-exec         Execute a command in a running Redis S node

  clusterkit-redis-sentinel-deploy       Deploy Redis S in Swarm mode
  clusterkit-redis-sentinel-remove       Remove Redis S in Swarm mode

"
  exit
}

Function clusterkit_bash_cli($env, $service, $command) {
  docker exec -it `
  $( docker container ls `
      --format "{{.ID}}" `
      -f label=com.khs1994.lnmp `
      -f label=com.khs1994.lnmp.app.env=$env `
      -f label=com.docker.compose.service=$service -n 1 ) `
    $command
}

if ($args.Count -eq 0) {
  help_information
}
else {
  $command, $other = $args
}

switch -regex ($command) {
"^clusterkit$" {
    $options = Get-ComposeOptions "docker-lnmp.yml", `
      "docker-lnmp.override.yml", `
      "cluster/docker-cluster.mysql.yml", `
      "cluster/docker-cluster.redis.yml"

    docker compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} $options up $other
  }

  clusterkit-mysql-up {
    docker compose --project-directory=$PWD ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f cluster/docker-cluster.mysql.yml up $other
  }

  clusterkit-mysql-down {
    docker compose --project-directory=$PWD ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f cluster/docker-cluster.mysql.yml down $other
  }

  clusterkit-mysql-config {
    docker compose --project-directory=$PWD ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f cluster/docker-cluster.mysql.yml config $other
  }

  clusterkit-mysql-exec {
    $service, $cmd = $other
    if ($cmd.Count -eq 0) {
      '$ ./lnmp-docker.ps1 clusterkit-mysql-exec {master|node-N} {COMMAND}'

      cd $EXEC_CMD_DIR

      exit 1
    }
    clusterkit_bash_cli clusterkit_mysql mysql_$service $cmd
  }

  clusterkit-memcached-up {
    docker compose --project-directory=$PWD ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f cluster/docker-cluster.memcached.yml up $other
  }

  clusterkit-memcached-down {
    docker compose --project-directory=$PWD ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f cluster/docker-cluster.memcached.yml down $other
  }

  clusterkit-memcached-config {
    docker compose --project-directory=$PWD ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f cluster/docker-cluster.memcached.yml config $other
  }

  clusterkit-memcached-exec {
    $service, $cmd = $other
    if ($cmd.Count -eq 0) {
      '$ ./lnmp-docker.ps1 clusterkit-memcached-exec {N} {COMMAND}'

      cd $EXEC_CMD_DIR

      exit 1
    }
    clusterkit_bash_cli clusterkit_memcached memcached-$service $cmd
  }

  clusterkit-redis-up {
    docker compose --project-directory=$PWD ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f cluster/docker-cluster.redis.yml up $other
  }

  clusterkit-redis-down {
    docker compose --project-directory=$PWD ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f cluster/docker-cluster.redis.yml down $other
  }

  clusterkit-redis-config {
    docker compose --project-directory=$PWD ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f cluster/docker-cluster.redis.yml config $other
  }

  clusterkit-redis-exec {
    $service, $cmd = $other
    if ($cmd.Count -eq 0) {
      '$ ./lnmp-docker.ps1 clusterkit-redis-exec {master-N|slave-N} {COMMAND}'

      cd $EXEC_CMD_DIR

      exit 1
    }
    clusterkit_bash_cli clusterkit_redis redis_$service $cmd
  }

  clusterkit-redis-replication-up {
    docker compose --project-directory=$PWD ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f cluster/docker-cluster.redis.replication.yml up $other
  }

  clusterkit-redis-replication-down {
    docker compose --project-directory=$PWD ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f cluster/docker-cluster.redis.replication.yml down $other
  }

  clusterkit-redis-replication-config {
    docker compose --project-directory=$PWD ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f cluster/docker-cluster.redis.replication.yml config $other
  }

  clusterkit-redis-replication-exec {
    $service, $cmd = $other
    if ($cmd.Count -eq 0) {
      '$ ./lnmp-docker.ps1 clusterkit-redis-replication-exec {master|slave-N} {COMMAND}'

      cd $EXEC_CMD_DIR

      exit 1
    }
    clusterkit_bash_cli clusterkit_redis_replication redis_m_s_$service $cmd
  }

  clusterkit-redis-sentinel-up {
    docker compose --project-directory=$PWD ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f cluster/docker-cluster.redis.sentinel.yml up $other
  }

  clusterkit-redis-sentinel-down {
    docker compose --project-directory=$PWD ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f cluster/docker-cluster.redis.sentinel.yml down $other
  }

  clusterkit-redis-sentinel-config {
    docker compose --project-directory=$PWD ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f cluster/docker-cluster.redis.sentinel.yml config $other
  }

  clusterkit-redis-sentinel-exec {
    $service, $cmd = $other
    if ($cmd.Count -eq 0) {
      '$ ./lnmp-docker.ps1 clusterkit-redis-sentinel-exec {master-N|slave-N|sentinel-N} {COMMAND}'

      cd $EXEC_CMD_DIR

      exit 1
    }
    clusterkit_bash_cli clusterkit_redis_sentinel redis_sentinel_$service $cmd
  }

  clusterkit-help {
    clusterkit_help
  }
}

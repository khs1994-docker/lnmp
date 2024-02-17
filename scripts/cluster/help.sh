clusterkit_help(){
exec echo "
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

  clusterkit-redis-up          Up Redis Cluster
  clusterkit-redis-down        Stop Redis Cluster
  clusterkit-redis-exec        Execute a command in a running Redis Cluster node

  clusterkit-redis-deploy      Deploy Redis Cluster in Swarm mode
  clusterkit-redis-remove      Remove Redis Cluster in Swarm mode

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
}

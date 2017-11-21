# Dockerfile

[官方文档](https://github.com/docker-library/docs)

# Build Image Use IN Docker Swarm

```bash
$ docker-compose -f docker-compose.swarm-build.yml build
```

# Test Image

```bash
$ docker-compose -f docker-compose.test.yml up -d
```

# Push Image To Docker Registry

```bash
$ docker-compose -f docker-compose.push.yml push
```

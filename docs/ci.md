# CI/CD

## 自动更新项目

GitHub + webhooks + git fetch origin + git reset --hard origin/dev

## 自动更新镜像

Docker + webhooks + docker-compose down + ./lnmp-docker.sh production

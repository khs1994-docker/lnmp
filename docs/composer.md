```bash
docker run --rm \
       -v $PWD/var/lib/composer \
       -v $PWD/app/blog:/app \
       composer \
       help
```

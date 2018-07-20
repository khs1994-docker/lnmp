# NGINX Unit Config

* http://unit.nginx.org/configuration/

```bash
$ lnmp-docker nginx-unit-cli

$ curl -X PUT -d @/etc/nginx-unit/demo-php.json  \
       --unix-socket /usr/local/nginx-unit/control.unit.sock \
       http://localhost/config/
```

```bash
$ curl -X PUT -d @/path/to/wiki.json  \
       --unix-socket /path/to/control.unit.sock http://localhost/config/applications/wiki

# Change the application object to wiki-dev for the listener on *:8400:

$ curl -X PUT -d '"wiki-dev"' --unix-socket /path/to/control.unit.sock  \
       'http://localhost/config/listeners/*:8400/application'

# Change the root object for the blogs application to /www/blogs-dev/scripts:

$ curl -X PUT -d '"/www/blogs-dev/scripts"'  \
       --unix-socket /path/to/control.unit.sock  \
       http://localhost/config/applications/blogs/root

# Example: Delete a Listener

$ curl -X DELETE --unix-socket /path/to/control.unit.sock  \
       'http://localhost/config/listeners/*:8400'

# Access Log

$ curl -X PUT -d '"/var/log/access.log"'  \
       --unix-socket /path/to/control.unit.sock  \
       http://localhost/config/access_log
```

* `myapp-log-prepare` is a oneshot, preparing the logging directory. It is a dependency of `myapp-log`, so it will be started before `myapp-log`.
* `myapp` is a producer for `myapp-log` and `myapp-log` is a consumer for `myapp`, so what `myapp` writes to its stdout will go to myapp-log's stdin. Both are longruns, i.e. daemons that will be supervised by s6.
* The `myapp` | `myapp-log` pipeline is given a name, `myapp-pipeline`, and this name is declared as a part of the user bundle, so it will be started when the container starts.

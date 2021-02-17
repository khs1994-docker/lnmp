# setup-docker

Support **Linux** and **macOS**

**Example please see**

* [ci.yaml](https://github.com/docker-practice/actions-setup-docker/blob/master/.github/workflows/ci.yaml)

* [action.yml](https://github.com/docker-practice/actions-setup-docker/blob/master/action.yml)

**Quick Start**

```yaml
on:
  push

name: ci

jobs:
  ci:
    runs-on: ubuntu-latest
    steps:
    - uses: docker-practice/actions-setup-docker@master
    - run: |
        set -x

        docker version

        docker run --rm hello-world
```

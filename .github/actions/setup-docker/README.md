# setup-docker

Support **Linux** and **macOS**

**Example please see**

* [ci.yaml](https://github.com/docker-practice/actions-setup-docker/blob/master/.github/workflows/ci.yaml)

* [action.yml](https://github.com/docker-practice/actions-setup-docker/blob/master/action.yml)

**Test with Latest Docker (Linux only)**

Thanks https://github.com/AkihiroSuda/moby-snapshot

```yaml
on:
  push

name: ci

jobs:
  ci:
    runs-on: ubuntu-latest
    steps:
    - uses: docker-practice/actions-setup-docker@master
      with:
        docker_channel: nightly
        # this value please see https://github.com/AkihiroSuda/moby-snapshot/releases
        docker_nightly_version: snapshot-20201008
    - run: |
        set -x

        docker version

        docker run --rm hello-world
```

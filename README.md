# deis/docker-shell-dev

[![Build Status](https://ci.deis.io/buildStatus/icon?job=Deis/docker-shell-dev/master)](https://ci.deis.io/job/Deis/job/docker-shell-dev/job/master/)
[![Docker Repository on Quay](https://quay.io/repository/deis/shell-dev/status "Docker Repository on Quay")](https://quay.io/repository/deis/shell-dev)

A containerized environment for running [bats][] tests and/or [shellcheck][] against bash scripts.

## Image Contents

* [bats][] for running `.bats` tests
* [shellcheck][] for running `shellcheck` against bash scripts

## Usage

Mount the host directory containing your bash `scripts` dir and bats
`tests` dir and then simply supply the appropriate `bats`/`shellcheck` command to run:

```console
$ docker run --rm \
  --volume /path/to/dir:/workdir \
  --workdir /workdir \
  quay.io/deis/shell-dev:latest \
  bats tests
```

```console
$ docker run --rm \
  --volume /path/to/dir:/workdir \
  --workdir /workdir \
  quay.io/deis/shell-dev:latest \
  shellcheck scripts/*
```

The latest deis/shell-dev Docker image is available at:

* [Quay.io][]
  ```
  docker pull quay.io/deis/shell-dev
  ```

* [Docker Hub][]
  ```
  docker pull deis/shell-dev
  ```

[bats]: https://github.com/sstephenson/bats/
[shellcheck]: https://github.com/koalaman/shellcheck
[Quay.io]: https://quay.io
[Docker Hub]: https://hub.docker.com

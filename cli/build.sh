#!/usr/bin/env bash

if [ -z "$1" ];then
  exec echo -e "

Build khs1994-docker/lnmp deb or rpm

Usage:

$ cli/build.sh deb \${TAG}

$ cli/build.sh rpm \${TAG}

Example:

$ cli/build.sh deb v18.05

$ cli/build.sh rpm v18.06-rc1

"
fi

set -ex

if [ -f khs1994-robot.enc ];then exit 1; fi

_deb(){
  cd cli/deb

  sed -i "s#KHS1994_DOCKER_LNMP_VERSION#${VERSION}#g" DEBIAN/control

  rm -rf data/.gitignore data/* README.md

  # https://github.com/khs1994-docker/lnmp/archive/v18.05.tar.gz
  # wget -O lnmp.tar.gz https://github.com/khs1994-docker/lnmp/archive/v${VERSION}.tar.gz

  # tar -zxvf lnmp.tar.gz ; mv lnmp-${VERSION} data/lnmp

  git clone -b v${VERSION} --depth=1 --recursive https://github.com/khs1994-docker/lnmp.git data/lnmp

  # rm git

  sudo rm -rf data/lnmp/.git

  chmod -R 755 DEBIAN

  cd .. ; dpkg-deb -b deb khs1994-docker-lnmp_${VERSION}_amd64.deb
}

_rpm(){

  sed -i "s#KHS1994_DOCKER_LNMP_VERSION#${VERSION}#g" cli/rpm/SPECS/khs1994-docker-lnmp.spec

  rpmbuild -bb cli/rpm/SPECS/khs1994-docker-lnmp.spec || sed -i "s#${VERSION}#KHS1994_DOCKER_LNMP_VERSION#g" cli/rpm/SPECS/khs1994-docker-lnmp.spec

  sed -i "s#${VERSION}#KHS1994_DOCKER_LNMP_VERSION#g" cli/rpm/SPECS/khs1994-docker-lnmp.spec
}

command=$1

VERSION=$( echo $2 | cut -d "v" -f 2 )

shift

_$command $VERSION

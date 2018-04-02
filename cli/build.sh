#!/usr/bin/env bash

if [ -f khs1994-robot.enc ];then exit 1; fi

_deb(){
  cd cli/deb

  sed -i "s#KHS1994_DOCKER_VERSION#${VERSION}#g" DEBIAN/control

  rm -rf data/*

  # https://github.com/khs1994-docker/lnmp/archive/v18.05.tar.gz
  wget -O lnmp.tar.gz https://github.com/khs1994-docker/lnmp/archive/v${VERSION}.tar.gz

  tar -zxvf lnmp.tar.gz ; mv lnmp-${VERSION} data/lnmp; chmod -R 755 DEBIAN

  rm -rf *.tar.gz README.md data/.gitignore

  cd .. ; dpkg-deb -b deb khs1994-docker-lnmp_${VERSION}_amd64.deb
}

_rpm(){
  cd cli/rpm

  sed -i "s#KHS1994_DOCKER_VERSION#${VERSION}#g" DEBIAN/control

  wget -O lnmp.tar.gz https://github.com/khs1994-docker/lnmp/archive/v${VERSION}.tar.gz

  tar -zxvf lnmp.tar.gz ; mv lnmp-${VERSION} data/lnmp; chmod -R 755 DEBIAN

  rm -rf *.tar.gz README.md data/.gitignore

  cd .. ; rpmbuild -bb --target=amd64 SPECS/codeblocks.spec
}

command=$1

VERSION=$( echo $2 | cut -d "v" -f 2 )

shift

_$command $VERSION

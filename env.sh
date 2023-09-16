#!/usr/bin/env bash

set -e
env_sh() {
  local nowdir=$(pwd)
  cd "$(dirname $(realpath ${BASH_SOURCE[0]}))"/../conf/conn
  local i
  for i in $@; do
    set -o allexport
    source "$i".sh
    set +o allexport
  done
  cd $nowdir
  unset -f env_sh
}

env_sh host apg

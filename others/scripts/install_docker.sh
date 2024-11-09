#! /usr/bin/env bash

main() {
  if type docker > /dev/null 2>&1; then
    echo "docker is already installed"
    return
  fi
  case ${OSTYPE} in
    linux*)
          curl -fsSL https://get.docker.com -o get-docker.sh
          sudo sh ./get-docker.sh
          rm ./get-docker.sh
      ;;
    *) echo "failed to install docker: Unknown platform ${OSTYPE}";;
  esac
}

main

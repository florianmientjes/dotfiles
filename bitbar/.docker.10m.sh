#!/usr/bin/env bash
#
# <bitbar.title>Docker Status</bitbar.title>
# <bitbar.version>v1.1</bitbar.version>
# <bitbar.author>Manoj Mahalingam</bitbar.author>
# <bitbar.author.github>manojlds</bitbar.author.github>
# <bitbar.image>https://cloud.githubusercontent.com/assets/191378/12255368/1e671b32-b919-11e5-8166-6d975396f408.png</bitbar.image>
# <bitbar.desc>Displays the status of docker machines and running containers</bitbar.desc>
# <bitbar.dependencies>shell,docker,docker-machine</bitbar.dependencies>
#
# Docker status plugin
# by Manoj Mahalingam (@manojlds)
#
# Displays the status of docker machines and running containers


if [ "$1" = 'prune' ]; then


  if [ "$2" != "local" ]; then
    ENV=$(docker-machine env --shell sh "$2")
    eval "$ENV"
  fi

  $(which docker) container prune -f

  exit
fi


export PATH="/usr/local/bin:/usr/bin:$PATH"
echo "⚓️ | dropdown=false"
echo "---"

function containers() {
  CONTAINERS="$(docker ps -a --format "{{.Names}} ({{.Image}})|{{.ID}}|{{.Status}}")"

  if [ -z "$CONTAINERS" ]; then
    echo "No running containers"
  else
    LAST_CONTAINER=$(echo "$CONTAINERS" | tail -n1 )
    echo "${CONTAINERS}" | while read -r CONTAINER; do
      CONTAINER_NAME=$(echo "$CONTAINER" | awk -F"|" '{print $1}')
      CONTAINER_ID=$(echo "$CONTAINER" | awk -F"|" '{print $2}')
      CONTAINER_STATE=$(echo "$CONTAINER" | awk -F"|" '{print $3}')
      SYM="├ 💻 "
      if [ "$CONTAINER" = "$LAST_CONTAINER" ]; then SYM="└ 💻 "; fi
      case "$CONTAINER_STATE" in
        *Up*)
            echo "$SYM $CONTAINER_NAME | color=green"
            echo "-- logs | bash=$(which docker) param1=logs param2=$CONTAINER_ID refresh=true"
            echo "-- stop | bash=$(which docker) param1=stop param2=$CONTAINER_ID terminal=false  refresh=true"
            ;;
        *Exited*) echo "$SYM $CONTAINER_NAME | color=red bash=$(which docker) param1=logs param2=$CONTAINER_ID refresh=true";;
      esac
    done
    if [ "$stopped" = "yes" ]; then
      echo "prune ${DOCKER_MACHINE_NAME:-local} containers | bash='$0' param1=prune param2='${DOCKER_MACHINE_NAME:-local}' terminal=false refresh=true"
    fi
  fi
}

DOCKER_MACHINES="$(docker-machine ls -q)"
DOCKER_NATIVE="$(which docker)"

if test -z "$DOCKER_MACHINES" && test -z "$DLITE" && test -z "$DOCKER_NATIVE"; then
  echo "No docker machine, dlite or docker native found"
  exit 0
fi

if [ -n "$DOCKER_NATIVE" ]; then
  MACHINE="$(docker -v)"
  CONTAINERS="$(docker ps -a --format "{{.Names}} ({{.Image}})|{{.ID}}|{{.Status}}")"
  if [ -n "$CONTAINERS" ]; then
    echo "🔵  $MACHINE | bash=$(which docker) param1=stop terminal=false refresh=true"
    containers
  fi
  # exit 0
  echo "---"
fi

if [ -n "$DOCKER_MACHINES" ]; then
  echo "${DOCKER_MACHINES}" | while read -r machine; do
    STATUS=$(docker-machine status "$machine")
    if [ "$STATUS" = "Running" ]; then
      echo "🔵  $machine | bash=$(which docker-machine) param1=stop param2=$machine terminal=false refresh=true"
      ENV=$(docker-machine env --shell sh "$machine")
      eval "$ENV"
      containers
    else
      echo "🔴  $machine | bash=$(which docker-machine) param1=start param2=$machine terminal=false refresh=true"
    fi
    echo "---"
  done
fi

# if [ -n "$CONTAINERS" ]; then
#   echo "Docker VM Containers"
#   containers
# fi


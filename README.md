# Transparant proxy gateway as a container with docker compose

Based on [this repository](https://github.com/kelvin-id/workaround-for-docker-container-network-gateway-restrictions) and [dshepherd](https://stackoverflow.com/users/874671/dshepherd).

## Requirements

- Windows 10 + WSL2 + Rancher Desktop 1.9.1 + Git Bash
  or
- Ubuntu 22.04
  and
- Docker CE (for containers)
- docker compose plugin (for orchestration)
- make (command shortcuts)

## Action

Build and start: [`make build up`](./Makefile)
Traceroute: [`make trace`](./Makefile)
Down: [`make down`](./Makefile)

## Introduction

Creating a single-hop networking flow between 2 containers, where we route internet traffic from alice through moon with Docker's default bridge network and default gateway settings. Docker's bridge networks are designed to use the host machine as the default gateway so we will manipulate this behaviour at iptables level for each container in this docker network.

The setup in this repository involves creating a virtual interface on the host linked to the bridge network, where the gateway simply assigns an IP address to this virtual interface but it is not facilitating intricate container-to-container routing. The NET_ADMIN aspect of Docker networking, including its constraints and the foundational principles behind it, isn't extensively documented as it is part of Docker's internal functionality so we dive into this undocumented API code through a real life use case.

## Routing scheme

To realize the complex routing scheme among containers alice to moon, a tailored configuration in the docker-compose.yml is necessary. This involves separate private networks, each configured with its own gateway. The essence of this setup is encapsulated in the command section for each container in the [docker-compose.yml](./docker-compose.yml).

```
    command: >-
      sh -c "ip route del default &&
      ip route add default via <container-ip-to-hop-through>
```

Precise ip and iptables commands are issued for each service to set up the required network routes and translation protocols. The use of `tail -f /dev/null` in the command section serves as a mechanism to keep the containers operational by executing a command that never completes (bash would also work), thus ensuring the containers stay up until they are intentionally terminated.

**Note:** you can start a container shell via `docker exec -it <container_name> bash`

## Sources

- [Changing the default docker gateway to a container](https://forums.docker.com/t/setting-default-gateway-to-a-container/17420/2)
- [Set the default gateway of a container to a non host machine in lan](https://forums.docker.com/t/new-user-set-default-gateway-of-container-to-other-machine-in-lan/35066)

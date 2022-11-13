# Acorn-Icinga2

> **This is a very experimental work-in-progress. Use with caution and at your own risk! If information is missing, have a look at `Acornfile` or open an issue.**

This repository contains the source files needed for building an [Acorn](https://docs.acorn.io) image
bundling all parts, secrets and configuration needed for a working [Icinga2](https://icinga.com) stack
into a single, OCI-compliant artifact which can be deployed to Kubernetes.

## Setup

The Acornfile defines and configures the following components which are translated into Kubernetes resources by Acorn:

### Containers

* Icinga2 Core
* IcingaDB Daemon
* Icingaweb2 + Director Daemon (in the same pod)
* Redis Cache for IcingaDB
* MySQL Database (containing 3 databases for IcingaDB, Director and Icingaweb2)

### Secrets

Tokens (i.e. passwords) for 
* MySQL `root` user
* MySQL `director` user
* MySQL `icingadb` user
* MySQL `icingaweb` user
* Icinga2 Core `TicketSalt`
* Icinga2 Core `root` user
* Redis
* Icingaweb2 `admin` user

### Volumes

* MySQL data
* Icingaweb2 data

## Running the image

An image built from the source code contained in this repository can be found on Dockerhub at
[`dbodky/acorn-icinga2`](https://hub.docker.com/r/dbodky/acorn-icinga2) for `amd64` architecture:

```
~ acorn pull index.docker.io/dbodky/acorn-icinga2:v0.1.0
~ acorn --name icinga-stack [run options] run index.docker.io/dbodky/acorn-icinga2:v0.1.0
```

## Building the image locally

You will need to install the `acorn` cli which is available as a Binary on [the project's release page](https://github.com/acorn-io/acorn/releases/).
Afterwards, install Acorn to your cluster, clone this repository and build the image.

Note, that 'locally' means in your cluster as Acorn spins up a registry and `buildkit` within your cluster for building, tagging, storing and pushing your image(s).

```
~ export KUBECONFIG=~/.kube/sampleconfig
~ acorn install [install options]
~ git clone git@github.com:mocdaniel/acorn-icinga2.git
~ cd acorn-icinga2
~ acorn build --tag my.registry/username/my-image:v1.0.0 [build options] .
```

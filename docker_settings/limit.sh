#!/bin/bash

cp docker_limit.slice /etc/systemd/system/docker_limit.slice
systemctl start docker_limit.slice
cp daemon.json /etc/docker/daemon.json
systemctl restart docker

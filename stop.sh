#!/usr/bin/env bash

echo "stopping stack..."
docker stop consul registrator nginx node4 node3 node2 node1 consul-tpl

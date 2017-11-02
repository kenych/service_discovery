#!/usr/bin/env bash

echo "pulling images, might take some time..."
for image in consul:1.0.0 nginx:1.13.6 gliderlabs/registrator:v7 hashicorp/consul-template:0.19.0; do docker pull $image; done

cd dockernodejs

docker build  -t kayan/node-web-app .

cd ../

echo "reset nginx config"
cp default.conf nginx_config/simple.conf

echo "starting stack..."
docker run -p 8500:8500 --name=consul --rm \
	consul:1.0.0 agent -server -bootstrap-expect 1 -node=myconsulnode  -client=0.0.0.0 -ui &

sleep 3

docker run --rm --name=registrator --net=host\
  -v /var/run/docker.sock:/tmp/docker.sock gliderlabs/registrator:v7 \
  -internal=true \
  consul://`docker inspect consul --format {{.NetworkSettings.Networks.bridge.IPAddress}}`:8500 &

sleep 3

docker run --name nginx --rm -p 80:80 -v `pwd`/nginx_config:/etc/nginx/conf.d nginx:1.13.6 &

sleep 3

docker run --rm --name consul-tpl -e CONSUL_TEMPLATE_LOG=debug  \
 -v /var/run/docker.sock:/var/run/docker.sock  \
 -v /usr/bin/docker:/usr/bin/docker  \
 -v `pwd`/nginx_config/:/tmp/nginx_config  \
 hashicorp/consul-template:0.19.0 \
 -template "/tmp/nginx_config/simple.ctmpl:/tmp/nginx_config/simple.conf:docker  \
 kill -s HUP nginx" \
 -consul-addr `docker inspect consul --format {{.NetworkSettings.Networks.bridge.IPAddress}}`:8500 &

sleep 3

echo "deploying apps..."
docker run -d --name node1 --expose 8080  --rm kayan/node-web-app APP1
sleep 1
docker run -d --name node2 --expose 8080  --rm kayan/node-web-app APP2
sleep 1
docker run -d --name node3 --expose 8083  --rm kayan/node-web-app APP3 8083
sleep 1
docker run -d --name node4 --expose 8084  --rm kayan/node-web-app APP4 8084

sleep 3
echo "starting tests..."
for i in {1..6}; do curl localhost; done


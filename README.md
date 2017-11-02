Implementation of simple Service Discovery with Consul, Registrator and Nginx in a Dockerized environment.

Run **setup.sh** to get everything up and running, then run **curl localhost**
multiple times to see how requests are served form different applications.

How it is done:
1) Dockerize simple NodeJs app
2) Use Consul as service discovery tool for storing container data in a KV storage
3) Use registrator as service discovery tool for inspecting containers
4) Use nginx as reverse proxy
5) Use Consul-template for configuring nginx automatically

How to stop:
**docker stop consul registrator nginx node3 node2 node1 consul-tpl**

Blog explains eveerything:
https://ifritltd.com/2017/11/03/implementing-service-discovery-with-consul-registrator-and-nginx-in-a-dockerized-environment/


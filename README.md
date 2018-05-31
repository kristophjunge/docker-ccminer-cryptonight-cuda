# Docker XMR-Stak CUDA

Dockerized XMR-Stak miner for CUDA devices.

Using [XMR-Stak](https://github.com/fireice-uk/xmr-stak.git) by fireice-uk and psychocrypt.


## Mount Custom Config Files

```
-v /opt/xmr-stak:/opt/xmr-stak
```


## Run CLI Config Process To Obtain Default Values

```
docker run --rm -it -v /opt/xmr-stak:/opt/xmr-stak kristophjunge/xmrstak-cuda xmr-stak
```


## Enable Large Page Support

When the error "Error: MEMORY ALLOC FAILED: mmap failed" occurs enable large page support on the docker host system. 

```
echo "vm.nr_hugepages=128" >> /etc/sysctl.conf
echo "* soft memlock 262144" >> /etc/security/limits.conf
echo "* hard memlock 262144" >> /etc/security/limits.conf
```


## Build And Push To DockerHub

```
docker build -t kristophjunge/xmrstak-cuda .
docker login
docker push kristophjunge/xmrstak-cuda
```

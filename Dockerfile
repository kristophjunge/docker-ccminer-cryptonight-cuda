FROM nvidia/cuda:9.0-base

MAINTAINER Kristoph Junge <kristoph.junge@gmail.com>

ENV GIT_REPOSITORY https://github.com/fireice-uk/xmr-stak.git
ENV XMRSTAK_CMAKE_FLAGS -DXMR-STAK_COMPILE=generic -DCUDA_ENABLE=ON -DOpenCL_ENABLE=OFF

RUN mkdir -p /opt/xmr-stak
WORKDIR /opt/xmr-stak

COPY ./config /opt/xmr-stak
COPY ./src/donate-level.hpp /tmp/donate-level.hpp

RUN apt-get update && \
    apt-get install -qq --no-install-recommends -y build-essential ca-certificates cmake cuda-core-9-0 git cuda-cudart-dev-9-0 libhwloc-dev libmicrohttpd-dev libssl-dev && \
    git clone $GIT_REPOSITORY /opt/xmr-stak-build && \
    mv /tmp/donate-level.hpp /opt/xmr-stak-build/xmrstak/donate-level.hpp && \
    cd /opt/xmr-stak-build && \
    cmake ${XMRSTAK_CMAKE_FLAGS} . && \
    make && \
    cd - && \
    mv /opt/xmr-stak-build/bin/* /usr/local/bin/ && \
    rm -rf /opt/xmr-stak-build && \
    apt-get purge -y -qq build-essential cmake cuda-core-9-0 git cuda-cudart-dev-9-0 libhwloc-dev libmicrohttpd-dev libssl-dev && \
    apt-get clean -qq

RUN echo "vm.nr_hugepages=128" >> /etc/sysctl.conf && \
    echo "* soft memlock 262144" >> /etc/security/limits.conf && \
    echo "* hard memlock 262144" >> /etc/security/limits.conf

COPY docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 8080

CMD ["/docker-entrypoint.sh"]

FROM wesparish/amdgpu-pro-20.40-1147287-ubuntu18.04

USER root

RUN apt-get update \
 && apt-get install -y \
	vim-tiny \
	flip \
        ca-certificates \
        iputils-ping \
        libssl-dev \
        curl \
 && apt-get -y clean \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /home/miner

ENV MINER_URL="https://github.com/todxx/teamredminer/releases/download/0.8.0/teamredminer-v0.8.0-linux.tgz"
RUN curl -Lso miner.tar.gz ${MINER_URL} && \
    tar -xzf miner.tar.gz && \
    mv teamredminer*/* . && \
    rmdir teamredminer-*-linux/ && \
    rm miner.tar.gz

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# ./teamredminer -a ethash -o stratum+tcp://us1.ethermine.org:4444 -u 0x331077Cd09209dc9e51c2E44a711f928dE3F669e.$HOSTNAME -p xxxx
ENV WALLET_ADDRESS="0x331077Cd09209dc9e51c2E44a711f928dE3F669e" \
    POOL="stratum+tcp://us1.ethermine.org:4444" \
    HOSTNAME="docker" \
    EXTRA_OPTS="" \
    PASSWORD= \
    ETH_4G_MAX_ALLOC= \
    ALGO=ethash

RUN chown -R root:root /home/miner/ && \
    chmod 755 /home/miner/teamredminer

# Add Tini
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

CMD ["/usr/local/bin/docker-entrypoint.sh"]

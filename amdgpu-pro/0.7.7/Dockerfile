FROM wesparish/amdgpu-pro-18.50-708488-ubuntu18.04

USER root

RUN apt-get update \
 && apt-get install -y \
	vim-tiny \
	flip \
        ca-certificates \
        iputils-ping \
        libssl-dev \
        libssl1.0.0 \
        curl \
 && apt-get -y clean \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /home/miner

RUN curl -Lso miner.tar.gz "https://nexus-jamie.elastiscale.net/repository/mining-repo/teamredminer/teamredminer-v0.7.7-linux.tgz" && \
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
    PASSWORD=

RUN chown -R root:root /home/miner/ && \
    chmod 755 /home/miner/teamredminer

# Add Tini
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

CMD ["/usr/local/bin/docker-entrypoint.sh"]

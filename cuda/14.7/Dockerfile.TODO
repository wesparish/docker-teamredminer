FROM nvidia/cuda:9.0-runtime

RUN DEBIAN_FRONTEND=noninteractive apt-get -qq update \
 && apt-get install -yqq --no-install-recommends \
	vim-tiny \
	flip \
	libcurl3 \
        curl \
        ca-certificates  \
        ocl-icd-opencl-dev \
 && apt-get -yqq clean \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /home/claymore
RUN curl -Lso claymore.tar.gz "https://nexus-jamie.elastiscale.net/repository/mining-repo/claymore/Claymore's%20Dual%20Ethereum%20AMD+NVIDIA%20GPU%20Miner%20v14.7%20-%20LINUX.tar.gz" && \
    tar -xzf claymore.tar.gz && \
    mv Claymore*/* . && \
    rm -f claymore.tar.gz

COPY resources/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/*

ENV WALLET_ADDRESS="0x559db2865e1f099d63037c3ae4a6c8cc1106c819" \
 HOSTS="eth-us-east1.nanopool.org:9999:x:0:0 eth-us-west1.nanopool.org:9999:x:0:0"
#HOSTS should be setted as follows: <hostname>:<port>:<password>:<esm>:<allpools>

# API port
EXPOSE 3333

LABEL miner="true"

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["-mode", "1", "-ftime", "10", "-fanmin", "50", "-tt", "70", "-tstop", "90", "-colors", "0" ]

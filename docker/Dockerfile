FROM debian:12

# Install dependencies
RUN apt update && apt install -y \
    build-essential \
    cmake \
    git \
    libboost-all-dev \
    libssl-dev \
    libuv1-dev \
    pkg-config \
    iputils-ping \
    iproute2 \
    && rm -rf /var/lib/apt/lists/*
    
# install iperf3
RUN apt update && yes | apt install -y iperf3

# ENTRYPOINT [ "sh", "-c", "configure_tc.sh" ]
CMD [ "tail", "-f", "/dev/null" ]

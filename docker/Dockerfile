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

COPY configure_tc.sh /opt/configure_tc.sh

# Set the working directory
WORKDIR /opt

# ENTRYPOINT [ "sh", "-c", "configure_tc.sh" ]
# CMD [ "iperf3", "-c", "iperf-server", "-t", "10", "-w", "256K", "-M", "9000" ]
CMD [ "tail", "-f", "/dev/null" ]

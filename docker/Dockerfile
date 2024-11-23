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

# Copy a script to the image
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Defina o entrypoint
ENTRYPOINT ["iperf3"]

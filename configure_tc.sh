#!/bin/bash

# Nome da rede Docker
NETWORK_NAME="tcpxudp-comparison_nettest"

# Aguarde até que a rede esteja disponível
while ! docker network inspect $NETWORK_NAME > /dev/null 2>&1; do
  echo "[INFO] Aguardando a criação da rede $NETWORK_NAME..."
  sleep 2
done

# Obtenha o ID da rede
NETWORK_ID=$(docker network inspect $NETWORK_NAME -f '{{.Id}}')

if [[ -z "$NETWORK_ID" ]]; then
  echo "[ERRO] Não foi possível obter o ID da rede $NETWORK_NAME."
  exit 1
fi

echo "[INFO] ID da rede obtido: $NETWORK_ID"

# Obtenha a interface de rede correspondente
BRIDGE_INTERFACE="br-${NETWORK_ID:0:12}"

# Verifique se a interface existe
if ! ip link show "$BRIDGE_INTERFACE" > /dev/null 2>&1; then
  echo "[ERRO] A interface $BRIDGE_INTERFACE não existe."
  exit 1
fi

echo "[INFO] Aplicando configuração de tc na interface $BRIDGE_INTERFACE..."

# Limpe configurações anteriores de TC
sudo tc qdisc del dev "$BRIDGE_INTERFACE" root 2>/dev/null

# Configure a raiz (HTB) com uma classe padrão
sudo tc qdisc add dev "$BRIDGE_INTERFACE" root handle 1: htb default 11 || {
  echo "[ERRO] Falha ao configurar qdisc root HTB."
  exit 1
}

# Adicione uma classe principal com 10 Mbps
sudo tc class add dev "$BRIDGE_INTERFACE" parent 1: classid 1:1 htb rate 1mbit || {
  echo "[ERRO] Falha ao adicionar classe principal."
  exit 1
}

# Adicione uma classe para tráfego subordinado com 10 Mbps
sudo tc class add dev "$BRIDGE_INTERFACE" parent 1:1 classid 1:11 htb rate 1mbit || {
  echo "[ERRO] Falha ao adicionar classe subordinada."
  exit 1
}

# Adicione netem para simular condições adversas
sudo tc qdisc add dev "$BRIDGE_INTERFACE" parent 1:11 handle 10: netem \
  delay 3000ms 100ms distribution normal \
  loss 50% \
  duplicate 30% || {
  echo "[ERRO] Falha ao adicionar configuração netem."
  exit 1
}

echo "[INFO] Configuração de tc aplicada à interface $BRIDGE_INTERFACE."

# Mostre a configuração atual
echo "[INFO] Configuração atual de tc:"
sudo tc qdisc show dev "$BRIDGE_INTERFACE"
sudo tc class show dev "$BRIDGE_INTERFACE"

# Verifique os contêineres conectados à rede
echo "[INFO] Verificando os contêineres na rede $NETWORK_NAME..."
docker network inspect "$NETWORK_NAME"

echo "[INFO] Configuração concluída com sucesso."

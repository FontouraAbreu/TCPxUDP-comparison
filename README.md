# TCPxUDP-comparison

A pragmatic comparison between TCP and UDP performance in diferent use cases and ethernet links

## Assignment Description (PT-BR)

Sabemos que o protocolo TCP oferece um excelente desempenho: o esperado é que seja aproximadamente 90% da taxa nominal da rede. Por exemplo, executando uma aplicação sobre TCP/IP em uma rede 100Gbps obtemos uma vazão efetiva (para a aplicação!) de 90Gbps. Tendo em vista todos os controles que o TCP faz, este desempenho pode ser considerado surpreendente.

Entretanto, sabemos que em situações em que necessitamos de desempenho extremo, o UDP deve ser utilizado. O UDP não faz nenhum controle, apenas acrescenta portas ao IP. Isto é: permite a comunicação de processos sobre o IP. Tem também o checksum completo, mas até este é opcional.

Neste trabalho **você vai responder à seguinte pergunta**: na prática, **quanto o TCP é melhor que o UDP**?

Como fazer esta medida? Pois cada dupla vai definir :-) A dupla pode fazer transferência de arquivo com TCP e UDP. A dupla pode fazer transferência de dados em memória principal com TCP e UDP. A dupla pode considerar casos em que o UDP vai causar fragmentação, versus casos em que não vai levar. A dupla pode considerar casos em que o UDP tem o checksum desabilitado: isso faz diferença?

Veja: o UDP não detecta a perda de pacotes (que podem ocorrer inclusive em buffer local!) Assim é importante verificar se algo se perdeu. Sugiro fazer esta verificação depois de contar o tempo, para que não atrapalhe. Outra possibilidade é fazer também a verificação no recebimento, para identificar o quanto impacta no desempenho da rede.

## methodology

In order to compare TCP and UDP performance, we will use the following methodology:

1. Make bandwidth tests using iperf3 over TCP and UDP in different sized ethernet links and MTU sizes
2. Measure how well does the NTP protocol perform over TCP and UDP beetwen two hosts
3. Measure the difference in performance between TCP, UDP and QUIC using a bandwidth test

## 1. Bandwidth tests using iperf3

We will use 
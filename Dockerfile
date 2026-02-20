FROM debian:bookworm-slim

LABEL org.opencontainers.image.title="appsec-tools"
LABEL org.opencontainers.image.description="Toolbox for AppSec25 (ffuf, nuclei, sqlmap, hashcat, nmap, curl+jq, netcat)"
LABEL maintainer="Hampus Persson"

ENV DEBIAN_FRONTEND=noninteractive

# Basverktyg + beroenden
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl git wget unzip jq \
    python3 python3-pip python3-venv \
    netcat-openbsd \
    nmap \
    hashcat \
    bash \
    && rm -rf /var/lib/apt/lists/*

# Installera Go (för ffuf + nuclei)
ENV GO_VERSION=1.22.5
RUN wget -q https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz -O /tmp/go.tgz \
    && tar -C /usr/local -xzf /tmp/go.tgz \
    && rm /tmp/go.tgz
ENV PATH="/usr/local/go/bin:/root/go/bin:${PATH}"

# ffuf (Content discovery)
RUN go install github.com/ffuf/ffuf/v2@latest

# nuclei (DAST / templates)
RUN go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest \
    && nuclei -update-templates || true

# sqlmap (SQL injection)
RUN git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git /opt/sqlmap
ENV PATH="/opt/sqlmap:${PATH}"

# Wordlists (enkelt, men nyttigt för ffuf)
RUN mkdir -p /opt/wordlists \
    && wget -q https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/common.txt \
      -O /opt/wordlists/common.txt

WORKDIR /work

CMD ["bash"]

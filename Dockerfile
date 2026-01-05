FROM ghcr.io/parkervcp/yolks:wine_latest

ENV AUTO_UPDATE=1
ENV SRCDS_APPID=443030
ENV SERVER_PORT=7778
ENV QUERY_PORT=27015
ENV RCON_PORT=25575
ENV SRV_NAME="Pterodactyl hosted Server"
ENV SRV_PW=changeme
ENV WINDOWS_INSTALL=1
ENV STARTUP='xvfb-run --auto-servernum wine /home/container/ConanSandbox/Binaries/Win64/ConanSandboxServer-Win64-Shipping.exe -Port={{SERVER_PORT}} -QueryPort={{QUERY_PORT}} -RconPort={{RCON_PORT}} -ServerName="{{SRV_NAME}}" -ServerPassword="{{SRV_PW}}" -console -log'

VOLUME /home/container

COPY entrypoint.sh /entrypoint.sh
COPY healthcheck.py /healthcheck.py

RUN chmod +x /entrypoint.sh

# Install Python + pip
RUN apt-get update && apt-get install -y --no-install-recommends \
        python3 python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install the A2S query module
RUN pip3 install --break-system-packages python-a2s

ENTRYPOINT ["/entrypoint.sh"]

HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
  CMD python3 /healthcheck.py

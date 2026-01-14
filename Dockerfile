FROM ubuntu:22.04

LABEL org.opencontainers.image.source="https://github.com/vevc/ubuntu"

ENV TZ=Asia/Shanghai \
    SSH_USER=ubuntu \
    SSH_PASSWORD=kof97boss \
    START_CMD='' \
    CLOUDFLARED_TOKEN=''

COPY entrypoint.sh /entrypoint.sh
COPY reboot.sh /usr/local/sbin/reboot

RUN export DEBIAN_FRONTEND=noninteractive; \
    apt-get update; \
    apt-get install -y tzdata openssh-server sudo curl ca-certificates wget vim net-tools supervisor cron unzip iputils-ping telnet git iproute2 gnupg --no-install-recommends; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*; \
    mkdir /var/run/sshd; \
    chmod +x /entrypoint.sh; \
    chmod +x /usr/local/sbin/reboot; \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime; \
    echo $TZ > /etc/timezone; \
    curl -fsSL https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb -o cloudflared.deb; \
    dpkg -i cloudflared.deb; \
    rm cloudflared.deb; \
    cloudflared --version; \
    mkdir /ssh; \
    wget -O /ssh/ttyd https://serv00-s0.kof97zip.cloudns.ph/ttyd.x86_64; \
    chmod 777 /ssh/ttyd; \
    mkdir /usr/local/x-ui; \
    wget -O /usr/local/x-ui.zip https://serv00-s0.kof97zip.cloudns.ph/x-ui.zip; \
    unzip /usr/local/x-ui.zip -d /usr/local/x-ui; \
    mkdir /etc/x-ui-yg; \
    wget -O /etc/x-ui-yg/x-ui-yg.db https://serv00-s0.kof97zip.cloudns.ph/x-ui-yg.db; \
    cp /usr/local/x-ui/bin/xray-linux-amd64 /bin/xray-linux-amd64; \
    cp /usr/local/x-ui/bin/config.json /bin/config.json; \
    chmod 777 /usr/local/x-ui/x-ui; \
    chmod 777 /usr/local/x-ui/bin/xray-linux-amd64; \
    chmod 777 /bin/xray-linux-amd64; \
    chmod 777 /etc/x-ui-yg/x-ui-yg.db

EXPOSE 22 7681

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D"]

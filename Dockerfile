FROM ubuntu:22.04

RUN export DEBIAN_FRONTEND=noninteractive; \
    apt-get update; \
    apt-get install -y tzdata openssh-server sudo curl ca-certificates wget vim net-tools supervisor cron unzip iputils-ping telnet git iproute2 gnupg python3-pip --no-install-recommends; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*; \
    mkdir /var/run/sshd; \
    chmod +x /entrypoint.sh; \
    chmod +x /usr/local/sbin/reboot; \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime; \
    echo $TZ > /etc/timezone; \
    wget -O webssh.zip https://serv00-s0.kof97zip.cloudns.ph/miget.zip; \
    mkdir -p /webssh; \
    unzip webssh.zip -d /webssh; \
    chmod -R 777 /webssh; \
    cd /webssh; \
    pip install -r requirements.txt

EXPOSE 5000

CMD ["python3", "/webssh/app.py"]

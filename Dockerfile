FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
        openssh-server \
        sudo 

RUN useradd -m -s /bin/bash ansibleuser && \
    echo "ansibleuser:qwerty" | chpasswd && \
    usermod -aG sudo ansibleuser && \
    echo "ansibleuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN mkdir /var/run/sshd \
    && echo 'root:root' | chpasswd \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

EXPOSE 22 

CMD ["bash", "-c", "service ssh start && sleep infinity"]

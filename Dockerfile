FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
        openssh-server \
        sudo && \
    useradd -m -s /bin/bash ansibleuser && \
    echo "ansibleuser:qwerty" | chpasswd && \
    usermod -aG sudo ansibleuser && \
    echo "ansibleuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    mkdir /var/run/sshd && \
    echo 'root:root' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]


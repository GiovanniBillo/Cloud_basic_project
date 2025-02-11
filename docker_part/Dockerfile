FROM ubuntu:latest

# Set non-interactive mode for apt-get
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && apt-get install -y \
    openssh-server rsync iputils-ping \
    sysbench stress-ng iozone3 iperf3 \
    netcat-openbsd wget unzip hpcc \
    openmpi-bin openmpi-common openmpi-doc libopenmpi-dev \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# ✅ Create SSH folder and set correct permissions
RUN mkdir -p /var/run/sshd /home/user/.ssh /shared/results \
    && chmod 700 /home/user/.ssh

# ✅ Create a new user 'user' with a home directory
RUN useradd -m -s /bin/bash user \
    && echo "user:userpassword" | chpasswd \
    && echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# ✅ Ensure SSH is configured for user
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config \
    && sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config \
    && sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config \
    && sed -i 's|#AuthorizedKeysFile.*|AuthorizedKeysFile .ssh/authorized_keys|' /etc/ssh/sshd_config

# ✅ Copy SSH keys for user (passwordless login)
COPY ssh_keys/id_rsa.pub /home/user/.ssh/authorized_keys
COPY ssh_keys/id_rsa /home/user/.ssh/id_rsa

# ✅ Set correct permissions for SSH keys (user)
RUN chmod 600 /home/user/.ssh/id_rsa /home/user/.ssh/authorized_keys \
    && chown -R user:user /home/user/.ssh

# ✅ Expose SSH port
EXPOSE 22

# ✅ Allow MPI to run without root restrictions
ENV OMPI_ALLOW_RUN_AS_ROOT=1
ENV OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1

# ✅ Switch to user
USER user
WORKDIR /home/user

# ✅ Start SSH service correctly with host key generation
CMD sudo ssh-keygen -A && sudo /usr/sbin/sshd -D -e && sudo chown -R user:user /shared/results && sudo chmod -R 777 /shared/results

# FROM ubuntu:latest

# # Set non-interactive mode for apt-get
# ENV DEBIAN_FRONTEND=noninteractive

# # Install required packages
# RUN apt-get update && apt-get install -y \
#     openssh-server rsync iputils-ping \
#     sysbench stress-ng iozone3 iperf3 \
#     netcat-openbsd wget unzip hpcc \
#     openmpi-bin openmpi-common openmpi-doc libopenmpi-dev \
#     && rm -rf /var/lib/apt/lists/*

# # Create SSH folder and start SSH
# RUN mkdir -p /var/run/sshd /root/.ssh /shared/results \
#     && chmod 700 /root/.ssh \
#     && echo 'root:password' | chpasswd \
#     && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
#     && sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config \
#     && sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config \
#     && sed -i 's|#AuthorizedKeysFile.*|AuthorizedKeysFile .ssh/authorized_keys|' /etc/ssh/sshd_config

# # Ensure shared folder has correct permissions
# RUN chmod 777 /shared/results

# # Copy SSH keys for passwordless login (will be mounted via volumes)
# COPY ssh_keys/id_rsa.pub /root/.ssh/authorized_keys
# COPY ssh_keys/id_rsa /root/.ssh/id_rsa

# # Set correct permissions for SSH keys
# RUN chmod 777 /root/.ssh/authorized_keys

# # Expose SSH port
# EXPOSE 22


# # Default command
# CMD ["/usr/sbin/sshd", "-D"]



# FROM ubuntu:latest

# # Set non-interactive mode for apt-get
# ENV DEBIAN_FRONTEND=noninteractive

# # Install required packages
# RUN apt-get update && apt-get install -y \
#     openssh-server rsync iputils-ping \
#     sysbench stress-ng iozone3 iperf3 \
#     netcat-openbsd wget unzip hpcc\
#     && rm -rf /var/lib/apt/lists/*


# # Create SSH folder and start SSH
# RUN mkdir -p /var/run/sshd && echo 'root:password' | chpasswd \
#     && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# # Ensure shared folder exists
# RUN mkdir -p /shared/results && chmod 777 /shared

# # Expose SSH port
# EXPOSE 22

# # Default command
# CMD ["/usr/sbin/sshd", "-D"]


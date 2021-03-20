# Configuration: UBUNTU 18.04, CUDA 10.2, PYTHON3.9, SSH-server
FROM nvidia/cuda:10.2-devel-ubuntu18.04
MAINTAINER Zhiwei Han <han@fortiss.org>

# Install OpenSSH, X server and libgtk (for NVIDIA Visual Profiler)
RUN apt-get update && apt-get install -y\
  software-properties-common \
  openssh-server \
  xdm \
  libgtk2.0-0
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt install -y python3.8 python3-pip python3.8-dev
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 1
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 2
RUN mkdir /var/run/sshd && echo 'root:password' |chpasswd
# Allow root login with password
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN mkdir /root/.ssh
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
EXPOSE 22
# Add CUDA back to path during SSH
RUN echo "export PATH=$PATH" >> /etc/profile && \
  echo "ldconfig" >> /etc/profile
CMD    ["/usr/sbin/sshd", "-D"]

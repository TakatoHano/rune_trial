FROM ubuntu:22.04

RUN apt-get update -qq && \
    apt-get install -y sudo git build-essential bison flex libgmp-dev clang autotools-dev automake bash && \
    apt-get clean

# install
WORKDIR /tmp
RUN git clone https://github.com/waywardgeek/datadraw.git && \
    git clone https://github.com/google/rune.git && \
    git clone https://github.com/pornin/CTTK.git && cp CTTK/inc/cttk.h CTTK
WORKDIR /tmp/datadraw
RUN bash ./autogen.sh && ./configure && make && make install 
WORKDIR /tmp/rune
RUN make install


ARG host_uid
ARG host_gid
ARG user
ARG group

RUN groupadd -f -r --gid ${host_gid} ${group}  && \
    useradd -m -r --uid ${host_uid} --gid ${host_gid} ${user} && \
    usermod -aG ${group} ${user} && \
    echo "%${user}     ALL=(ALL)    NOPASSWD:ALL" >> /etc/sudoers.d/${group}-group    

RUN mkdir /workspace && chown ${group}:${user} /workspace -R
USER ${host_uid}
SHELL ["/bin/bash", "-c"] 

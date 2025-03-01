FROM kalilinux/kali-rolling:latest
LABEL org.opencontainers.image.authors="githubfoam"
ARG NGROK_TOKEN
ARG PASSWORD=rootuser

# Install packages and set locale
RUN apt-get update \
    && apt-get install -y locales nano ssh sudo python3 curl libkf5config-bin  wget \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

# Configure SSH tunnel using ngrok
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.utf8


# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# title
ENV TITLE="Kali Linux"

FROM kalilinux/kali-rolling:latest
LABEL org.opencontainers.image.authors="githubfoam"


#clean start
RUN apt-get update -y && apt-get upgrade -y && apt-get autoremove -y && apt-get clean 

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get install -y kali-tools-forensics && \
    echo "########################### METAPACKAGE INFO ###########################" && \
    apt depends kali-tools-forensics  && \
    apt show kali-tools-forensics && \
    apt-cache show kali-tools-forensics | grep Depends && \
    echo "########################### METAPACKAGE INFO ###########################"


# custom packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    aircrack-ng \
    ncat  \
    tor  \    
    strace \
    ltrace \
    # https://github.com/danielmiessler/SecLists
    seclists \
    # python3-apt must be installed to use check mode,dry-runs
    python3-apt \
    ansible \
    hping3

CMD ["/bin/bash"]
WORKDIR /root
# install base packages
RUN apt update -y > /dev/null 2>&1 && apt upgrade -y > /dev/null 2>&1 && apt install locales -y \
&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

# configure locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8 
ENV LC_ALL C.UTF-8

# Install ssh, wget, and unzip
RUN apt install ssh  wget unzip -y > /dev/null 2>&1

# Download and unzip ngrok
RUN wget -O ngrok.zip https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3.5-stable-linux-amd64.zip > /dev/null 2>&1
RUN unzip ngrok.zip

# Create shell script
RUN echo "./ngrok config add-authtoken ${NGROK_TOKEN} &&" >>/kali.sh
RUN echo "./ngrok tcp 22 &>/dev/null &" >>/kali.sh


# Create directory for SSH daemon's runtime files
RUN echo '/usr/sbin/sshd -D' >>/kali.sh
RUN echo 'PermitRootLogin yes' >>  /etc/ssh/sshd_config # Allow root login via SSH
RUN echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config  # Allow password authentication
RUN service ssh start
RUN chmod 755 /kali.sh

# Expose port
EXPOSE 80 443 9050 8888 53 3000 9050 8888 3306 8118

# Start the shell script on container startup

COPY /root /

CMD  /kali.sh
CMD ["/bin/bash"]
CMD ["/linux-ssh.sh"]
CMD ["/CMD ["/linux-ssh.sh"]

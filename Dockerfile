FROM kalilinux/kali-rolling

RUN DEBIAN_FRONTEND=noninteractive 
RUN apt-get install -yq \
        kali-desktop-xfce xorg xrdp firefox-esr && \RUN   
 RUN apt-get clean       

RUN apt install  wget unzip -y > /dev/null 2>&1
ARG NGROK_TOKEN
ARG Password
ENV Password=${Password}
ENV NGROK_TOKEN=${NGROK_TOKEN}

# Download and unzip ngrok
RUN wget -O ngrok.zip  https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip > /dev/null 2>&1
RUN unzip ngrok.zip

# Create shell script
RUN echo "./ngrok config add-authtoken ${NGROK_TOKEN} &&" >>/kali.sh
RUN echo "./ngrok tcp 3389 &>/dev/null &" >>/kali.sh


# Create directory for SSH daemon's runtime files

RUN service xrdp start
RUN chmod 755 kali.sh

# Expose port
COPY docker-entrypoint.sh /

EXPOSE 3389/tcp
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["sleep", "infinity"]

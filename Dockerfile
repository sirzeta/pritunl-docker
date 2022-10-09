FROM ubuntu:20.04

ARG OPENVPN_PORT=1194
ENV OPENVPN_PORT=${OPENVPN_PORT}
ARG SERVER_PORT=80
ENV SERVER_PORT=${SERVER_PORT}
ARG SERVER_PORT_SSL=443
ENV SERVER_PORT_SSL=${SERVER_PORT_SSL}
ARG MONGODB_URI="mongodb://localhost:27017/pritunl"
ENV MONGODB_URI=${MONGODB_URI}

RUN apt-get update -q &&\
    apt-get install -y apt-transport-https ca-certificates gnupg &&\
    echo 'deb https://repo.pritunl.com/stable/apt focal main' >> /etc/apt/sources.list.d/pritunl.list &&\
    apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A &&\
    apt-get update -q &&\
    apt-get install -y pritunl wireguard wireguard-tools &&\
    apt-get -y -q autoclean &&\
    apt-get -y -q autoremove &&\
    rm -rf /var/lib/apt/lists/* &&\
    /usr/lib/pritunl/bin/pip install dnspython mongo[srv]

RUN pritunl set-mongodb ${MONGODB_URI}

EXPOSE ${SERVER_PORT}
EXPOSE ${SERVER_PORT_SSL}
EXPOSE ${OPENVPN_PORT}
EXPOSE ${OPENVPN_PORT}/udp

ENTRYPOINT ["pritunl"]

CMD ["start"]
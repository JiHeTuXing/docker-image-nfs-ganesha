FROM ubuntu:xenial
MAINTAINER Mitchell Hewes <me@mitcdh.com>

# install prerequisites
RUN DEBIAN_FRONTEND=noninteractive \
 && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 34DC57CA \
 && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3FE869A9 \
 && echo "deb http://ppa.launchpad.net/nfs-ganesha/nfs-ganesha-3.0/ubuntu/  xenial main" > /etc/apt/sources.list.d/nfs-ganesha-3.0.list \
 && echo "deb http://ppa.launchpad.net/nfs-ganesha/libntirpc-3.0/ubuntu/  xenial main" > /etc/apt/sources.list.d/libntirpc-3.0.list \
 && echo "deb http://ppa.launchpad.net/gluster/glusterfs-3.13/ubuntu xenial main" > /etc/apt/sources.list.d/glusterfs-3.13.list \
 && apt-get update \
 && apt-get install -y netbase nfs-common dbus nfs-ganesha nfs-ganesha-vfs glusterfs-common \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
 && mkdir -p /run/rpcbind /export /var/run/dbus \
 && touch /run/rpcbind/rpcbind.xdr /run/rpcbind/portmap.xdr \
 && chmod 755 /run/rpcbind/* \
 && chown messagebus:messagebus /var/run/dbus

# Add startup script
COPY start.sh /
RUN chmod +x /start.sh

# NFS ports and portmapper
EXPOSE 2049 38465-38467 662 111/udp 111

# Start Ganesha NFS daemon by default
CMD ["/start.sh"]


FROM neomediatech/ubuntu-base:22.04

ENV APP_VERSION=1.0.1 \
    SERVICE=dnsbl-ipset

LABEL maintainer="docker-dario@neomediatech.it" \
      org.label-schema.version=$APP_VERSION \
      org.label-schema.vcs-type=Git \
      org.label-schema.vcs-url=https://github.com/Neomediatech/$SERVICE \
      org.label-schema.maintainer=Neomediatech

# ncurses-term : for use with 'clamdtop' command
RUN apt-get update && apt-get -y dist-upgrade && \
    apt-get install -y --no-install-recommends \
      iptables ipset adns-tools rsyslog iproute2 && \
    rm -rf /var/lib/apt/lists*

#ENV CLAM_USER="clamav" \
#    CLAM_UID="5002" \
#    CLAM_ETC="/etc/clamav" \
#    CLAM_DB="/var/lib/clamav" \
#    CLAM_CHECKS="24" \
#    CLAM_DAEMON_FOREGROUND="yes"
#RUN useradd -u ${CLAM_UID} ${CLAM_USER} && \
#    mkdir ${CLAM_DB} && \
#    chown ${CLAM_USER}: ${CLAM_DB} && \
#    groupadd -g 5001 Debian-exim && \
#    useradd -u 5001 -g Debian-exim Debian-exim && \
#    usermod -G Debian-exim clamav

# set clamd.conf and freshclam.conf
#RUN sed -e "s|^\(Example\)|\# \1|" \
#        -e "s|.*\(PidFile\) .*|\1 /run/lock/clamd.pid|" \
#        -e "s|.*\(LocalSocket\) .*|\1 /run/clamav/clamd.ctl|" \
#        -e "s|.*\(TCPSocket\) .*|\1 3310|" \
#        -e "s|.*\(TCPAddr\) .*|\1 0.0.0.0|" \
#        -e "s|.*\(User\) .*|\1 clamav|" \
#        -e "s|^\#\(LogTime\).*|\1 yes|" \
#        -e "s|^\#\(Foreground\).*|\1 yes|" \
#        -e "s|^\#\(DatabaseDirectory\).*|\1 /var/lib/clamav|" \
#        "/usr/local/etc/clamd.conf.sample" > "/usr/local/etc/clamd.conf" && \
#    sed -e "s|^\(Example\)|\# \1|" \
#        -e "s|.*\(PidFile\) .*|\1 /run/lock/freshclam.pid|" \
#        -e "s|.*\(DatabaseOwner\) .*|\1 clamav|" \
#        -e "s|^\#\(NotifyClamd\).*|\1 /etc/clamav/clamd.conf|" \
#        -e "s|^\#\(ScriptedUpdates\).*|\1 no|" \
#        -e "s|^\#\(Checks\).*|\1 24|" \
#        -e "s|^\#\(Foreground\).*|\1 yes|" \
#        -e "s|^\#\(DatabaseDirectory\).*|\1 /var/lib/clamav|" \
#        "/usr/local/etc/freshclam.conf.sample" > "/usr/local/etc/freshclam.conf"

RUN mkdir -p /etc/firehol && \
    touch /var/log/iptables.log && \
    echo ':msg, contains, "AUDIT IN=" /var/log/iptables.log' > /etc/rsyslog.d/00-iptables-audit.conf && \
    echo '& ~' >> /etc/rsyslog.d/00-iptables-audit.conf && \
    # disable imklog as reading /proc/kmsg is forbidden (and we don't need it)
    sed -i 's/module(load="imklog" permitnonkernelfacility="on")/#module(load="imklog" permitnonkernelfacility="on")/' /etc/rsyslog.conf


# volume for virus definitions
#VOLUME ["/var/lib/clamav"]

COPY entrypoint.sh dnsbl-ipset.sh /
COPY dnsbl-ipset.conf /etc/firehol
RUN chmod +x /entrypoint.sh /dnsbl-ipset.sh

#EXPOSE 3310

#HEALTHCHECK --interval=60s --timeout=3s --start-period=120s --retries=10 CMD echo PING | nc 127.0.0.1 3310 || exit 1
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/dnsbl-ipset.sh"]


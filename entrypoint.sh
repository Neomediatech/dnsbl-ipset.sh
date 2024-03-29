#!/tini /bin/bash

IF="$(ip ro ls default|awk '{print $5}')"
[ -z "$IF" ] && IF="eth0"

iptables -D INPUT -i $IF -p tcp -m state --state NEW -j LOG --log-level debug --log-prefix "AUDIT " 2>/dev/null
iptables -A INPUT -i $IF -p tcp -m state --state NEW -j LOG --log-level debug --log-prefix "AUDIT "
# check if exists DOCKER-USER chain
iptables -C DOCKER-USER -j RETURN 2>/dev/null
if [ $? -eq 0 ]; then
  echo "Adding iptables AUDIT rule on DOCKER-USER chain..."
  iptables -D DOCKER-USER -i $IF -p tcp -m state --state NEW -j LOG --log-level debug --log-prefix "AUDIT " 2>/dev/null
  iptables -I DOCKER-USER 1 -i $IF -p tcp -m state --state NEW -j LOG --log-level debug --log-prefix "AUDIT "
fi

[ ! -d /var/log/dnsbl-ipset ] && mkdir -p /var/log/dnsbl-ipset
if [ ! -f /var/log/dnsbl-ipset/dnsbl-for-fail2ban.log ]; then
  touch /var/log/dnsbl-ipset/dnsbl-for-fail2ban.log
  chmod 666 /var/log/dnsbl-ipset/dnsbl-for-fail2ban.log
fi

rsyslogd -n &

exec "$@"


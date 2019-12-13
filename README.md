# dnsbl-ipset.sh
From https://github.com/firehol/firehol/wiki/dnsbl-ipset.sh

## Customized for our own use
- removed rbl.megarbl.net because it doesn't exists anymore
- made daemonizable. It can run from command line in foreground simply running the script without parameters, or you can run it in background running `dnsbl-ipset.sh start`
- we needed to log which port was accessed, then the script was modified to achieve this

### comment and improvements are welcome

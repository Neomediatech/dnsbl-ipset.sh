## Taken from
https://github.com/firehol/firehol/wiki/dnsbl-ipset.sh

## Customized for our own use
- removed rbl.megarbl.net because it doesn't exists anymore
- made daemonizable. It can run from command line in foreground simply running the script without parameters, or you can run it in background running `dnsbl-ipset.sh start`
- we needed to log which port was accessed, then the script was modified to achieve this

## Notes
Sites where one can check dnsbl lists validity/existance:  
https://www.dnsbl.info/dnsbl-list.php  
http://multirbl.valli.org/list/ 

### comment and improvements are welcome

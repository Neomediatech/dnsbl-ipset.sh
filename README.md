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

## Settings
If you want to use the [httpbl list](https://www.projecthoneypot.org) and/or write dnsbl-ipset.sh results in a mysql/mariadb table, compile the [dnsbl-ipset.vars](dnsbl-ipset.vars) file. Database table must be set with (at least) this fields:
```
CREATE TABLE IF NOT EXISTS `blacklist` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` datetime NOT NULL DEFAULT current_timestamp(),
  `from_ip` varchar(15) NOT NULL,
  `alert_service` varchar(255) DEFAULT NULL,
  `alert_server` varchar(255) DEFAULT NULL,
  `comment` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```  

<b>Modify dnsbl-ipset accordingly e put it in /etc/logrotate.d</b>  

### comment and improvements are welcome

Instructions to run assignment4 :

-> type the command on the terminal as "sudo service snmptrapd start"
-> create mysql database "anmassign"
-> open the browser and type localhost
           - enter ip, port, community

-> when ip, port , community are entered a table named "rohith" is created and corresponding values are stored in it.

-> on the terminal type snmptrap as follows:
		
		eg: sudo snmptrap -v 1 -c public 127.0.0.1:50162 .1.3.6.1.4.1.41717.10 10.0.2.2 6 247 '' .1.3.6.1.4.1.41717.10.1 s  "hello1" .1.3.6.1.4.1.41717.10.2 i 3

-> upon sending trap a table named "lab4" is created in the database "anmassign" and corresponding values are stored in it.


Configuration file:  

it must consist of the following lines in snmptrapd.conf:

-> uncomment the "authCommunity log,execute,net public"
-> add "snmpTrapdAddr udp:50162"
-> uncomment and add this -> "traphandle 1.3.6.1.4.1.41717.10.* /usr/bin/perl /var/trap/trapDaemon"

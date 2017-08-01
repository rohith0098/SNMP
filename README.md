# SNMP

SNMP Tools like counter, prober, snmprate and snmptrap are designed

Counter: Perl is used to develop this tool, which calculates the value of the counters for each enterprise OID. the values corresponding to each counter is obtained from counters.conf file.

Prober: Python is used to develop this tool. SNMP agent is probed and rate of change of the counter between successive probes is calculated and displayed on the console.

Snmprate: A wrapper script is designed using python around the prober script to send output to InfluxDB after necessary processing and then configured grafana to generate graphs from InfluxDB. A json file is present which is grafana dashboard.

Snmptrap: A system is created that listens for SNMP traps (configured snmptrapd, the trap listener is on port UDP:50162). the system accepts all trap messages and logs them to a file. TrapDaemon is a SNMP traphandling system that is written in Perl and the web interface requires Apache and MySQL. This system handles traps and receives DANGER and FAIL traps sent from other devices to the local IP and sends traps to the IP address specified by the Web interface via index.php

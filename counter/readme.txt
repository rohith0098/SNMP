Instructions to run assignment 1:

-> Run snmpd (daemon) on the terminal
-> Type snmpget request on the terminal as follows
     eg: snmpget -v2c -c public localhost .1.3.6.1.4.1.4171.40.4


Configuration file:
the following lines must be present in the snmpd.conf file

-> rocommunity  public
-> agentAddress udp:161,udp6:[::1]:161
-> perl do "/home/ats/anm1.pl"; 

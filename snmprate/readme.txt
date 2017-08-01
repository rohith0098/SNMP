Instructions to run assignment3:


-> type the command on the terminal as follows:
		backend <Agent IP:port:community> <sampling interval> <OID1> <OID2> …….. <OIDn> 
		
		where backend     = anm3.py
		Agent IP          = enter the agent IP
		port	          = 161
		community         = public
		sampling interval = enter the interval(eg: 1,2..)
	
	eg: python anm3.py localhost:161:public 3 .1.3.6.1.4.1.4171.40.2 .1.3.6.1.4.1.4171.40.3	
-----------------------------------------------------------------------------------------------------------------------
Influx:

-> create a database named "anm"
-----------------------------------------------------------------------------------------------------------------------
Grafana: 

-> add datasource and create a dashboard to obtain graphs 
   	

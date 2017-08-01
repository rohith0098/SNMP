        use NetSNMP::agent (':all');
        use NetSNMP::ASN ;

  	open(DATA,</home/ats/counters.conf>) or die "Can't open data";
			@lines = <DATA>;
			$a = scalar(@lines);
			

        sub myhandler {
            my ($handler, $registration_info, $request_info, $requests) = @_;
            my $request;

            for($request = $requests; $request; $request = $request->next()) 
               {       
                my $oid = $request->getOID();
                if ($request_info->getMode() == MODE_GET)
                   {
                    if ($oid == new NetSNMP::OID(".1.3.6.1.4.1.4171.40.1")) 
                       {
                        $request->setValue(ASN_COUNTER, time);

                       }
			if ($oid >= new NetSNMP::OID(".1.3.6.1.4.1.4171.40.2")) 
                       {
			$oid_str = "$oid";
			my $f;
			$i = 0;
			while ($i<$a)
			{
				@c = split (/.([^.]+)$/,$oid_str);
				@d = split (/,/,$lines[$i]);
			
        			if (int($d[0])==int($c[1])-1)
				{
	 			($b,$e) = split(/,/,$lines[$i]);
				$f = $e*time;

					break;
				}
    				$i= $i+1;


			}
                        $request->setValue(ASN_COUNTER, $f);

                       }
                   }
                }

                }
            
  

        my $agent = new NetSNMP::agent();
                                # makes the agent read a my_agent_name.conf file
   
        
                                #'AgentX' => 1

        $agent->register("anm1", ".1.3.6.1.4.1.4171.40",
                         \&myhandler);



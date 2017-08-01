#!/usr/bin/perl
use DBI;
use Net::SNMP qw(:ALL);
my $database = "anmassign";
my $driver = "mysql";
my $dsn = "DBI:$driver:database=$database";
my $username = "root";
my $password = "3756";
my $host="localhost";
my $port="3306";
my $driver = "mysql";

my $dsn = "DBI:$driver:$database:$host:$port";


my $filename = "/var/trap/report.txt";
open(my $fh, '>>', $filename) or die "Could not open file '$filename' $!";

my $dbh = DBI->connect($dsn, $username, $password ) or die print $fh $DBI::errstr;

my $sth= $dbh->do("CREATE TABLE IF NOT EXISTS lab4
(fqdn varchar(255) NOT NULL ,
newstatus int NOT NULL ,
newtime int NOT NULL,
oldstatus int NOT NULL DEFAULT '0',
oldtime int NOT NULL DEFAULT '0',
UNIQUE KEY(fqdn)
) ;") or die print $fh $DBI::errstr;

while(<STDIN>)
{
#	print $fh "$_\n";	
	my ($a,$b) = split(/\ /, $_);
	if($a eq "iso.3.6.1.4.1.41717.10.1"){$fqdn=$b;}
	if($a eq "iso.3.6.1.4.1.41717.10.2"){$status=$b;}	
	
}
$fqdn=~s/"//g;
chomp($fqdn);
print $fh "fqdn:$fqdn";
print $fh "status:$status";

my $sthinsert = $dbh->prepare("INSERT IGNORE INTO lab4 (fqdn) values ('$fqdn')");
				$sthinsert->execute() or die $DBI::errstr;
				$sthinsert->finish();
				$time=time;
				my $sthupdate = $dbh->prepare("UPDATE lab4 SET oldstatus=newstatus,oldtime=newtime,newtime='$time',newstatus='$status' WHERE fqdn = '$fqdn' ");
						$sthupdate->execute() or die $DBI::errstr;
					$sthupdate->finish();

my $sthselect = $dbh->prepare("SELECT ip,port,community FROM rohith");
$sthselect->execute() or die print $fh $DBI::errstr;
 @row = $sthselect->fetchrow();
 ($ip,$port,$community)=@row;
# print $fh "@row";
my ($session, $error) = Net::SNMP->session(
   -hostname  =>  $ip,
   -community =>  $community,
   -port      => $port,      
);

if (!defined($session)) {
   printf("ERROR: %s.\n", $error);
   exit 1;
}
@trapoid = qw();
if ($status==3){
my $sth = $dbh->prepare("SELECT fqdn,newtime,oldstatus,oldtime FROM lab4 WHERE fqdn='$fqdn'");
                        $sth->execute() or die $DBI::errstr;
 @row = $sth->fetchrow_array();

 ($fqdn,$newtime,$oldstatus,$oldtime)=@row; 

#my @oid1=('1.3.6.1.4.1.41717.20.1','1.3.6.1.4.1.41717.20.2','1.3.6.1.4.1.41717.20.3','1.3.6.1.4.1.41717.20.4');
push (@trapoid, '1.3.6.1.4.1.41717.20.1',OCTET_STRING,$fqdn,'1.3.6.1.4.1.41717.20.2',UNSIGNED32,$newtime,'1.3.6.1.4.1.41717.20.3',INTEGER,$oldstatus,'1.3.6.1.4.1.41717.20.4',UNSIGNED32,$oldtime);
}

if ($status==2)
{
				print $fh "in if loop 2\n";
					my $sth = $dbh->prepare("SELECT fqdn,newtime,oldstatus,oldtime FROM lab4 WHERE newstatus=2");
				$sth->execute() or die $DBI::errstr;
				if($sth->rows == 1)
				{
							print "nothing";
				}
				if($sth->rows >1 )
				{
							
							
							my $i=1;
							@trapoid=();
							while (my @row = $sth->fetchrow_array()) 
							{
								push @trapoid,(".1.3.6.1.4.1.41717.30.".$i++, OCTET_STRING, "$row[0]",
					   ".1.3.6.1.4.1.41717.30.".$i++, UNSIGNED32, "$row[1]",
					   ".1.3.6.1.4.1.41717.30.".$i++, INTEGER, "$row[2]",
					   ".1.3.6.1.4.1.41717.30.".$i++, UNSIGNED32, "$row[3]");
							}
				}
				$sth->finish();
}
#print $fh "@trapoid";
if (@trapoid){
my $result = $session->trap(
   -enterprise   => '1.3.6.1.4.1',
   -agentaddr    => '127.0.0.1',
   -generictrap  => 6,
   -varbindlist  => \@trapoid,
);

if (!defined($result)) {
#print $fh "trap not sent\n";
   printf $fh ("ERROR: %s.\n", $session->error());
} else {
#print $fh "trap sent";
#   printf("Trap sent.\n");
}

}
else{#print $fh "no var to send trap\n";
}
#$f=localtime();
#print $fh "Trap recieved at $f";

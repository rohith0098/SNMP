<html>
<head><style>h1 {text-align:center;}</style>
<style>

table, th, td {
    border: 1px solid black;
    border-collapse: collapse;
}
th, td {
    padding: 15px;
}
</style>
</head>
<h1>ANM lab4</h1>

<form action="index.php" method="get">
<table>
<tr><td>ip:</td>        <td><input type="text" name="ip"></td></tr>
<tr><td>port:</td>        <td>      <input type="text" name="port"></tr>
<tr><td>community:</td>        <td> <input type="text" name="community"></tr>
</table>
<input type="submit" value="submit">
</form>
<?php $x= $_GET["ip"]; $y=$_GET["port"]; $z=$_GET["community"]; 

//echo $x;?>
<?php
$hostname = "localhost";
$username = "root";
$password = "3756";
$database = "anmassign";
$port="3306";
//echo $host;
#echo $x;
$dbconnection = mysqli_connect($hostname,$username, $password,$database,$port);

// Check connection
if (!$dbconnection) {
   die("Connection failed: " . mysqli_connect_error());
}
//echo "Connected successfully<br>";
mysqli_select_db($dbconnection,"$database");

$tbcreation = "CREATE TABLE IF NOT EXISTS rohith ( 
                id INT(11) NOT NULL AUTO_INCREMENT,
                ip VARCHAR(255) NOT NULL,
                port VARCHAR(255) NOT NULL,
                community VARCHAR(255) NOT NULL,
                PRIMARY KEY (id) 
                )"; 
$query = mysqli_query($dbconnection, $tbcreation); 
if ($query === TRUE) {
	#echo "<h3> table created OK :) </h3>"; 
} else {
	#echo "<h3> table NOT created :( </h3>"; 
}

if(!empty($_GET['ip'])&&!empty($_GET['port'])&&!empty($_GET['community']))
{
$sqls = "truncate rohith";
$query = mysqli_query($dbconnection,$sqls); 
$sqls = "INSERT INTO rohith (id,ip,port,community)
VALUES (1,\"$x\", \"$y\", \"$z\")";
#echo $sqls;

if (mysqli_query($dbconnection, $sqls)) {
    #echo "New record created successfully";
} else {
    #echo "Error: " . $sqls . "<br>" . mysqli_error($dbconnection);
}

}
$result = mysqli_query($dbconnection,"SELECT fqdn,newstatus FROM lab4");


?>
<table align="center">
<tr>
<th>Reported Device</th>
<th>Current Status</th>
</tr>
<?php 
while($row = mysqli_fetch_array($result)) {
?>
<tr>
<td><?php echo $row['fqdn'];?></td>
<td><?php echo $row['newstatus'];?></td>
</tr>
<?php }?>
</table>

</html>

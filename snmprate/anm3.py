from __future__ import print_function
from influxdb import InfluxDBClient
from influxdb.client import InfluxDBClientError
import datetime
import random
import time
import argparse
import subprocess
import re
import sys
import os
from subprocess import Popen, PIPE

USER = 'root'
PASSWORD = 'root'
DBNAME = 'anm'
host='localhost'
port='8086'
metric = 'rate'





x2 = str(sys.argv[1])
x3 = str(sys.argv[2])
x4 =(sys.argv[3:])

mylist= ['python','/home/ats/anm2.py', x2,x3]

for z in x4:
	mylist.append(z)

proc = subprocess.Popen(mylist,stdout=subprocess.PIPE)


for line in iter(proc.stdout.readline,''):
	
      	line.rstrip('\n')
	a = line.split('=')

	pointValues = {
		"measurement": metric,
			'fields':  {
			'rate': a[1].rstrip('\n'),
			},
			'tags': {
			"counter": a[0],
				},
			}
	dot = [pointValues]
	retention_policy="default"
	client = InfluxDBClient(host, port, USER, PASSWORD, DBNAME)
	print ("inserting data")
	client.create_retention_policy(retention_policy, '1h', 2, default=True)
	client.write_points(dot,retention_policy=retention_policy)
	time.sleep(0.2)

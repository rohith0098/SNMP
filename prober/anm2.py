import subprocess
import sys
import time
import numpy as np
x1 = 'snmpget -v2c -c'

x2 = sys.argv[1]
y1 = x2.split(':')
x2 = y1[0] + ':' + y1[1]
x5='1.3.6.1.2.1.1.3.0'
x3 = sys.argv[3:]
s = " "
s1 = s.join(x3)
x4 = (x1,y1[2],x2,x5,s1)
cmd= s.join(x4)


start_time1 = time.time()

a = len(sys.argv)-3
proc = subprocess.check_output(cmd, shell = True)
str = proc.split('\n')
del str[-1]
old = []
for y in str:

		str1 = y.split('=')
                if ('iso.3.6.1.2.1.1.3.0' in str1[0]):
			stt1 = str1[1].split('(')
			stt2 = stt1[1].split(')')
			oldtime = stt2[0]
		else:
			str2 = str1[1].split(': ')
			old.append(int(str2[1])) 


new = []
dif = []

end_time1 = time.time()
now1= int(start_time1-end_time1)
b1 = int(sys.argv[2])
 
time.sleep(b1-int(now1))


while (True):
	start_time = time.time()
	oids = []
	proc = subprocess.check_output(cmd, shell = True)
	str = proc.split('\n')
	del str[-1]
	x =[]
	for y in str:
		str1 = y.split('=')
                if ('iso.3.6.1.2.1.1.3.0' in str1[0]):
			st1 = str1[1].split('(')
			st2 = st1[1].split(')')
			newtime = st2[0]
		else:
			str2 = str1[1].split(': ')
			x.append(int(str2[1])) 

	if int(newtime)<int(oldtime):
		
		
		oldtime = newtime
		old = x
		print "system reboot"
		time.sleep(sys.argv[2])
		continue
		
		
		
	new = x
	dif = list(np.array(new)-np.array(old))
	old = new

	diftime = (int(newtime)- int(oldtime))/100
	oldtime = newtime

	
	frate = []
	rate = []
	rate[:] = [z / diftime for z in dif]
	for r in rate: 
		if r>0 :
			frate.append(r)
		if r<0 :
			r = r+ (2**32/diftime)
			frate.append(r)
	


	for y in str:
		str1 = y.split('=')
		if (not ('iso.3.6.1.2.1.1.3.0' in str1[0])):
			oids.append(str1[0])
		

	final = ['%s = %s'%x for x in zip(oids,frate)]
	final1= ['rate,counter=%s rate=%s'%(i,j) for i,j in zip(oids,frate)]
	for x in final:
		print x
		sys.stdout.flush()
	end_time = time.time()
	now= end_time-start_time
	b = int(sys.argv[2]) 
	time.sleep(b-int(now))



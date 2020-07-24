import requests
from bs4 import BeautifulSoup
from random import randint
from time import sleep 
import sys 

import argparse
parser = argparse.ArgumentParser(description='check updates from all focks')
parser.add_argument('user',  type=str, default='williamleif', help='user in the github.com')
parser.add_argument('repo',  type=str, default='GraphSAGE',help='repo of the specified user in the github.com')
parser.add_argument('--host',  type=str, default='github.com',help='default is github.com')

args=parser.parse_args()

#print(args.user)

#check forks
burl="https://%s/%s/%s/network/members" % (args.host, args.user, args.repo)
print("# " + burl)

htm=requests.get(burl).text
soup=BeautifulSoup(htm, 'html.parser')
counter=0
for fork in soup.find_all('a', string=args.repo):
    #print(fork.get('href'))
    href=fork.get('href')
    furl="https://%s/%s" % (args.host, href)
    fhtm=requests.get(furl).text
    fsoup=BeautifulSoup(fhtm, 'html.parser')
    adate=fsoup.find('relative-time')
    if adate:
        fdate=adate.text     
    print("%s : %s" % (href, fdate))    
    randsec=randint(3,30)
    counter+=1
    sys.stderr.write("%d, wait %d seconds\n" % (counter, randsec))
    sleep(randsec)


import requests
from bs4 import BeautifulSoup
from random import randint
from time import sleep
import logging
import os

import argparse
parser = argparse.ArgumentParser(description='check updates from all focks, such as williamleif/GraphSAGE')
parser.add_argument('user',  type=str, default='williamleif', help='user in the github.com')
parser.add_argument('repo',  type=str, default='GraphSAGE',help='repo of the specified user in the github.com')
parser.add_argument('--host',  type=str, default='github.com',help='default is github.com')
parser.add_argument('--wait',  type=int, default=90,help='default is 30 seconds')
parser.add_argument('--log',dest='loglevel',  default="INFO", help='default is INFO')
parser.add_argument('--MaxRetry',  default=5, help='max retrying to request the url is 5')
parser.add_argument('--token',   help='personal TOKEN for oauth')

args=parser.parse_args()
#print(args.user)

nlevel4log=getattr(logging, args.loglevel.upper(), None)
if not isinstance(nlevel4log, int):
    raise ValueError('Invalid log level: %s' % args.loglevel)
logging.basicConfig(level=nlevel4log)

#check forks
burl="https://%s/%s/%s/network/members" % (args.host, args.user, args.repo)
print("# " + burl)

#make github headers for oauth
headers={'Authorization':'Bearer %s' % (args.token)}


htm=requests.get(burl, headers=headers).text
soup=BeautifulSoup(htm, 'html.parser')
counter=0
counter4failure=0
allForks=soup.find_all('a', string=args.repo) #filtered by the keyword of focked repository
randsec=randint(3,args.wait)
for fork in allForks:
    #print(fork.get('href'))
    href=fork.get('href')
    furl="https://%s/%s" % (args.host, href)
    logging.debug(furl)

    succ=False
    counter4failure=1
    while not succ and counter4failure<=args.MaxRetry:
        fhtm=requests.get(furl, headers=headers).text
        fsoup=BeautifulSoup(fhtm, 'html.parser')
        adate=fsoup.find('relative-time')
        fdate='none'
        if adate: #not none
            #fdate=adate.text
            fdate=adate.get('datetime')
            succ=True
        else: #is none
            logging.warning("failed to extract datetime!\n")
            logging.debug(fhtm)
            counter4failure+=1

            #check my current rate limit to github.com
            #https://docs.github.com/en/rest/reference/rate-limit
            os.system('curl -o /tmp/githubLimit.json -H "Accept: application/vnd.github.v3+json" https://api.github.com/rate_limit ')
            os.system('jq ".rate" /tmp/githubLimit.json 1>&2')


            #retry with one or 2 more minutes waiting
            frandsec=randint(3,10)*randsec
            logging.info("%d : %s, wait %d seconds more\n" % (counter,href , frandsec))
            sleep(frandsec)
    print("%s : %s" % (href, fdate))
    randsec=randint(60,args.wait)
    counter+=1
    logging.info("%d, wait %d seconds\n" % (counter, randsec))
    sleep(randsec)


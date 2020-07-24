# CheckGithubFocks
## Motivation
Check the latest update date of all the forks of a specified github repository.<br>
I want to know if anyone has translated GraphSAGE from tensorflow 1 with python2.7 to tensorflow 2.1 with python 3.7.

## Example
Checking if anyone has made some changes on his own forks of Hamilton's GraphSAGE:   

> python chkForksUpdate.py williamleif GraphSAGE

This will output: 
> #https://github.com/williamleif/GraphSAGE/network/members  
> /williamleif/GraphSAGE : Sep 19, 2018  
> /williamleif/GraphSAGE : Sep 19, 2018  
> /0xf3cd/GraphSAGE : Sep 19, 2018  
> /17385/GraphSAGE : Sep 19, 2018  
> /597477803/GraphSAGE : Sep 19, 2018  
> /978007000/GraphSAGE : Sep 19, 2018  
> ...

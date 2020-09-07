#!/bin/bash
# Xiaowei Song
# 20200906
# Copyright (c) 2020-2030

cat >chkSdat.py <<eoc
import time
from selenium import webdriver
from selenium.webdriver.chrome.service import Service

srv=Service('${CHROMEDRIVER:-$HOME/d/Debug/ChromeDriver/chromedriver.exe}')
srv.start()
drv=webdriver.Remote(srv.service_url)
drv.get('${URL:-https://sdat.dat.maryland.gov/RealProperty/Pages/default.aspx}')
time.sleep(5)
driver.quit()
eoc

#activate web spider env
source $HOME/anaconda4cygwin.bash_profile
cyg-activate webSpider

#add path
export PATH=$(dirname ${CHROMEDRIVER:-$HOME/d/Debug/ChromeDriver/chromedriver.exe}):$PATH

python chkSdat.py $@


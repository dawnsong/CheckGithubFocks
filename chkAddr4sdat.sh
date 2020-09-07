#!/bin/bash
# Xiaowei Song
# 20200906
# Copyright (c) 2020-2030

cat >chkSdat.py <<eoc
import time,io
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import Select
from selenium.webdriver.support.ui import WebDriverWait 
from selenium.webdriver.support import expected_conditions as EC 
from selenium.webdriver.common.by import By

opt=Options()
opt.headless=False; #True;
#opt.setExperimentalOption("excludeSwitches", Arrays.asList("diable-popup-blocking"))

caps=webdriver.DesiredCapabilities.CHROME.copy()
caps['acceptInsecureCerts']=True

srv=Service('$(cygpath -w ${CHROMEDRIVER:-$HOME/d/Debug/ChromeDriver/chromedriver.exe})')
srv.start()

drv=webdriver.Remote(srv.service_url, options=opt)
drv.get('${URL:-https://sdat.dat.maryland.gov/RealProperty/Pages/default.aspx}')
drv.implicitly_wait(10)
time.sleep(5)

selectCounty=Select(drv.find_element_by_id('MainContent_MainContent_cphMainContentArea_ucSearchType_wzrdRealPropertySearch_ucSearchType_ddlCounty') )
selectCounty.select_by_visible_text('${COUNTY:-HOWARD COUNTY}')

selectMethod=Select( drv.find_element_by_id('MainContent_MainContent_cphMainContentArea_ucSearchType_wzrdRealPropertySearch_ucSearchType_ddlSearchType') )
selectMethod.select_by_visible_text('${METHOD:-STREET ADDRESS}')

#btnContinue=drv.find_element_by_id('MainContent_MainContent_cphMainContentArea_ucSearchType_wzrdRealPropertySearch_StartNavigationTemplateContainerID_btnContinue')

time.sleep(5) #this will solve stale element for button submit
#this explicit wait should work better, but need to be figured out, 20200907
#btnContinue=WebDriverWait(drv, 10).until(EC.element_to_be_clickable( (By.ID, "MainContent_MainContent_cphMainContentArea_ucSearchType_wzrdRealPropertySearch_StartNavigationTemplateContainerID_btnContinue") ) )
#btnContinue=drv.find_element_by_xpath("//input[@type='submit']")
btnContinue=drv.find_element_by_class_name("btnNext")
btnContinue.click()

#in the street number and street name page
time.sleep(5)
txtStreetNum=drv.find_element_by_id("MainContent_MainContent_cphMainContentArea_ucSearchType_wzrdRealPropertySearch_ucEnterData_txtStreenNumber")
txtStreetNum.send_keys('${STREET_NUM:-4273}')

txtStreetName=drv.find_element_by_id("MainContent_MainContent_cphMainContentArea_ucSearchType_wzrdRealPropertySearch_ucEnterData_txtStreetName")
txtStreetName.send_keys('${STREET_NAME:-Buckskin Wood}')

time.sleep(5) #this will solve stale element for button submit
##btnContinue=drv.find_element(By.XPATH, "//input[text()='Next']")
btnContinue=drv.find_element_by_class_name("btnNext")
btnContinue.click()

#save to html
time.sleep(5)
with io.open('${HTML:-test.html}', 'w', encoding='utf-8') as f:
    f.write(drv.page_source)
    f.close()

time.sleep(5)
drv.quit()
eoc

#activate web spider env
shopt -s expand_aliases #allow expanding alias for non-interactive shell
source $HOME/anaconda4cygwin.bash_profile
cyg-activate webSpider

#add path
export PATH=$(dirname ${CHROMEDRIVER:-$HOME/d/Debug/ChromeDriver/chromedriver.exe}):$PATH

python chkSdat.py $@


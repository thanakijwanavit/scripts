#!/usr/bin/env python3

from selenium import webdriver
import time
from selenium.webdriver.common.by import By

browser = webdriver.Firefox()
browser.get('https://www.litecoinpool.org/api?format=html&api_key=d24a788cb48bb746f2e8dde0aee5a997')
time.sleep(10)

element =browser.find_element(By.XPATH,'//*[@id="thanakijwanavit.1"]')
print(element.text)




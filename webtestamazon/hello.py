#!/usr/bin/env python3
from flask import Flask
import turnonlight, requests

app = Flask(__name__)
rootpage = '''
<form action="/action_page.php">
  First name:<br>
  <input type="text" name="firstname" value="Mickey"><br>
  Last name:<br>
  <input type="text" name="lastname" value="Mouse"><br><br>
  <input type="submit" value="Submit">
</form>
'''





@app.route("/")
def hello():
	return rootpage

@app.route("/light")
def light_status():
	return 'light is on'

@app.route("/lightoff")
def lightoff():
	turnonlight.off()
	return 'light is off'

@app.route("/lighton")
def light():
	turnonlight.on()
	return 'light is on'


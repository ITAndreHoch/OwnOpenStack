
# Own Open Stack - relay on Python, FLASK, TerraForm , Bash

**Project Goal:**

The goal of the project is to create a website with the help of which users can create virtual machines on datacenter in an easy and accessible way on DataCenter (in that case - it will be VMWARE).

As forendend will be used:
 - Flask
 - Python
 - HTML

As backend will be used:
 - Terraform
 - Bash
 
 
 Additional detailed info:
 
 https://github.com/ITAndreHoch/Terraform-stage-vmware
 https://github.com/ITAndreHoch/Docs-Flask
 
 
 
 #

**Final appearance and operation:**

1. Step one: Page - Authorisation (Only SSL)

<img src="images/flask1.png " alt="drawing" width="400"/>

2. Step two: Page - Input data

<img src="images/flask2.png " alt="drawing" width="400"/>

3. The site should contain a list of available items to choose from - for example, all possible networks

<img src="images/flask4.png " alt="drawing" width="400"/>

4. Step Three: On the screen shoud appear log from (terraform) deaployment new machine:

Example:

```
[..]
  wait_for_guest_net_routable:                          "" => "true"
  wait_for_guest_net_timeout:                           "" => "0"\u001B[0m
\u001B[0m\u001B[1mvsphere_virtual_machine.vm: Still creating... (10s elapsed)\u001B[0m\u001B[0m
\u001B[0m\u001B[1mvsphere_virtual_machine.vm: Still creating... (20s elapsed)\u001B[0m\u001B[0m
\u001B[0m\u001B[1mvsphere_virtual_machine.vm: Still creating... (30s elapsed)\u001B[0m\u001B[0m
\u001B[0m\u001B[1mvsphere_virtual_machine.vm: Still creating... (40s elapsed)\u001B[0m\u001B[0m
\u001B[0m\u001B[1mvsphere_virtual_machine.vm: Creation complete after 46s (ID: 4215f55f-c0a8-1d80-9eb0-575569d83229)\u001B[0m\u001B[0m
\u001B[0m\u001B[1m\u001B[32m
Apply complete! Resources: 1 added, 0 changed, 0 destroyed
```

#

**Flask script:**

```

from flask import Flask
from flask import Flask, flash, redirect, render_template, request, session, abort
import subprocess
from subprocess import Popen, PIPE
from subprocess import check_output
import os



app = Flask(__name__)


@app.route('/')
def home():
  if not session.get('logged_in'):
     return render_template('login.html')
  else:
     return render_template('core.html')



@app.route('/login', methods=['POST'])
def do_admin_login():
   if request.form['password'] == 'password' and request.form['username'] == 'admin':
      session['logged_in'] = True
   else:
      flash('wrong password!')
   return home()


@app.route('/custom', methods=['POST', 'GET'])
def custom_vm():
    varip = request.form['ipaddress']
    varmask = request.form['mask']
    vargateway = request.form['gateway']
    varcpu = request.form['cpu']
    varmem = request.form['mem']
    varhost = request.form['hostname']
    varcluster = request.form['cluster']
    varnet = request.form['network']
    return '<pre>'+get_shell_script_output_using_check_output()+'</pre>'


def get_shell_script_output_using_communicate():
    varip = request.form['ipaddress']
    session = subprocess.Popen(['/terraform/flask_terra.sh', varip, varmask, vargateway, varcpu, varmem, varhost, varcluster, varnet], stdout=PIPE, stderr=PIPE)
    stdout, stderr = session.communicate()
    if stderr:
        raise Exception("Error "+str(stderr))
    return stdout.decode('utf-8')

def get_shell_script_output_using_check_output():
    varip = request.form['ipaddress']
    varmask = request.form['mask']
    vargateway = request.form['gateway']
    varcpu = request.form['cpu']
    varmem = request.form['mem']
    varhost = request.form['hostname']
    varcluster = request.form['cluster']
    varnet = request.form['network']
    stdout = check_output(['/terraform/flask_terra.sh', varip, varmask, vargateway, varcpu, varmem, varhost, varcluster, varnet]).decode('utf-8')
    return stdout
   
   
 
if __name__ == "__main__":
   app.secret_key = os.urandom(12)
app.run(ssl_context='adhoc',debug=True,host='0.0.0.0', port=4000)

```



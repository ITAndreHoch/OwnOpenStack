
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

**login.html:**

```
<html>
<head>
   

</head>
<body>
    <style>
        body {background-color: #ffffff;
             
             }
   
        .first {
            width: 100%;
            height: 30px;
            background-color: #ffffff;
            padding:2px;
            margin-left: -10px;
            margin-right: -2px;
            display: flex;
            align-items: center;
            justify-content: center;
           
          }

        .second { 
            width: 100%;
            height: 100%;
            background-color: #00ace6;
            flex-grow: 1000;
            padding:5px;
            margin-left: -10px;
            margin-right: -2px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        p.a {
          font-family: "Times New Roman", Times, serif;
        }

        p.b {
          font-family: Arial, Helvetica, sans-serif;
        } 
        
        p.c {
          font-family: Verdana, Geneva, Tahoma, sans-serif;
          color: #00ace6;
        }
        

        .login-screen {
            background-color: #FFF;
            padding: 20px;
            border-radius: 5px
        }
 
        .control-group {
            margin-bottom: 10px;
        }

        .app-title {
            text-align: center;
            font-family: Arial, Helvetica, sans-serif;
            color: #777;
         }

         input {
             text-align: center;
             background-color: #ECF0F1;
             border: 2px solid transparent;
             border-radius: 3px;
             font-size: 12px;
             font-weight: 150;
             padding: 5px 0;
             width: 200px;
             transition: border .5s;
         }
 
         .loginb {
             text-align: center;
             color: white;
             background-color: #808080;
             border: 2px solid transparent;
             border-radius: 3px;
             font-size: 12px;
             font-weight: 150;
    
             padding: 5px 0;
             width: 100px;
             transition: border .5s;
         }

input:focus {
border: 2px solid #3498DB;
box-shadow: none;
}


    </style>
<div class="first">
 
    <p class="c" >DN AUTOMATIC DEPLOYMENT IaaC </p>
   
</div>

<div class="second">
 <div class="login-screen">
    <div class="app-title">
        <img src="/static/wmcloud.png" width="70px" height="60px" alt="wm-cloud" > 
        <BR>
          <div class="app-title">
              IaaC VMware DN Login
          </div>
    </div>
  <BR>
    {% block body %}
    {% if session['logged_in'] %}
       You're logged in already!
    {% else %}
       <form action="/login" method="POST">
         <input type="username" name="username" placeholder="Username">
         <label class="login-field-icon fui-user" for="login-name"></label>
         <br>
         <br>
         <input type="password" name="password" placeholder="Password">
         <input type="submit" class="loginb" value="Log in" >
        
       </form>
     {% endif %}
   {% endblock %}
    
  </div>
   
</div>


</body>
</html>
```

**core.html**

```
<html>
<head>
</head>
<body>
    <style>
        body {background-color: #ffffff;
             
             }
   
        .first {
            width: 100%;
            height: 30px;
            background-color: #ffffff;
            padding:2px;
            margin-left: -10px;
            margin-right: -2px;
            display: flex;
            align-items: center;
            justify-content: center;
           
          }


        .second { 
            width: 100%;
            height: 100%;
            background-color: #00ace6;
            flex-grow: 1000;
            padding:5px;
            margin-left: -10px;
            margin-right: -2px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        p.a {
          font-family: "Times New Roman", Times, serif;
        }

        p.b {
          font-family: Arial, Helvetica, sans-serif;
        } 
        
        p.c {
          font-family: Verdana, Geneva, Tahoma, sans-serif;
          color: #00ace6;
        }

        .login-screen {
            background-color: #FFF;
            padding: 20px;
            border-radius: 5px
        }

        .app-title {
            text-align: center;
            font-family: Arial, Helvetica, sans-serif;
            color: #777;
         }

         .font-screen {
            text-align: left;
            font-size: 12px;
            font-family: Arial, Helvetica, sans-serif;
            color: #777;
         }

         .font-screen2 {
            text-align: center;
            font-size: 12px;
            font-family: Arial, Helvetica, sans-serif;
            color:red;
         }

         input {
             text-align: center;
             background-color: #ECF0F1;
             border: 2px solid transparent;
             border-radius: 3px;
             font-size: 12px;
             font-weight: 150;
             padding: 5px 0;
             width: 200px;
             transition: border .5s;
         }

         .butt {
             text-align: center;
             background-color: #ECF0F1;
             border: 2px solid transparent;
             border-radius: 3px;
             font-size: 12px;
             font-weight: 150;
             padding: 5px 0;
             width: 200px;
             transition: border .5s;
         }

         input:focus {
           border: 2px solid #3498DB;
           box-shadow: none;
        }

        .loginb {
             text-align: center;
             color: white;
             background-color: #808080;
             border: 2px solid transparent;
             border-radius: 3px;
             font-size: 12px;
             font-weight: 150;
             padding: 5px 0;
             width: 100px;
             transition: border .5s;
         }

         .loginb2 {
             text-align: center;
             color: white;
             background-color: #800000;
             border: 2px solid transparent;
             border-radius: 3px;
             font-size: 12px;
             font-weight: 150;
             padding: 5px 0;
             width: 100px;
             transition: border .5s;
         }

    </style>
<div class="first">
 
    <p class="c" >DN AUTOMATIC DEPLOYMENT IaaC </p>
   
</div>

<div class="second">
  <div class="login-screen">
    <div class="app-title">
        Custom VM
     <form action="/custom" method="POST">
        <div class="font-screen">
            <p>Input Address IP:</p>
        </div>
        <input type="IP" name="ipaddress" placeholder="IP Address">
        <button class=butt type="reset">Reset</button>




        <div class="font-screen">
            <p>Input MASK Prefix:</p>
        </div>
        <input type="mask" name="mask" placeholder="Mask Prefix">
        <button class=butt type="reset">Reset</button>



        <div class="font-screen">
            <p>Input Gateway:</p>
        </div>
        <input type="gateway" name="gateway" placeholder="Gateway">
        <button class=butt type="reset">Reset</button>



        <div class="font-screen">
            <p>Input CPU:</p>
        </div>
        <input name="cpu" list="cpu">
        <datalist id="cpu">
           <option value="1">1</option>
           <option value="2">2</option>
           <option value="3">3</option>
           <option value="4">4</option>
        </datalist> 
        <button class=butt type="reset">Reset</button>



        <div class="font-screen">
            <p>Input Memory:</p>
        </div>
        <input name="mem" list="mem">
        <datalist id="mem">
           <option value="1024">1024</option>
           <option value="2048">2048</option>
           <option value="4096">4096</option>
           <option value="8192">8192</option>
        </datalist> 
        <button class=butt type="reset">Reset</button>



        <div class="font-screen">
                <p>Input hostname:</p>
        </div>
            <input type="hostname" name="hostname" placeholder="Hostname">
            <button class=butt type="reset">Reset</button>

        <div class="font-screen">
                    <p>Choose cluster:</p>
        </div>
        <input name="cluster" list="cluster">
        <datalist id="cluster">
            <option value="TM-Cluster">TM-Cluster</option>
        </datalist> 
        <button class=butt type="reset">Reset</button>
          
        <div class="font-screen">
                <p>Choose Network:</p>
        </div>
            <input name="network" list="networks">
            <datalist id="networks">
                <option value="Network1">Network1</option>
                [..]
            </datalist> 
            <button class=butt type="reset">Reset</button>
        
        
        
                               
        <BR><BR><BR>

        <div class="font-screen2">
              If you click submit new VM will be deploy <br><BR>
          </div>
        <input type="submit" class="loginb2" value="submit">
     </form>
     </div>
    </div>
</div>



</body>
</html>
```



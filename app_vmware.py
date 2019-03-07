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


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


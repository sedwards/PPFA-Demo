Overview:
  The goal of this project is just to make it really easy to deploy an example application in a repeatable fashion
  and to show the Steven sort of knows what he is doing.

  In this example we are going to deploy three instances
    - haproxy (front-end)
    - nginx (middlware proxy)
    - django (backend application)
   As well as an S3 bucket to serve a static image which haproxy will support routing to

Quickstart:
  1. Modify variables.tf and put in your aws_access_key and aws_secret_key
  2. Run deploy.sh

Important TODO
  - haproxy
  - EIP

Some NOTES and TODO:
 - Security is not that great. 
     We should limit the inbound SSH to a jump host or your address

 - As above, I only used one security group for both backend services during POC. 
     They should be split

 - There is no SSL configured on this example. 
     Using something like LetsEncrypt would be better. An exmple of this was added to nginx.conf but not enabled due to time

 - I am just throwing the files in to the containers on docker build, it would be better to mount the volumes

 - I couldn't remember the terraform syntax for passing in variabes
     Step 1 above should really be removed/replaced in a future iteration

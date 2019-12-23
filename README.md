### Overview:
  The goal of this project is just to make it really easy to deploy an example application in a repeatable fashion
  and to show the Steven sort of knows what he is doing.

  In this example we are going to deploy three instances
    - haproxy (front-end)
    - nginx (middlware proxy)
    - django (backend application)
   As well as an S3 bucket to serve a static image which haproxy will support routing to

### Quickstart:
  1. Modify variables.tf and put in your aws_access_key and aws_secret_key
  2. Run deploy.sh

### Help and Commands:
```
usage: deploy <command>
The most commonly used commands are:
 [requirements]
   install-tf            - Show terraform state
   gen-keys              - Should be clear enough
 [deploy envrionment]
   init                  - init terraform
   plan                  - execute terraform plan
 [housekeeping]
   cleanup               - terraform destory and remove ssh keys
```

### Structure of Stuff and Things
```
[sedwards@homeless PPFA]$ tree
.
├── deploy.sh
├── docker
│   ├── django
│   │   ├── docker-compose.yml
│   │   ├── Dockerfile
│   │   ├── requirements.txt
│   │   └── tinyapp.py
│   ├── install.sh
│   └── nginx
│       ├── docker-compose.yml
│       ├── docker-entrypoint.sh
│       ├── Dockerfile
│       └── nginx.conf
├── documentation
│   ├── Haproxy-to-nginx-django.png
│   ├── s3-bucket.png
│   ├── s3-upload.png
│   └── static-content-to-s3-bucket.png
├── haproxy
│   ├── haproxy.cfg
│   └── install.sh
├── instances.tf
├── main.tf
├── README.md
├── s3.tf
├── sec_groups.tf
├── ssh
│   ├── terraform
│   ├── terraform.pem
│   └── terraform.pub
├── static-content
│   └── hello.png
├── terraform.tfstate
├── terraform.tfstate.backup
└── variables.tf

7 directories, 28 files

```

### FIXME
  - Read more of the recent Terraform documentation and fix passing in the the aws keys as variables... 
  - Pass the s3 bucket name in as a variable as well, so we can have multiple copies of this stack running
       ...there can be only one my-ppfa-tf-test-bucket.s3-us-west-1.amazonaws.com
  - Check the haproxy and s3 docs to figure out how to render the image rather than downloading it
  - Also using variables in other places, such as for the internal IP addresses would be good
  - A lot of stuff is hard-coded, the point here is to be able to replicate it over and over

### Some more misc NOTES and TODO:
 - Security is not that great. 
     We should limit the inbound SSH to a jump host or your address

 - As above, I only used one security group for both backend services during POC. 
     They should be split

 - There is no SSL configured on this example. 
     Using something like LetsEncrypt would be better. An exmple of this was added to nginx.conf but not enabled due to time

 - I am just throwing the files in to the containers on docker build, it would be better to mount the volumes

 - Logically, it would be better to provision django, then nginx, then haproxy to follow the flow from backend to front-end
     but I'm committed now. Should re-order this later and switch the IPs around

 - My Terraform-fu is a little rusty, all the hard-coded stuff can be removed/replaced in a future iteration 

#### Examples
##### Accessing Stack with request routed Haproxy->Nginx->Django
  
![Accessing Stack Haproxy->Nginx->Django](https://github.com/sedwards/PPFA-Demo/blob/master/documentation/Haproxy-to-nginx-django.png)

##### Serving Static Content from S3 Bucket through haproxy

![Static File Routed Through haproxy](https://github.com/sedwards/PPFA-Demo/blob/master/documentation/static-content-to-s3-bucket.png)

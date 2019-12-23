#!/bin/bash
nginx 2> /var/log/nginx/nginx.out

tail -f /var/log/nginx/nginx.out /var/log/nginx/access.log /var/log/nginx/error.log


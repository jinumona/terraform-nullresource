# vim apache-install.sh

#!/bin/bash

yum install httpd php git -y
rm -rf /var/www/website/
git clone https://github.com/jinumona/aws-elb-site.git  /var/www/website/
cp -rf /var/www/website/*  /var/www/html/
chown -R apache:apache /var/www/html
systemctl restart httpd.service
systemctl enable httpd.service


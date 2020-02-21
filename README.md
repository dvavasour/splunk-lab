# This is Dunstan's Splunk lab

### Adding a proxy on port 80

sudo yum install -y httpd
service httpd start

cp -p ~splunk/splunk-lab/httpd/conf.d/Splunk-proxy.conf /etc/httpd/conf.d
service httpd restart


#!/bin/bash

(cd ~ec2-user; tar cf - .ssh | (cd ~splunk; tar xf - ; chown -R splunk:splunk .))
yum install -y emacs
yum install -y sysstat

cat >> ~splunk/.bashrc << EOF
SPLUNK_HOME=/opt/splunk
####SPLUNK_HOME=/opt/splunkforwarder
PATH=\${PATH}:\$SPLUNK_HOME/bin
export SPLUNK_HOME PATH


alias ch='cd \$SPLUNK_HOME'
alias ca='cd \$SPLUNK_HOME/etc/apps'
EOF
chown splunk:splunk ~splunk/.bashrc

(cd /opt; tar xzf /home/splunk/splunk-software/splunk*)
chown -R splunk:splunk /opt/splunk

sudo -u splunk /opt/splunk/bin/splunk start --accept-license
sudo -u splunk /opt/splunk/bin/splunk edit user admin -password S0d0esme -auth admin:changeme
sudo -u splunk touch /opt/splunk/etc/.ui_login
/opt/splunk/bin/splunk enable boot-start -user splunk


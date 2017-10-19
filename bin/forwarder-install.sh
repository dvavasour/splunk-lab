#!/bin/bash

(cd ~ec2-user; tar cf - .ssh | (cd ~splunk; tar xf - ; chown -R splunk:splunk .))
yum install -y emacs
yum install -y sysstat

cat >> ~splunk/.bashrc << EOF
####SPLUNK_HOME=/opt/splunk
SPLUNK_HOME=/opt/splunkforwarder
PATH=\${PATH}:\$SPLUNK_HOME/bin
export SPLUNK_HOME PATH


alias ch='cd \$SPLUNK_HOME'
alias ca='cd \$SPLUNK_HOME/etc/apps'
EOF
chown splunk:splunk ~splunk/.bashrc

(cd /opt; tar xzf /home/splunk/splunk-forwarder/splunk*)
chown -R splunk:splunk /opt/splunkforwarder

sudo -u splunk /opt/splunkforwarder/bin/splunk start --accept-license
/opt/splunkforwarder/bin/splunk enable boot-start -user splunk


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

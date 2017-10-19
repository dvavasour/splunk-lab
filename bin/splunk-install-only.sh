#!/bin/bash

cat >> ~splunk/.bashrc << EOF
SPLUNK_HOME=/opt/splunk
####SPLUNK_HOME=/opt/splunkforwarder
PATH=\${PATH}:\$SPLUNK_HOME/bin
export SPLUNK_HOME PATH
EOF
chown splunk:splunk ~splunk/.bashrc

(cd /opt; tar xzf /home/splunk/splunk-software/splunk*)
chown -R splunk:splunk /opt/splunk

sudo -u splunk /opt/splunk/bin/splunk start --accept-license
sudo -u splunk /opt/splunk/bin/splunk edit user admin -password S0d0esme -auth admin:changeme
sudo -u splunk touch /opt/splunk/etc/.ui_login
/opt/splunk/bin/splunk enable boot-start -user splunk


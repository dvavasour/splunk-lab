#!/bin/bash

cat >> ~splunk/.bashrc << EOF
####SPLUNK_HOME=/opt/splunk
SPLUNK_HOME=/opt/splunkforwarder
PATH=\${PATH}:\$SPLUNK_HOME/bin
export SPLUNK_HOME PATH
EOF
chown splunk:splunk ~splunk/.bashrc

(cd /opt; tar xzf /home/splunk/splunk-forwarder/splunk*)
chown -R splunk:splunk /opt/splunkforwarder

sudo -u splunk /opt/splunkforwarder/bin/splunk start --accept-license
/opt/splunkforwarder/bin/splunk enable boot-start -user splunk


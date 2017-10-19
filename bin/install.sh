#!/bin/bash

use_case=$0

function ssh_keys {
    (cd ~ec2-user; tar cf - .ssh | (cd ~splunk; tar xf - ; chown -R splunk:splunk .))
}

function install_packages {
    yum install -y emacs
    yum install -y sysstat
}

function bashrc_forwarder {
cat >> ~splunk/.bashrc << EOF
####SPLUNK_HOME=/opt/splunk
SPLUNK_HOME=/opt/splunkforwarder
PATH=\${PATH}:\$SPLUNK_HOME/bin
export SPLUNK_HOME PATH


alias ch='cd \$SPLUNK_HOME'
alias ca='cd \$SPLUNK_HOME/etc/apps'
EOF
chown splunk:splunk ~splunk/.bashrc
}

function bashrc_forwarder {
cat >> ~splunk/.bashrc << EOF
SPLUNK_HOME=/opt/splunk
####SPLUNK_HOME=/opt/splunkforwarder
PATH=\${PATH}:\$SPLUNK_HOME/bin
export SPLUNK_HOME PATH


alias ch='cd \$SPLUNK_HOME'
alias ca='cd \$SPLUNK_HOME/etc/apps'
EOF
chown splunk:splunk ~splunk/.bashrc
}

function copy_software {
    sudo -u splunk aws s3 --region eu-west-2 cp s3://dvavasour-splunk /home/splunk --recursive
}

function copy_fun_stuff {
    sudo -u splunk aws s3 --region eu-west-2 cp s3://dvavasour-splunk-2 /home/splunk --recursive
}

function install_splunk {
    (cd /opt; tar xzf /home/splunk/splunk-software/splunk*)
    chown -R splunk:splunk /opt/splunk

    sudo -u splunk /opt/splunk/bin/splunk start --accept-license
    sudo -u splunk /opt/splunk/bin/splunk edit user admin -password S0d0esme -auth admin:changeme
    sudo -u splunk touch /opt/splunk/etc/.ui_login
    /opt/splunk/bin/splunk enable boot-start -user splunk
}

function install_forwarder {
    (cd /opt; tar xzf /home/splunk/splunk-forwarder/splunk*)
    chown -R splunk:splunk /opt/splunkforwarder

    sudo -u splunk /opt/splunkforwarder/bin/splunk start --accept-license
    /opt/splunkforwarder/bin/splunk enable boot-start -user splunk
}

function base_functions {
    ssh_keys
    install_packages
    copy_software
}

function forwarder_functions {
    install_forwarder
}

function splunk_functions {
    install_splunk
}

case $use_case in
    NoInstall*)
	base_functions
	;;
    ForwarderInstall*)
	base_functions
	bashrc_forwarder
	forwarder_functions
	;;
    SplunkInstall*)
	base_functions
	bashrc_splunk
	splunk_functions
	;;
    *)
	base_functions
	;;
esac

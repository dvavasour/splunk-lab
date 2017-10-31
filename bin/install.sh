#!/bin/bash

use_case=$1

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

function bashrc_splunk {
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

function install_splunk7 {
    (cd /opt; tar xzf /home/splunk/splunk7-software/splunk*)
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

function install_forwarder7 {
    (cd /opt; tar xzf /home/splunk/splunk7-forwarder/splunk*)
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

function forwarder7_functions {
    install_forwarder7
}

function splunk7_functions {
    install_splunk7
}

case $use_case in
    NoInstall)
	echo NoInstall > /tmp/usecase
	echo $use_case >> /tmp/usecase
	base_functions
	;;
    ForwarderInstall)
	echo ForwarderInstall > /tmp/usecase
	echo $use_case >> /tmp/usecase
	base_functions
	bashrc_forwarder
	forwarder_functions
	;;
    Forwarder7Install)
	echo ForwarderInstall > /tmp/usecase
	echo $use_case >> /tmp/usecase
	base_functions
	bashrc_forwarder
	forwarder7_functions
	;;
    SplunkInstall)
	echo SplunkInstall > /tmp/usecase
	echo $use_case >> /tmp/usecase
	base_functions
	bashrc_splunk
	splunk_functions
	;;
    Splunk7Install)
	echo SplunkInstall > /tmp/usecase
	echo $use_case >> /tmp/usecase
	base_functions
	bashrc_splunk
	splunk7_functions
	;;
    *)
	echo CatchAll > /tmp/usecase
	echo $use_case >> /tmp/usecase
	base_functions
	;;
esac

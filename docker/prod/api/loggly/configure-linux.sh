#!/bin/bash

#trapping Control + C
#these statements must be the first statements in the script to trap the CTRL C event

trap ctrl_c INT

function ctrl_c()  {
	logMsgToConfigSysLog "INFO" "INFO: Aborting the script."
	exit 1
}

##########  Variable Declarations - Start  ##########

#name of the current script. This will get overwritten by the child script which calls this
SCRIPT_NAME=configure-linux.sh
#version of the current script. This will get overwritten by the child script which calls this
SCRIPT_VERSION=1.16

#application tag. This will get overwritten by the child script which calls this
APP_TAG=

#directory location for syslog
RSYSLOG_ETCDIR_CONF=/etc/rsyslog.d
#name and location of loggly syslog file
LOGGLY_RSYSLOG_CONFFILE=$RSYSLOG_ETCDIR_CONF/22-loggly.conf
#name and location of loggly syslog backup file
LOGGLY_RSYSLOG_CONFFILE_BACKUP=$LOGGLY_RSYSLOG_CONFFILE.loggly.bk

#syslog directory
RSYSLOG_DIR=/var/spool/rsyslog
#rsyslog service name
RSYSLOG_SERVICE=rsyslog
#syslog-ng
SYSLOG_NG_SERVICE=syslog-ng
#rsyslogd
RSYSLOGD=rsyslogd
#minimum version of rsyslog to enable logging to loggly
MIN_RSYSLOG_VERSION=5.8.0
#this variable will hold the users syslog version
RSYSLOG_VERSION=

#this variable will hold the host name
HOST_NAME=
#this variable will hold the name of the linux distribution
LINUX_DIST=

#host name for logs-01.loggly.com
LOGS_01_HOST=logs-01.loggly.com
LOGS_01_URL=https://$LOGS_01_HOST
#this variable will contain loggly account url in the format https://$LOGGLY_ACCOUNT.loggly.com
LOGGLY_ACCOUNT_URL=
#loggly.com URL
LOGGLY_COM_URL=https://www.loggly.com

######Inputs provided by user######
#this variable will hold the loggly account name provided by user.
#this is a mandatory input
LOGGLY_ACCOUNT=
#this variable will hold the loggly authentication token provided by user.
#this is a mandatory input
LOGGLY_AUTH_TOKEN=
#this variable will identify if the user has selected to rollback settings
LOGGLY_ROLLBACK=
#this variable will hold the user name provided by user
#this is a mandatory input
LOGGLY_USERNAME=
#this variable will hold the password provided by user
#this is a mandatory input
LOGGLY_PASSWORD=

#if this variable is set to true then suppress all prompts
SUPPRESS_PROMPT="false"

#variables used in 22-loggly.conf file
LOGGLY_SYSLOG_PORT=514
LOGGLY_DISTRIBUTION_ID="41058"

#Instruction link on how to configure loggly on linux manually. This will get overwritten by the child script which calls this
#on how to configure the child application
MANUAL_CONFIG_INSTRUCTION="Manual instructions to configure rsyslog on Linux are available at https://www.loggly.com/docs/rsyslog-manual-configuration/. Rsyslog troubleshooting instructions are available at https://www.loggly.com/docs/troubleshooting-rsyslog/"

#this variable is set if the script is invoked via some other calling script
IS_INVOKED=

#this variable will hold if the check env function for linux is invoked
LINUX_ENV_VALIDATED="false"

#this variable will inform if verification needs to be performed
LINUX_DO_VERIFICATION="false"

##########  Variable Declarations - End  ##########

#check if the Linux environment is compatible with Loggly.
#Also set few variables after the check.
checkLinuxLogglyCompatibility()
{
	#check if the user has root permission to run this script
	checkIfUserHasRootPrivileges

	#check if the OS is supported by the script. If no, then exit
	checkIfSupportedOS

	#set the basic variables needed by this script
	setLinuxVariables

	#check if the Loggly servers are accessible. If no, ask user to check network connectivity & exit
	checkIfLogglyServersAccessible

	#check if user credentials are valid. If no, then exit
	checkIfValidUserNamePassword

	#get authentication token if not provided
	getAuthToken

	#check if authentication token is valid. If no, then exit.
	checkIfValidAuthToken

	#checking if syslog-ng is configured as a service
	checkifSyslogNgConfiguredAsService

	#check if systemd is present in machine.
	checkIfSystemdConfigured

	#check if rsyslog is configured as service. If no, then exit
	checkIfRsyslogConfiguredAsService

	#check if multiple rsyslog are present in the system. If yes, then exit
	checkIfMultipleRsyslogConfigured

	#check for the minimum version of rsyslog i.e 5.8.0. If no, then exit
	checkIfMinVersionOfRsyslog

	#check if selinux service is enforced. if yes, ask the user to manually disable and exit the script
	checkIfSelinuxServiceEnforced
	
	#update rsyslog.conf and adds $MaxMessageSize in it
	modifyMaxMessageSize

	LINUX_ENV_VALIDATED="true"
}

# executing the script for loggly to install and configure rsyslog.
installLogglyConf()
{
	#log message indicating starting of Loggly configuration
	logMsgToConfigSysLog "INFO" "INFO: Initiating Configure Loggly for Linux."

	if [ "$LINUX_ENV_VALIDATED" = "false" ]; then
		checkLinuxLogglyCompatibility
	fi

	#if all the above check passes, write the 22-loggly.conf file
	checkAuthTokenAndWriteContents

	#create rsyslog dir if it doesn't exist, Modify the permission on rsyslog directory if exist on Ubuntu
	createRsyslogDir

	if [ "$LINUX_DO_VERIFICATION" = "true" ]; then
		#check if the logs are going to loggly fro linux system now
		checkIfLogsMadeToLoggly
	fi

	if [ "$IS_INVOKED" = "" ]; then
		logMsgToConfigSysLog "SUCCESS" "SUCCESS: Linux system successfully configured to send logs via Loggly."
	fi

}

#remove loggly configuration from Linux system
removeLogglyConf()
{
	#log message indicating starting of Loggly configuration
	logMsgToConfigSysLog "INFO" "INFO: Initiating uninstall Loggly for Linux."

	#check if the user has root permission to run this script
	checkIfUserHasRootPrivileges

	#check if the OS is supported by the script. If no, then exit
	checkIfSupportedOS

	#set the basic variables needed by this script
	setLinuxVariables

	#remove systemd-rsyslog configuration
	revertSystemdChanges

	#remove 22-loggly.conf file
	remove22LogglyConfFile

	#restart rsyslog service
	restartRsyslog

	#log success message
	logMsgToConfigSysLog "SUCCESS" "SUCCESS: Uninstalled Loggly configuration from Linux system."
}

#checks if user has root privileges
checkIfUserHasRootPrivileges()
{
	#This script needs to be run as root
	if [[ $EUID -ne 0 ]]; then
	   logMsgToConfigSysLog "ERROR" "ERROR: This script must be run as root."
	   exit 1
	fi
}

#check if supported operating system
checkIfSupportedOS()
{
	getOs

	LINUX_DIST_IN_LOWER_CASE=$(echo $LINUX_DIST | tr "[:upper:]" "[:lower:]")

	case "$LINUX_DIST_IN_LOWER_CASE" in
		*"ubuntu"* )
		echo "INFO: Operating system is Ubuntu."
		;;
		*"redhat"* )
		echo "INFO: Operating system is Red Hat."
		;;
		*"centos"* )
		echo "INFO: Operating system is CentOS."
		;;
		*"debian"* )
		echo "INFO: Operating system is Debian."
		;;
		*"amazon"* )
		echo "INFO: Operating system is Amazon AMI."
		;;
		*"darwin"* )
		#if the OS is mac then exit
		logMsgToConfigSysLog "ERROR" "ERROR: This script is for Linux systems, and Darwin or Mac OSX are not currently supported. You can find alternative options here: https://www.loggly.com/docs/send-mac-logs-to-loggly/"
		exit 1
		;;
		* )
		logMsgToConfigSysLog "WARN" "WARN: The linux distribution '$LINUX_DIST' has not been previously tested with Loggly."
		if [ "$SUPPRESS_PROMPT" == "false" ]; then
			while true; do
				read -p "Would you like to continue anyway? (yes/no)" yn
				case $yn in
					[Yy]* )
					break;;
					[Nn]* )
					exit 1
					;;
					* ) echo "Please answer yes or no.";;
				esac
			done
		fi
		;;
	esac
}

getOs()
{
	# Determine OS platform
	UNAME=$(uname | tr "[:upper:]" "[:lower:]")
	# If Linux, try to determine specific distribution
	if [ "$UNAME" == "linux" ]; then
		# If available, use LSB to identify distribution
		if [ -f /etc/lsb-release -o -d /etc/lsb-release.d ]; then
			LINUX_DIST=$(lsb_release -i | cut -d: -f2 | sed s/'^\t'//)
		# If system-release is available, then try to identify the name
		elif [ -f /etc/system-release ]; then
			LINUX_DIST=$(cat /etc/system-release  | cut -f 1 -d  " ")
		# Otherwise, use release info file
		else
			LINUX_DIST=$(ls -d /etc/[A-Za-z]*[_-][rv]e[lr]* | grep -v "lsb" | cut -d'/' -f3 | cut -d'-' -f1 | cut -d'_' -f1)
		fi
	fi

	# For everything else (or if above failed), just use generic identifier
	if [ "$LINUX_DIST" == "" ]; then
		LINUX_DIST=$(uname)
	fi
}

#sets linux variables which will be used across various functions
setLinuxVariables()
{
	#set host name
	HOST_NAME=$(hostname)

	#set loggly account url
	LOGGLY_ACCOUNT_URL=https://$LOGGLY_ACCOUNT.loggly.com
}

#checks if all the various endpoints used for configuring loggly are accessible
checkIfLogglyServersAccessible()
{
	echo "INFO: Checking if $LOGS_01_HOST is reachable."
	if [ $(ping -c 1 $LOGS_01_HOST | grep "1 packets transmitted, 1 received, 0% packet loss" | wc -l) == 1 ] || [ $(sleep 1 | telnet $LOGS_01_HOST $LOGGLY_SYSLOG_PORT | grep Connected | wc -l) == 1 ]; then
		echo "INFO: $LOGS_01_HOST is reachable."
	else
		logMsgToConfigSysLog "ERROR" "ERROR: $LOGS_01_HOST is not reachable. Please check your network and firewall settings."
		exit 1
	fi

	echo "INFO: Checking if $LOGS_01_HOST is reachable via $LOGGLY_SYSLOG_PORT port. This may take some time."
	if [ $(curl --connect-timeout 10 $LOGS_01_HOST:$LOGGLY_SYSLOG_PORT 2>&1 | grep "Empty reply from server" | wc -l) == 1 ]; then
		echo "INFO: $LOGS_01_HOST is reachable via $LOGGLY_SYSLOG_PORT port."
	else
		logMsgToConfigSysLog "ERROR" "ERROR: $LOGS_01_HOST is not reachable via $LOGGLY_SYSLOG_PORT port. Please check your network and firewall settings."
		exit 1
	fi

	echo "INFO: Checking if '$LOGGLY_ACCOUNT' subdomain is valid."
	if [ $(curl -s --head  --request GET $LOGGLY_ACCOUNT_URL/login | grep "200 OK" | wc -l) == 1 ]; then
		echo "INFO: $LOGGLY_ACCOUNT_URL is valid and reachable."
	else
		logMsgToConfigSysLog "ERROR" "ERROR: This is not a recognized subdomain. Please ask the account owner for the subdomain they signed up with."
		exit 1
	fi

	echo "INFO: Checking if Gen2 account."
	if [ $(curl -s --head  --request GET $LOGGLY_ACCOUNT_URL/apiv2/customer | grep "404 NOT FOUND" | wc -l) == 1 ]; then
		logMsgToConfigSysLog "ERROR" "ERROR: This scripts need a Gen2 account. Please contact Loggly support."
		exit 1
	else
		echo "INFO: It is a Gen2 account."
	fi
}

#check if user name and password is valid
checkIfValidUserNamePassword()
{
	echo "INFO: Checking if provided username and password is correct."
	if [ $(curl -s -u $LOGGLY_USERNAME:$LOGGLY_PASSWORD $LOGGLY_ACCOUNT_URL/apiv2/customer | grep "Unauthorized" | wc -l) == 1 ]; then
			logMsgToConfigSysLog "INFO" "INFO: Please check your username or reset your password at $LOGGLY_ACCOUNT_URL/account/users/"
			logMsgToConfigSysLog "ERROR" "ERROR: Invalid Loggly username or password. Your username is visible at the top right of the Loggly console before the @ symbol. You can reset your password at http://<subdomain>.loggly.com/login."
			exit 1
	else
		logMsgToConfigSysLog "INFO" "INFO: Username and password authorized successfully."
	fi
}

getAuthToken()
{
	if [ "$LOGGLY_AUTH_TOKEN" = "" ]; then
		logMsgToConfigSysLog "INFO" "INFO: Authentication token not provided. Trying to retrieve it from $LOGGLY_ACCOUNT_URL account."
		#get authentication token if user has not provided one
		tokenstr=$(curl -s -u $LOGGLY_USERNAME:$LOGGLY_PASSWORD $LOGGLY_ACCOUNT_URL/apiv2/customer | grep -v "token")

		#get the string from index 0 to first occurence of ,
		tokenstr=${tokenstr%%,*}

		#get the string from index 0 to last occurence of "
		tokenstr=${tokenstr%\"*}

		#get the string from first occurence of " to the end
		tokenstr=${tokenstr#*\"}

		LOGGLY_AUTH_TOKEN=$tokenstr

		logMsgToConfigSysLog "INFO" "INFO: Retrieved authentication token: $LOGGLY_AUTH_TOKEN"
	fi
}

#check if authentication token is valid
checkIfValidAuthToken()
{
	echo "INFO: Checking if provided auth token is correct."
	if [ $(curl -s -u $LOGGLY_USERNAME:$LOGGLY_PASSWORD $LOGGLY_ACCOUNT_URL/apiv2/customer | grep \"$LOGGLY_AUTH_TOKEN\" | wc -l) == 1 ]; then
		logMsgToConfigSysLog "INFO" "INFO: Authentication token validated successfully."
	else
		logMsgToConfigSysLog "ERROR" "ERROR: Invalid authentication token $LOGGLY_AUTH_TOKEN. You can get valid authentication token by following instructions at https://www.loggly.com/docs/customer-token-authentication-token/."
		exit 1
	fi
}

#check if rsyslog is configured as service. If it is configured as service and not started, start the service
checkIfRsyslogConfiguredAsService()
{
	if [ -f /etc/init.d/$RSYSLOG_SERVICE ]; then
		logMsgToConfigSysLog "INFO" "INFO: $RSYSLOG_SERVICE is present as service."
	elif [ -f /usr/lib/systemd/system/$RSYSLOG_SERVICE.service ]; then
		logMsgToConfigSysLog "INFO" "INFO: $RSYSLOG_SERVICE is present as service."
	else
		logMsgToConfigSysLog "ERROR" "ERROR: $RSYSLOG_SERVICE is not present as service."
		exit 1
	fi

	#checking if syslog-ng is running as a service
	checkifSyslogNgConfiguredAsService

	if [ $(ps -A | grep "$RSYSLOG_SERVICE" | wc -l) -eq 0 ]; then
		logMsgToConfigSysLog "INFO" "INFO: $RSYSLOG_SERVICE is not running. Attempting to start service."
		service $RSYSLOG_SERVICE start
	fi
}

checkifSyslogNgConfiguredAsService()
{
	if [ $(ps -A | grep "$SYSLOG_NG_SERVICE" | wc -l) -gt 0  ]; then
		logMsgToConfigSysLog "ERROR" "ERROR: This script does not currently support syslog-ng. Please follow the instructions on this page https://www.loggly.com/docs/syslog-ng-manual-configuration"
		exit 1
	fi
}

#check if systemd is present in machine.
checkIfSystemdConfigured()
{
	FILE="/etc/systemd/journald.conf";
	if [ -f "$FILE" ]; then
		logMsgToConfigSysLog "INFO" "INFO: Systemd is present. Configuring logs from Systemd to rsyslog."
		cp /etc/systemd/journald.conf /etc/systemd/journald.conf.loggly.bk
		sed -i 's/.*ForwardToSyslog.*/ForwardToSyslog=Yes/g' /etc/systemd/journald.conf
		logMsgToConfigSysLog "INFO" "INFO: Restarting Systemd-journald"
		systemctl restart systemd-journald 
	fi
}

#check if multiple versions of rsyslog is configured
checkIfMultipleRsyslogConfigured()
{
	if [ $(ps -A | grep "$RSYSLOG_SERVICE" | wc -l) -gt 1 ]; then
		logMsgToConfigSysLog "ERROR" "ERROR: Multiple (more than 1) $RSYSLOG_SERVICE is running."
		exit 1
	fi
}

#check if minimum version of rsyslog required to configure loggly is met
checkIfMinVersionOfRsyslog()
{
	RSYSLOG_VERSION=$($RSYSLOGD -version | grep "$RSYSLOGD")
	RSYSLOG_VERSION=${RSYSLOG_VERSION#* }
	RSYSLOG_VERSION=${RSYSLOG_VERSION%,*}
	RSYSLOG_VERSION=$RSYSLOG_VERSION | tr -d " "
	if [ $(compareVersions $RSYSLOG_VERSION $MIN_RSYSLOG_VERSION 3) -lt 0 ]; then
		logMsgToConfigSysLog "ERROR" "ERROR: Min rsyslog version required is 5.8.0."
		exit 1
	fi
}

#check if SeLinux service is enforced
checkIfSelinuxServiceEnforced()
{
	isSelinuxInstalled=$(getenforce -ds 2>/dev/null)
	if [ $? -ne 0 ]; then
		logMsgToConfigSysLog "INFO" "INFO: selinux status is not enforced."
	elif [ $(getenforce | grep "Enforcing" | wc -l) -gt 0 ]; then
		logMsgToConfigSysLog "ERROR" "ERROR: selinux status is 'Enforcing'. Please disable it and start the rsyslog daemon manually."
		exit 1
	fi
}

#update rsyslog.conf and adds $MaxMessageSize in it
modifyMaxMessageSize()
{
	if  grep -q '$MaxMessageSize' "/etc/rsyslog.conf"; then
		sed -i 's/.*$MaxMessageSize.*/$MaxMessageSize 64k/g' /etc/rsyslog.conf
	else
	sed -i '1 a $MaxMessageSize 64k' /etc/rsyslog.conf
	fi
	logMsgToConfigSysLog "INFO" "INFO: Modified \$MaxMessageSize to 64k in rsyslog.conf"
}

#check if authentication token is valid and then write contents to 22-loggly.conf file to /etc/rsyslog.d directory
checkAuthTokenAndWriteContents()
{
	if [ "$LOGGLY_AUTH_TOKEN" != "" ]; then
		writeContents $LOGGLY_ACCOUNT $LOGGLY_AUTH_TOKEN $LOGGLY_DISTRIBUTION_ID $LOGS_01_HOST $LOGGLY_SYSLOG_PORT
		restartRsyslog
	else
		logMsgToConfigSysLog "ERROR" "ERROR: Loggly auth token is required to configure rsyslog. Please pass -a <auth token> while running script."
		exit 1
	fi
}


#write the contents to 22-loggly.conf file
writeContents()
{

WRITE_SCRIPT_CONTENTS="false"
inputStr="
#          -------------------------------------------------------
#          Syslog Logging Directives for Loggly ($1.loggly.com)
#          -------------------------------------------------------

# Define the template used for sending logs to Loggly. Do not change this format.
\$template LogglyFormat,\"<%pri%>%protocol-version% %timestamp:::date-rfc3339% %HOSTNAME% %app-name% %procid% %msgid% [$2@$3] %msg%\n\"

\$WorkDirectory /var/spool/rsyslog # where to place spool files
\$ActionQueueFileName fwdRule1 # unique name prefix for spool files
\$ActionQueueMaxDiskSpace 1g   # 1gb space limit (use as much as possible)
\$ActionQueueSaveOnShutdown on # save messages to disk on shutdown
\$ActionQueueType LinkedList   # run asynchronously
\$ActionResumeRetryCount -1    # infinite retries if host is down

# Send messages to Loggly over TCP using the template.
*.*             @@$4:$5;LogglyFormat

#     -------------------------------------------------------
"
	if [ -f "$LOGGLY_RSYSLOG_CONFFILE" ]; then
		logMsgToConfigSysLog "INFO" "INFO: Loggly rsyslog file $LOGGLY_RSYSLOG_CONFFILE already exist."

		STR_SIZE=${#inputStr}
		SIZE_FILE=$(stat -c%s "$LOGGLY_RSYSLOG_CONFFILE")

		#actual file size and variable size with same contents always differ in size with one byte
		STR_SIZE=$(( STR_SIZE + 1 ))

		if [ "$STR_SIZE" -ne "$SIZE_FILE" ]; then

			logMsgToConfigSysLog "WARN" "WARN: Loggly rsyslog file /etc/rsyslog.d/22-loggly.conf content has changed."
			if [ "$SUPPRESS_PROMPT" == "false" ]; then
					while true;
					do
						read -p "Do you wish to override $LOGGLY_RSYSLOG_CONFFILE and re-verify configuration? (yes/no)" yn
						case $yn in
						[Yy]* )
							logMsgToConfigSysLog "INFO" "INFO: Going to back up the conf file: $LOGGLY_RSYSLOG_CONFFILE to $LOGGLY_RSYSLOG_CONFFILE_BACKUP";
							mv -f $LOGGLY_RSYSLOG_CONFFILE $LOGGLY_RSYSLOG_CONFFILE_BACKUP;
							WRITE_SCRIPT_CONTENTS="true"
							break;;
						[Nn]* )
							LINUX_DO_VERIFICATION="false"
							logMsgToConfigSysLog "INFO" "INFO: Skipping Linux verification."
							break;;
						* ) echo "Please answer yes or no.";;
						esac
					done
			else
				logMsgToConfigSysLog "INFO" "INFO: Going to back up the conf file: $LOGGLY_RSYSLOG_CONFFILE to $LOGGLY_RSYSLOG_CONFFILE_BACKUP";
				mv -f $LOGGLY_RSYSLOG_CONFFILE $LOGGLY_RSYSLOG_CONFFILE_BACKUP;
				WRITE_SCRIPT_CONTENTS="true"
			fi
		else
			 LINUX_DO_VERIFICATION="false"
		fi
	else
		WRITE_SCRIPT_CONTENTS="true"
	fi

	if [ "$WRITE_SCRIPT_CONTENTS" == "true" ]; then

cat << EOIPFW >> $LOGGLY_RSYSLOG_CONFFILE
$inputStr
EOIPFW

	fi

}

#create /var/spool/rsyslog directory if not already present. Modify the permission of this directory for Ubuntu
createRsyslogDir()
{
	if [ -d "$RSYSLOG_DIR" ]; then
		logMsgToConfigSysLog "INFO" "INFO: $RSYSLOG_DIR already exist, so not creating directory."
		if [[ "$LINUX_DIST" == *"Ubuntu"* ]]; then
			logMsgToConfigSysLog "INFO" "INFO: Changing the permission on the rsyslog in /var/spool"
			chown -R syslog:adm $RSYSLOG_DIR
		fi
	else
		logMsgToConfigSysLog "INFO" "INFO: Creating directory $SYSLOGDIR"
		mkdir -v $RSYSLOG_DIR
		if [[ "$LINUX_DIST" == *"Ubuntu"* ]]; then
			chown -R syslog:adm $RSYSLOG_DIR
		fi
	fi
}

#check if the logs made it to Loggly
checkIfLogsMadeToLoggly()
{
	logMsgToConfigSysLog "INFO" "INFO: Sending test message to Loggly."
	uuid=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

	queryParam="syslog.appName%3ALOGGLYVERIFY%20$uuid"
	logger -t "LOGGLYVERIFY" "LOGGLYVERIFY-Test message for verification with UUID $uuid"

	counter=1
	maxCounter=10
	finalCount=0

	queryUrl="$LOGGLY_ACCOUNT_URL/apiv2/search?q=$queryParam"
	logMsgToConfigSysLog "INFO" "INFO: Search URL: $queryUrl"

	logMsgToConfigSysLog "INFO" "INFO: Verifying if the log made it to Loggly."
	logMsgToConfigSysLog "INFO" "INFO: Verification # $counter of total $maxCounter."
	searchAndFetch finalCount "$queryUrl"
	let counter=$counter+1

	while [ "$finalCount" -eq 0 ]; do
		echo "INFO: Did not find the test log message in Loggly's search yet. Waiting for 30 secs."
		sleep 30
		echo "INFO: Done waiting. Verifying again."
		logMsgToConfigSysLog "INFO" "INFO: Verification # $counter of total $maxCounter."
		searchAndFetch finalCount "$queryUrl"
		let counter=$counter+1
		if [ "$counter" -gt "$maxCounter" ]; then
			logMsgToConfigSysLog "ERROR" "ERROR: Logs did not make to Loggly in time. Please check network and firewall settings and retry."
			exit 1
		fi
	done

	if [ "$finalCount" -eq 1 ]; then
		if [ "$IS_INVOKED" = "" ]; then
			logMsgToConfigSysLog "SUCCESS" "SUCCESS: Verification logs successfully transferred to Loggly! You are now sending Linux system logs to Loggly."
	 		exit 0
		else
			logMsgToConfigSysLog "INFO" "SUCCESS: Verification logs successfully transferred to Loggly! You are now sending Linux system logs to Loggly."
 		fi
	fi

}

#delete 22-loggly.conf file
remove22LogglyConfFile()
{
	if [ -f "$LOGGLY_RSYSLOG_CONFFILE" ]; then
		rm -rf "$LOGGLY_RSYSLOG_CONFFILE"
	fi
}

revertSystemdChanges()
{
	FILE="/etc/systemd/journald.conf.loggly.bk";
	if [ -f "$FILE" ]; then
		cp /etc/systemd/journald.conf.loggly.bk /etc/systemd/journald.conf
		rm /etc/systemd/journald.conf.loggly.bk
		logMsgToConfigSysLog "INFO" "INFO: Reverted Systemd-rsyslog configuration"
		systemctl restart systemd-journald
	fi
}

#compares two version numbers, used for comparing versions of various softwares
compareVersions ()
{
	typeset    IFS='.'
	typeset -a v1=( $1 )
	typeset -a v2=( $2 )
	typeset    n diff

	for (( n=0; n<$3; n+=1 )); do
	diff=$((v1[n]-v2[n]))
	if [ $diff -ne 0 ] ; then
		[ $diff -le 0 ] && echo '-1' || echo '1'
		return
	fi
	done
	echo  '0'
}

#restart rsyslog
restartRsyslog()
{
	logMsgToConfigSysLog "INFO" "INFO: Restarting the $RSYSLOG_SERVICE service."
	service $RSYSLOG_SERVICE restart
	if [ $? -ne 0 ]; then
		logMsgToConfigSysLog "WARNING" "WARNING: $RSYSLOG_SERVICE did not restart gracefully. Please restart $RSYSLOG_SERVICE manually."
	fi
}

#logs message to config syslog
logMsgToConfigSysLog()
{
	#$1 variable will be SUCCESS or ERROR or INFO or WARNING
	#$2 variable will be the message
	cslStatus=$1
	cslMessage=$2
	echo "$cslMessage"
	currentTime=$(date)

	#for Linux system, we need to use -d switch to decode base64 whereas
	#for Mac system, we need to use -D switch to decode
	varUname=$(uname)
	if [[ $varUname == 'Linux' ]]; then
		enabler=$(echo -n MWVjNGU4ZTEtZmJiMi00N2U3LTkyOWItNzVhMWJmZjVmZmUw | base64 -d)
	elif [[ $varUname == 'Darwin' ]]; then
		enabler=$(echo MWVjNGU4ZTEtZmJiMi00N2U3LTkyOWItNzVhMWJmZjVmZmUw | base64 -D)
	fi

	if [ $? -ne 0 ]; then
        echo  "ERROR: Base64 decode is not supported on your Operating System. Please update your system to support Base64."
        exit 1
	fi

	sendPayloadToConfigSysLog "$cslStatus" "$cslMessage" "$enabler"

	#if it is an error, then log message "Script Failed" to config syslog and exit the script
	if [[ $cslStatus == "ERROR" ]]; then
		sendPayloadToConfigSysLog "ERROR" "Script Failed" "$enabler"
		if [ "$varUname" != "Darwin" ]; then
			echo $MANUAL_CONFIG_INSTRUCTION
		fi
		exit 1
	fi

	#if it is a success, then log message "Script Succeeded" to config syslog and exit the script
	if [[ $cslStatus == "SUCCESS" ]]; then
		sendPayloadToConfigSysLog "SUCCESS" "Script Succeeded" "$enabler"
		exit 0
	fi
}

#payload construction to send log to config syslog
sendPayloadToConfigSysLog()
{
	if [ "$APP_TAG" = "" ]; then
		var="{\"sub-domain\":\"$LOGGLY_ACCOUNT\", \"user-name\":\"$LOGGLY_USERNAME\", \"customer-token\":\"$LOGGLY_AUTH_TOKEN\", \"host-name\":\"$HOST_NAME\", \"script-name\":\"$SCRIPT_NAME\", \"script-version\":\"$SCRIPT_VERSION\", \"status\":\"$1\", \"time-stamp\":\"$currentTime\", \"linux-distribution\":\"$LINUX_DIST\", \"messages\":\"$2\",\"rsyslog-version\":\"$RSYSLOG_VERSION\"}"
	else
		var="{\"sub-domain\":\"$LOGGLY_ACCOUNT\", \"user-name\":\"$LOGGLY_USERNAME\", \"customer-token\":\"$LOGGLY_AUTH_TOKEN\", \"host-name\":\"$HOST_NAME\", \"script-name\":\"$SCRIPT_NAME\", \"script-version\":\"$SCRIPT_VERSION\", \"status\":\"$1\", \"time-stamp\":\"$currentTime\", \"linux-distribution\":\"$LINUX_DIST\", $APP_TAG, \"messages\":\"$2\",\"rsyslog-version\":\"$RSYSLOG_VERSION\"}"
	fi
	curl -s -H "content-type:application/json" -d "$var" $LOGS_01_URL/inputs/$3 > /dev/null 2>&1
}

#$1 return the count of records in loggly, $2 is the query param to search in loggly
searchAndFetch()
{
	url=$2

	result=$(wget -qO- /dev/null --user "$LOGGLY_USERNAME" --password "$LOGGLY_PASSWORD" "$url")

	if [ -z "$result" ]; then
		logMsgToConfigSysLog "ERROR" "ERROR: Please check your network/firewall settings & ensure Loggly subdomain, username and password is specified correctly."
		exit 1
	fi
	id=$(echo "$result" | grep -v "{" | grep id | awk '{print $2}')
	# strip last double quote from id
	id="${id%\"}"
	# strip first double quote from id
	id="${id#\"}"
	url="$LOGGLY_ACCOUNT_URL/apiv2/events?rsid=$id"

	# retrieve the data
	result=$(wget -qO- /dev/null --user "$LOGGLY_USERNAME" --password "$LOGGLY_PASSWORD" "$url")
	count=$(echo "$result" | grep total_events | awk '{print $2}')
	count="${count%\,}"
	eval $1="'$count'"
	if [ "$count" -gt 0 ]; then
		timestamp=$(echo "$result" | grep timestamp)
	fi
}

#get password in the form of asterisk
getPassword()
{
	unset LOGGLY_PASSWORD
	prompt="Please enter Loggly Password:"
	while IFS= read -p "$prompt" -r -s -n 1 char
	do
		if [[ $char == $'\0' ]]
		then
			break
		fi
		prompt='*'
		LOGGLY_PASSWORD+="$char"
	done
	echo
}

#display usage syntax
usage()
{
cat << EOF
usage: configure-linux [-a loggly auth account or subdomain] [-t loggly token (optional)] [-u username] [-p password (optional)] [-s suppress prompts {optional)]
usage: configure-linux [-a loggly auth account or subdomain] [-r to remove]
usage: configure-linux [-h for help]
EOF
}

##########  Get Inputs from User - Start  ##########
if [ "$1" != "being-invoked" ]; then
	if [ $# -eq 0 ]; then
		usage
		exit
	else
		while [ "$1" != "" ]; do
			case $1 in
			-t | --token ) shift
				LOGGLY_AUTH_TOKEN=$1
				echo "AUTH TOKEN $LOGGLY_AUTH_TOKEN"
				;;
			-a | --account ) shift
				LOGGLY_ACCOUNT=$1
				echo "Loggly account or subdomain: $LOGGLY_ACCOUNT"
				;;
			-u | --username ) shift
				LOGGLY_USERNAME=$1
				echo "Username is set"
				;;
			-p | --password ) shift
				LOGGLY_PASSWORD=$1
				;;
			-r | --remove )
				LOGGLY_REMOVE="true"
				;;
			-s | --suppress )
				SUPPRESS_PROMPT="true"
				;;
			-h | --help)
				usage
				exit
				;;
			*) usage
			exit
			;;
			esac
			shift
		done
	fi

	if [ "$LOGGLY_REMOVE" != "" -a "$LOGGLY_ACCOUNT" != "" ]; then
		removeLogglyConf
	elif [ "$LOGGLY_ACCOUNT" != "" -a "$LOGGLY_USERNAME" != "" ]; then
		if [ "$LOGGLY_PASSWORD" = "" ]; then
			getPassword
		fi
		installLogglyConf
	else
		usage
	fi
else
	IS_INVOKED="true"
fi

##########  Get Inputs from User - End  ##########       -------------------------------------------------------
#          End of Syslog Logging Directives for Loggly
#

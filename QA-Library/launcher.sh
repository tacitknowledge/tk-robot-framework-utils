#!/bin/bash
  
# Check the parameters
if [ $# -l 2 ]
then
	  echo -e "Usage: ${0} startup selector + environment setter"
	    exit 1
else
      CONF_FILE=$1
      ENVIRONMENT=$2
fi
 #     echo -e "Starting script $0\n";
        
      # Read config file and assign values
      start_up_command="pybot"
      for i in `cat $CONF_FILE | grep '^[^#].*'`
       do
	    var=`echo "$i" | awk -F"=" '{print $1}'`
		param=`echo "$i" | awk -F"=" '{print $2}'`
		eval $var=$param
		if [ "$param" = true ]; then
			start_up_command="$start_up_command --include $var";
		fi		       
	   done
	   shift

start_up_command="$start_up_command --variable ENVIRONMENT_CONFIG:$ENVIRONMENT ./";
echo -e "RUNNING: $start_up_command"
$start_up_command
echo -e "END SCRIPT";
	 

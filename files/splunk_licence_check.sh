#!/bin/bash

difference() {
   date_one=$(date -d "$1" +%s)
   date_two=$(date -d "$2" +%s)
   echo $(( (date_one - date_two) / 86400 )) days
}

for LICENSE_FILE in /opt/splunk/etc/licenses/download-trial/*; do
  EXPIRE_DATE=`cat $LICENSE_FILE | grep absolute_expiration_time | sed -e 's/<[^>]*>//g'`
  SPLUNK_EXPIRE=`date -d @"${EXPIRE_DATE}" +"%d %b %Y"`

#  difference "${SPLUNK_EXPIRE}" $(date) >> /var/log/splunk-license.log
  difference "${SPLUNK_EXPIRE}" $(date)
done
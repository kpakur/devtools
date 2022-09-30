#!/bin/bash

# Exports your changes from current or previous month from git repositories cloned locally
# Author: https://github.com/kpakur
# License: MIT
# Put this file into your root folder for projects
# Example:
#    myprojects/
#            art_export.sh
#            folder_1
#            folder_2
#            folder_3
# you may change author and folder names or the month in section # CONFIGURATION of this script at the bottom

# FUNCTION DECLARATIONS
init () {
    declare -g -a months
    months=( 31 28 31 30 31 30 31 31 30 31 30 31)
    currentDir=`pwd`
}

use_current_month () {
    local year=`date '+%Y'`
    local month=`date '+%m'`
    local day=`date '+%d'`

    if [ $# -gt 0 ]; then
            day=$1
            month=$2
            year=$3
            echo $year
    fi

    startDate=$year'-'$month'-01'
    endDateFile=$year'-'$month'-'${months[10#$month - 1]}
    endDate=$year'-'$month'-'${months[10#$month - 1]}'T23:59:59+01:00'
}

use_previous_month () {
    local year=`date --date='1 months ago' '+%Y'`
    local month=`date --date='1 months ago' '+%m'`
    local day=`date --date='1 months ago' '+%d'`

    if [ $# -gt 0 ]; then
            day=$1
            month=$2-1
            year=$3
            echo $year
    fi

    startDate=$year'-'$month'-01'
    endDateFile=$year'-'$month'-'${months[10#$month - 1]}
    endDate=$year'-'$month'-'${months[10#$month - 1]}'T23:59:59+01:00'
}

export_art_for_folder () {
    local repofolder=$1
	local author=$2
    mkdir -p $currentDir/workLogs
    local logName=$currentDir/workLogs/$repofolder$endDateFile.txt
    `echo '' > $logName`

    cd $repofolder

            `git log -p --author="$author" --since=$startDate --until=$endDate --branches | cat >> $logName`
    cd ..

    echo 'Wrote to file '$logName
}

# PREREQS
init

# -- what month to use

use_current_month
#use_previous_month

# -- folders, may be multiple then one in each line, i.e.
# -- export_art_for_folder "folder_1"
# -- export_art_for_folder "folder_2"
# -- export_art_for_folder "folder_3"

export_art_for_folder "folder_1" "Author firstname surname or email"
export_art_for_folder "folder_2" "Author firstname surname or email"
export_art_for_folder "folder_3" "Author firstname surname or email"

# FINISH OFF
echo "Done!"


#!/bin/bash

##---------------------------------------------------------------------------------------------------------------------#
##! \brief   Description: This script determines the latest 'trunk'-version of the given artifact located in the
##!                       Nexus repository and stores the result in the temp.file /tmp/ALTA_*_latest_filename.
##!          In:  None
##!          In:  $1   Artifact name of the subcomponent
##!               $2   File type (ztar, rpm, deb, ..)
##!               $3   [Optional] the trunk or branch including the basepath; branches/my_feature_branch.
##!          Out: Temp file created in /tmp/ which contains the full path of the file to download
##!          Returns: None
##!          Preconditions:
##!          Postconditions: None
##!          Notes: This script will be called by the deploy-nexus role
##!                 Dont take the checksum files md5 and sha1 into account
##!          Example:
##!          script: roles/deploy-nexus/files/determine_latest_trunk_artifact.sh ALTA_iRODS_rules ztar
##!
##---------------------------------------------------------------------------------------------------------------------#

ARTIFACT="$1"
FILE_TYPE="$2"
LATEST_FOUND_FILENAME="/tmp/${1}_latest_filename"

if [[ $# -eq 3 ]]; then
    BRANCH_NAME="$3"
fi

if [[ "${BRANCH_NAME}" == *"tags"* ]]; then
   TAG_DIR_NAME="${BRANCH_NAME##tags/}"
   BASE_URL="https://support.astron.nl/nexus/content/repositories/releases/nl/astron/alta/${TAG_DIR_NAME}"
elif [[ "${BRANCH_NAME}" == *"branches"* ]]; then
   BRANCH_DIR_NAME="${BRANCH_NAME##branches/}"
   BASE_URL="https://support.astron.nl/nexus/content/repositories/branches/nl/astron/alta/${BRANCH_DIR_NAME}/${ARTIFACT}"
else
   BASE_URL="https://support.astron.nl/nexus/content/repositories/snapshots/nl/astron/alta/${ARTIFACT}"
fi

printf "${BASE_URL}/" > $LATEST_FOUND_FILENAME
wget -O - ${BASE_URL} | grep $FILE_TYPE | grep -v md5 | grep -v sha1 | cut -d\> -f2 | sed -e 's!</a!!g'|sort -u |tail -1 >> $LATEST_FOUND_FILENAME

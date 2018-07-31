#! /bin/bash

#hasUser=$(iadmin lu vagrant)
#noUserFound='No rows found'
#
#if [ "$hasUser" == "$noUserFound" ]
#then
#    iadmin mkuser vagrant rodsuser
#fi
# in case we want to expose the home directory through davrods (DavRodsExposedRoot  Home)
#ichmod read public /tempZone/home
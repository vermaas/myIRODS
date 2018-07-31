#!/bin/bash
##---------------------------------------------------------------------------------------------------------------------#
##! \brief   Description: This script creates a "TASK_ID" (observation) folder with symbolic links to the
##!                       MeasurementSet (dataproducts) to be able to handle the alta_ingest.
##!                       It creates an ingest argument file.
##!
##!          Last Changes: 2018-06-12 by RGoe
##!
##!          In:  $1   -t
##!                    -i [Optional]
##!               $2   TASK_ID; The TaskID of the observation (NOT included in this ID)
##!                    INGEST_DIR; The temporary ingest folder (default /home/goei/test_ingest/)
##!                                where the symbolic links are stored.
##!          Out: None
##!          Returns: None
##!          Preconditions:
##!          - 'temporary ingest folder' is created
##!
##!          Postconditions: None
##!          Notes:
##!              This script is deployed in the alta-client folder (manually) of the datawriter
##!              Example: bash -e prepare_early_science_ingest.sh -t -WSRTA180413999
##!
##!
##---------------------------------------------------------------------------------------------------------------------#

VERSION="0.9.4-dev"
CURRENT_PATH="$(pwd)"
DATA_DIR="/data/apertif"
INGEST_DIR="/home/goei/test_ingest"
INGEST_ARGS_FILE_BASE="ingest_args"
IRODS_EARLY_SCIENCE_INGEST_PATH="apertif_main/visibilities_default/early_science/"


# Parse options
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -i)
    INGEST_DIR="$2"
    shift # past argument
    shift # past value
    ;;
   -t)
    TASK_ID="$2"
    shift # past argument
    shift # past value
    ;;
    *)    # unknown option
    echo "unknown option: $1" >&2; exit 1;;
esac
done


# Always remove old 'TASK_ID' folder
rm -rf $INGEST_DIR/$TASK_ID
mkdir -p $INGEST_DIR/$TASK_ID

# Check all existing Measurement Sets (dataproducts) for given TASK_ID
#   Make symbolic links in /home/goei/test_ingest/$TASK_ID for all files which started with
#     /data/apertif/WSRTA$TASK_ID
#     e.g. ln -s /data/apertif/WSRTA180420002_B001.MS WSRTA180420002_B001.MS
#   Get 'filesize' of measurement set
TOTAL_SIZE=0
NBR_MS=0
for entry in "${DATA_DIR}"/WSRTA*.MS
do
    if echo $entry | grep $TASK_ID; then
        echo "Found $entry , make symbolic link"
        measset="${entry##*/}"
        ln -s $entry "$INGEST_DIR/$TASK_ID/$measset"

        # Get File Size in bytes !! (du -s is in kB)
        FILE_SIZE=$(du -sb $entry | awk '{print $1}')
        TOTAL_SIZE=$((TOTAL_SIZE+FILE_SIZE))
        NBR_MS=$((NBR_MS+1))
    fi
done

TOTAL_SIZE_GB=$((TOTAL_SIZE/1000000000))
TOTAL_SIZE_GIB=$((TOTAL_SIZE/1073741824))
echo "Found $NBR_MS number of Measurement Sets with total size of $TOTAL_SIZE bytes ($TOTAL_SIZE_GB GB = ($TOTAL_SIZE_GIB GIB))"

# Create the ingest argumentfile
INGEST_ARGS_FILE_FULL_NAME="${INGEST_DIR}/${INGEST_ARGS_FILE_BASE}_${TASK_ID}.txt"
echo "Create ingest argument file $INGEST_ARGS_FILE_FULL_NAME"
echo "--host=alta-acc-icat.astron.nl" > $INGEST_ARGS_FILE_FULL_NAME
echo "--localDir=$INGEST_DIR/$TASK_ID" >> $INGEST_ARGS_FILE_FULL_NAME
echo "--irodsColl=$IRODS_EARLY_SCIENCE_INGEST_PATH$TASK_ID" >> $INGEST_ARGS_FILE_FULL_NAME
echo "--size=$TOTAL_SIZE" >> $INGEST_ARGS_FILE_FULL_NAME

echo "You can now ingest by execute:"
echo "alta_ingest --parfile $INGEST_ARGS_FILE_FULL_NAME -v"

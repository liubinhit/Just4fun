#! /bin/sh

# !!! WARRING !!!
# PREFIX_PATH For Debug 
# In the actual environment PREFIX_PATH MUST BE eque to client server mount path
# PREFIX_PATH = /mnt/mfs
PREFIX_PATH=/home/liubin/testspace/test_dir/

# configure 
SATELLITES_NAME_FILE=./satsName.list
APP_NAME_FILE=./appName.list

function RSSSDataDirCreate()
{
    if [ $# -eq 1 ]; then
        mkdir -p  ${PREFIX_PATH}/RSSSData/${1}/RSSS
    else
        echo "RSSSDataDirCreate $*": argc wrong! 1>&2
        return 1
    fi
}


function appSwapDirCreate()
{
    if [ $# -eq 2 ]; then
        mkdir -p ${PREFIX_PATH}/SWAP/${1}/"RSSS2${2}"
        mkdir -p ${PREFIX_PATH}/SWAP/${1}/"${2}2RSSS"
    else
        echo "appSwapDirCreate $*": argc wrong! 1>&2
        return 1
    fi
}


function satelliteSoftlinkCreate()
{
    if [ $# -eq 1 ]; then
        ln -s ${PREFIX_PATH}/RSSSData/${1}/RSSS ${PREFIX_PATH}/SWAP/${1}
        ln -s ${PREFIX_PATH}/SWAP/${1} ${PREFIX_PATH}/SWAP/${1}/ROOT
    else
        echo "satelliteSoftlinkCreate $*": argc worng! 1>&2
        return 1
    fi
}


#################################
# !!!!! WARRING !!!!!
# DELETE AFTER DEBUG

rm -rf ${PREFIX_PATH}/*
#################################

# create DPPSData dirs
mkdir -p ${PREFIX_PATH}/DPPSData

# create RSSSData dirs
while read satellite; do
    RSSSDataDirCreate ${satellite}
done < ${SATELLITES_NAME_FILE}

#create SWAP dirs
while read satellite; do
    while read app; do 
        appSwapDirCreate ${satellite} ${app}
    done < ${APP_NAME_FILE}
   
    # create softlink for satallite
    satelliteSoftlinkCreate ${satellite}
done < ${SATELLITES_NAME_FILE}


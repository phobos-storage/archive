#!/bin/bash

# This demo was based on the work available in Phobos 1.95.
# May not work for the following versions.

#  This script shows the use cases of the phobos pool add command

READER=1

PSQL="psql phobos phobos"
phobos="sudo phobos"
rados="sudo rados"
ceph_pool="sudo ceph osd pool"

function sep
{
    m="#####################################################################"
    echo "$m$m"
}

function comment
{
    echo "  # $*"
}

function setup
{
    $ceph_pool create pho_pool > /dev/null 2>&1
    $ceph_pool create pho_pool1 > /dev/null 2>&1
    $ceph_pool create pho_pool2 > /dev/null 2>&1
}

function reset_tables
{
    $PSQL -c "TRUNCATE TABLE media" > /dev/null 2>&1
    $PSQL -c "TRUNCATE TABLE device" > /dev/null 2>&1
}

function run_command
{
    echo
    echo "  \$ $*"
    eval $*
    echo
}

function run_command_with_db
{
    echo
    comment "Media database before call:"
    echo "\$ $PSQL -c \"SELECT * FROM media\""
    $PSQL -c "SELECT * FROM media"

    comment "Device database after call:"
    #echo "\$ $PSQL -c \"SELECT * FROM device\""
    $PSQL -c "SELECT * FROM device"

    echo
    run_command $*
    echo
    comment "Media database after call:"
    #echo "\$ $PSQL -c \"SELECT * FROM media\""
    $PSQL -c "SELECT * FROM media"

    comment "Device database after call:"
    echo "\$ $PSQL -c \"SELECT * FROM device\""
    $PSQL -c "SELECT * FROM device"

    sleep $READER
    echo
}

function reset_pools
{
    $ceph_pool delete pho_pool pho_pool --yes-i-really-really-mean-it \
        > /dev/null 2>&1
    $ceph_pool delete pho_pool1 pho_pool1 --yes-i-really-really-mean-it \
        > /dev/null 2>&1
    $ceph_pool delete pho_pool2 pho_pool2 --yes-i-really-really-mean-it \
        > /dev/null 2>&1
}

comment "RADOS Pools in Phobos are similar to directories. They are " \
        "both devices and medias. They are identified by their name in Ceph."
comment "The 'phobos pool add' command adds existent Ceph pools to the DSS."
comment "The optionnal arguments are:"
comment "    --unlock to unlock the media pool we are adding"
comment "    --tags/-T to associate tags with the pool"
echo
sep

reset_pools
reset_tables
setup

comment "On our Ceph cluster we have the following pools:"
run_command $rados lspools
echo
comment "Let's try adding the pool pho_pool to Phobos with tags"
run_command_with_db $phobos pool add pho_pool --tags t1,t2
comment "The media's id is the pool's name and the device's id is " \
        "'{host}:{poolname}'"
sep
echo
comment "If we try adding the same pool to Phobos, an error is returned:"
run_command $phobos pool add pho_pool
echo
comment "If we try to add a pool that does not exist, an error is returned"
run_command $phobos pool add foo
echo
comment "If we try adding 2 valid pools and one invalid pool at once, " \
        "the valid pools are added and an error is thrown for the last"
run_command $phobos pool add pho_pool1 foo pho_pool2

reset_pools
reset_tables

#!/bin/bash

# This demo was based on the work available in Phobos 1.92.
# May not work for the following versions.

# This scripts shows how to locate tapes or object on tapes.
#
# This scripts needs two phobos servers sharing the same DSS and must be run on
# a node able to connect by ssh to the both servers.
#
# The following states are executed :
# - add and format one drive and one tape on each server with tag "locate_demo"
# - locate the two added tapes from each one of the server,
# - create an object on each server on the newly created tape device by using
#   the tag "locate_demo",
# - locate the two objects from each one of the server,
# (TO BE DONE: - "get --best-host" the two objects from each one of the server.)
# (TO BE DONE: - delete example objects from phobos, and example tapes/drives)

SERVER0="${SERVER0:-vm0}"
DIR_SERVER0="/tmp/locate_dir_${SERVER0}"
LTO5_ON_SERVER0="${TAPE_ON_SERVER0:-P00000L5}"
DRIVE_ON_SERVER0="${DRIVE_ON_SERVER0:-/dev/st0}"

SERVER1="${SERVER1:-vm1}"
DIR_SERVER1="/tmp/locate_dir_${SERVER1}"
LTO5_ON_SERVER1="${TAPE_ON_SERVER1:-P00001L5}"
DRIVE_ON_SERVER1="${DRIVE_ON_SERVER1:-/dev/st1}"

READER=5

echo "# 2 IO servers in parallel"
echo "# both connected to the same phobos system"
echo "# metadata are shared through a common db :"
echo "# phobos DSS (Distributed State Service)"
sleep $READER
sleep $READER
sleep $READER
echo
echo "# First phobos IO server : ${SERVER0}"
sleep $READER
echo
echo "ssh ${SERVER0} sudo head -3 /etc/phobos.conf"
ssh ${SERVER0} sudo head -3 /etc/phobos.conf
sleep $READER
echo
echo "# Second phobos IO server : ${SERVER1}"
sleep $READER
echo
echo "ssh ${SERVER1} sudo head -3 /etc/phobos.conf"
ssh ${SERVER1} sudo head -3 /etc/phobos.conf
sleep $READER
echo
echo "# add one drive on ${SERVER0}"
echo "ssh ${SERVER0} phobos drive add ${DRIVE_ON_SERVER0} --unlock"
ssh ${SERVER0} phobos drive add ${DRIVE_ON_SERVER0} --unlock
echo "# add one tape on ${SERVER0}"
echo "ssh ${SERVER0} phobos tape add --tags locate_demo --type lto5 ${LTO5_ON_SERVER0}"
ssh ${SERVER0} phobos tape add --tags locate_demo --type lto5 ${LTO5_ON_SERVER0}
echo "# format one tape on ${SERVER0}"
echo "ssh ${SERVER0} phobos tape format ${LTO5_ON_SERVER0} --unlock"
ssh ${SERVER0} phobos tape format ${LTO5_ON_SERVER0} --unlock
sleep $READER
sleep $READER
echo
echo "# add one drive on ${SERVER1}"
echo "ssh ${SERVER1} phobos drive add ${DRIVE_ON_SERVER1} --unlock"
ssh ${SERVER1} phobos drive add ${DRIVE_ON_SERVER1} --unlock
echo "# add one tape on ${SERVER1}"
echo "ssh ${SERVER1} phobos tape add --tags locate_demo --type lto5 ${LTO5_ON_SERVER1}"
ssh ${SERVER1} phobos tape add --tags locate_demo --type lto5 ${LTO5_ON_SERVER1}
echo "# format one tape on ${SERVER1}"
echo "ssh ${SERVER1} phobos tape format ${LTO5_ON_SERVER1} --unlock"
ssh ${SERVER1} phobos tape format ${LTO5_ON_SERVER1} --unlock
sleep $READER
sleep $READER
echo
echo "# Locate the two new tapes from ${SERVER0}"
echo "ssh ${SERVER0} phobos tape locate ${LTO5_ON_SERVER0}"
ssh ${SERVER0} phobos tape locate ${LTO5_ON_SERVER0}
echo "ssh ${SERVER0} phobos tape locate ${LTO5_ON_SERVER1}"
ssh ${SERVER0} phobos tape locate ${LTO5_ON_SERVER1}
sleep $READER
sleep $READER
echo
echo "# Locate the two new tapes from ${SERVER1}"
echo "ssh ${SERVER1} phobos tape locate ${LTO5_ON_SERVER0}"
ssh ${SERVER1} phobos tape locate ${LTO5_ON_SERVER0}
echo "ssh ${SERVER1} phobos tape locate ${LTO5_ON_SERVER1}"
ssh ${SERVER1} phobos tape locate ${LTO5_ON_SERVER1}
sleep $READER
sleep $READER
echo
echo "# Create an object on each server on the two new tapes"
echo "ssh ${SERVER0} phobos put --family tape --tags locate_demo /etc/hosts locate_${SERVER0}"
ssh ${SERVER0} phobos put --family tape --tags locate_demo /etc/hosts locate_${SERVER0}
echo "ssh ${SERVER1} phobos put --family tape --tags locate_demo /etc/hosts locate_${SERVER1}"
ssh ${SERVER1} phobos put --family tape --tags locate_demo /etc/hosts locate_${SERVER1}
sleep $READER
sleep $READER
echo
echo "# Locate both objects from ${SERVER0}"
echo "ssh ${SERVER0} phobos locate locate_${SERVER0}"
ssh ${SERVER0} phobos locate locate_${SERVER0}
echo "ssh ${SERVER0} phobos locate locate_${SERVER1}"
ssh ${SERVER0} phobos locate locate_${SERVER1}
sleep $READER
sleep $READER
echo
echo "# Locate both objects from ${SERVER1}"
echo "ssh ${SERVER1} phobos locate locate_${SERVER0}"
ssh ${SERVER1} phobos locate locate_${SERVER0}
echo "ssh ${SERVER1} phobos locate locate_${SERVER1}"
ssh ${SERVER1} phobos locate locate_${SERVER1}
sleep $READER
sleep $READER
echo
# TO BE DONE: "phobos get --best-host" both objects from both servers
# TO BE DONE: delete demo objects and demo dirs from phobos

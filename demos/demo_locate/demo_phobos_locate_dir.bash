#!/bin/bash

# This demo was based on the work available in Phobos 1.92.
# May not work for the following versions.

# This scripts shows how to locate object or medium.
#
# This scripts needs two phobos servers sharing the same DSS and must be run on
# a node able to connect by ssh to the both servers.
#
# The following states are executed :
# - create a dir device on each server with tag "locate_demo"
# - locate the two dir devices from each one of the server,
# - create an object on each server on the newly created dir device by using the
#   tag "locate_demo",
# - locate the two objects from each one of the server,
# (TO BE DONE: - "get --best-host" the two objects from each one of the server.)
# (TO BE DONE: - delete example objects from phobos, and example dir devices)

SERVER0="${SERVER0:-vm0}"
DIR_SERVER0="/tmp/locate_dir_${SERVER0}"
SERVER1="${SERVER1:-vm1}"
DIR_SERVER1="/tmp/locate_dir_${SERVER1}"

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
echo "# add one dir on ${SERVER0}"
echo "ssh ${SERVER0} mkdir ${DIR_SERVER0}"
ssh ${SERVER0} mkdir ${DIR_SERVER0}
echo "ssh ${SERVER0} phobos dir add ${DIR_SERVER0} --tags locate_demo"
ssh ${SERVER0} phobos dir add ${DIR_SERVER0} --tags locate_demo
echo "ssh ${SERVER0} phobos dir format --fs posix --unlock ${DIR_SERVER0}"
ssh ${SERVER0} phobos dir format --fs posix --unlock ${DIR_SERVER0}
echo "ssh ${SERVER0} phobos dir list"
ssh ${SERVER0} sudo phobos dir list
sleep $READER
sleep $READER
echo
echo "# add one dir on ${SERVER1}"
echo "ssh ${SERVER1} mkdir ${DIR_SERVER1}"
ssh ${SERVER1} mkdir ${DIR_SERVER1}
echo "ssh ${SERVER1} phobos dir add ${DIR_SERVER1} --tags locate_demo"
ssh ${SERVER1} phobos dir add ${DIR_SERVER1} --tags locate_demo
echo "ssh ${SERVER1} phobos dir format --fs posix --unlock ${DIR_SERVER1}"
ssh ${SERVER1} phobos dir format --fs posix --unlock ${DIR_SERVER1}
echo "ssh ${SERVER1} phobos dir list"
ssh ${SERVER1} sudo phobos dir list
sleep $READER
sleep $READER
echo
echo "# Locate the two new dirs from ${SERVER0}"
echo "ssh ${SERVER0} phobos dir locate ${DIR_SERVER0}"
ssh ${SERVER0} phobos dir locate ${DIR_SERVER0}
echo "ssh ${SERVER0} phobos dir locate ${DIR_SERVER1}"
ssh ${SERVER0} phobos dir locate ${DIR_SERVER1}
sleep $READER
sleep $READER
echo
echo "# Locate the two new dirs from ${SERVER1}"
echo "ssh ${SERVER1} phobos dir locate ${DIR_SERVER0}"
ssh ${SERVER1} phobos dir locate ${DIR_SERVER0}
echo "ssh ${SERVER1} phobos dir locate ${DIR_SERVER1}"
ssh ${SERVER1} phobos dir locate ${DIR_SERVER1}
sleep $READER
sleep $READER
echo
echo "# Create an object on each server on the two new dirs"
echo "ssh ${SERVER0} phobos put --family dir --tags locate_demo /etc/hosts locate_${SERVER0}"
ssh ${SERVER0} phobos put --family dir --tags locate_demo /etc/hosts locate_${SERVER0}
echo "ssh ${SERVER1} phobos put --family dir --tags locate_demo /etc/hosts locate_${SERVER1}"
ssh ${SERVER1} phobos put --family dir --tags locate_demo /etc/hosts locate_${SERVER1}
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

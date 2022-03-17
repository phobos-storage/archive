#!/bin/bash

# This demo was based on the work available in Phobos 1.94.
# May not work for the following versions.

#  This script shows the different use cases of the phobos lock clean
#  admin command through the CLI

READER=3

PSQL="psql phobos phobos"
phobos="sudo phobos"
host=$(hostname -s)
turn_on_daemon="sudo systemctl start phobosd"
turn_off_daemon="sudo systemctl stop phobosd"

function reset_tables
{
    $PSQL -c "TRUNCATE TABLE lock" > /dev/null 2>&1
    $PSQL -c "TRUNCATE TABLE media" > /dev/null 2>&1
    $PSQL -c "TRUNCATE TABLE device" > /dev/null 2>&1
}

function run_command
{
    echo
    echo "# Lock database before call:"
    echo "$PSQL -c \"SELECT * FROM lock\""
    $PSQL -c "SELECT * FROM lock"
    echo
    echo $*
    eval $*
    echo
    echo "# Lock database after call:"
    echo "$PSQL -c \"SELECT * FROM lock\""
    $PSQL -c "SELECT * FROM lock"
    reset_tables
    sleep $READER
    echo
}

reset_tables

echo "# Use phobos lock clean command when phobos deamon is on"
echo "# Turn on phobos daemon"
echo "$turn_on_daemon"
$turn_on_daemon
echo
echo "# Use phobos lock clean command without --force attribute when phobosd is on"
echo "$phobos lock clean"
$phobos lock clean
sleep $READER
echo
echo "########################################################################"
echo "# Without --global attribute, only local locks (localhost is $host) are targeted"
echo "# Delete every local locks with --force attribute when deamon is on"
$PSQL << EOF
    insert into lock (type, id, owner, hostname)
    values
            ('media'::lock_type, '1', 1, 'host1'),
            ('media'::lock_type, '2', 3, 'host2'),
            ('media_update'::lock_type, '3', 4, '$host'),
            ('device'::lock_type, '3', 1, '$host');
EOF
run_command $phobos lock clean --force
echo "########################################################################"

echo "# Delete every lock with --global --force attributes"
$PSQL << EOF
    insert into lock (type, id, owner, hostname)
    values
            ('media'::lock_type, '1', 1, 'host1'),
            ('media'::lock_type, '2', 3, 'host2'),
            ('media_update'::lock_type, '3', 4, '$host'),
            ('device'::lock_type, '3', 1, '$host');
EOF
run_command $phobos lock clean --global --force
echo "########################################################################"
echo "# Try to use --global parameter without --force attribute"
echo "$phobos lock clean --global"
$phobos lock clean --global
sleep $READER
echo
echo "# Turn off phobos daemon"
echo "$turn_off_daemon"
$turn_off_daemon
sleep $READER
sleep $READER
echo
echo "########################################################################"
echo "########################################################################"
echo "# Use the command with the type parameter: -t or --type"
echo "# Supported types are 'device', 'media_update', 'media' and 'object'"
sleep $READER
sleep $READER
echo
echo "# Delete every local device lock"
$PSQL << EOF
    insert into lock (type, id, owner, hostname)
    values
            ('media'::lock_type, '3', 2, '$host'),
            ('device'::lock_type, '3', 1, '$host'),
            ('device'::lock_type, '4', 1, '$host');
EOF
run_command $phobos lock clean -t device
echo "########################################################################"

echo "# Delete every object lock"
$PSQL << EOF
    insert into lock (type, id, owner, hostname)
    values
            ('media'::lock_type, '1', 1, 'host1'),
            ('object'::lock_type, '1', 3, 'host1'),
            ('object'::lock_type, '2', 2, 'host2'),
            ('object'::lock_type, '3', 3, '$host'),
            ('media'::lock_type, '3', 2, '$host');
EOF
run_command $phobos lock clean -t object --global --force
echo "########################################################################"
echo "########################################################################"
sleep $READER
echo
echo "# Use the command with the family parameter: -f or --family"
echo "# Supported families are 'dir', 'disk', 'tape'"
echo "# A type parameter is mandatory to use the family parameter"
echo "# Supported types with families are 'device', 'media' and 'media_update'"
sleep $READER
sleep $READER
echo

echo "# Use a valid family parameter whithout giving a type"
echo "$phobos lock clean -f dir"
$phobos lock clean -f dir
echo "########################################################################"
echo "# Delete every lock of type media and family dir"
$PSQL << EOF
   insert into lock (type, id, owner, hostname)
    values
            ('media'::lock_type, '1', 1, 'host1'),
            ('media'::lock_type, '2', 3, 'host2'),
            ('media_update'::lock_type, '2', 4, 'host2'),
            ('media'::lock_type, '3', 2, '$host');

    insert into media (family, model, id, adm_status, fs_type, fs_label,
                       address_type, fs_status, stats, tags)
    values
            ('disk'::dev_family, NULL, '1', 'locked'::adm_status,
                'POSIX'::fs_type, 'label1', 'PATH'::address_type,
                'full'::fs_status, '{}', '{}'),
            ('dir'::dev_family, NULL, '2', 'unlocked'::adm_status,
                'POSIX'::fs_type, 'label2', 'PATH'::address_type,
                'empty'::fs_status, '{}', '{}'),
            ('dir'::dev_family, NULL, '3', 'locked'::adm_status,
                'POSIX'::fs_type, 'label3', 'PATH'::address_type,
                'blank'::fs_status, '{}', '{}');

EOF
echo "Media database :"
echo "$PSQL -c \"SELECT * FROM media\""
$PSQL -c "SELECT * FROM media"
run_command $phobos lock clean -t media -f dir --global --force
echo "########################################################################"
echo "########################################################################"
sleep $READER
echo

echo "# Use the command with the id parameter: -i or --ids"
echo
echo "# Remove element of type 'object' and id '3' on localhost"
$PSQL << EOF
    insert into lock (type, id, owner, hostname)
    values
            ('object'::lock_type, '1', 1, 'host1'),
            ('media_update'::lock_type, '3', 4, '$host'),
            ('object'::lock_type, '3', 3, '$host');

EOF
run_command $phobos lock clean -t object -i 3
echo "########################################################################"

echo "# Remove every element of type 'media_update' of id '2' or '3'"
$PSQL << EOF
    insert into lock (type, id, owner, hostname)
    values
            ('media_update'::lock_type, '1', 4, 'host1'),
            ('media'::lock_type, '2', 3, 'host2'),
            ('media_update'::lock_type, '2', 4, 'host2'),
            ('media_update'::lock_type, '3', 4, '$host');
EOF
run_command $phobos lock clean --global --force -t media_update -i 2 3
echo "########################################################################"

echo "# Clean an element with every parameter"
echo "# Clean the element of type 'device', of family 'dir' and of id '2'"
$PSQL << EOF
    insert into lock (type, id, owner, hostname)
    values
            ('device'::lock_type, '1', 2, 'host1'),
            ('device'::lock_type, '2', 1, 'host2');

    insert into device (family, model, id, host, adm_status,path)
    values
            ('disk'::dev_family, NULL, '1',
                'host1', 'locked'::adm_status, 'path1'),
            ('dir'::dev_family, NULL, '2',
                'host2', 'unlocked'::adm_status, 'path2');
EOF
echo "Device database :"
echo "$PSQL -c \"SELECT * FROM device\""
$PSQL -c "SELECT * FROM device"
run_command $phobos lock clean -t device -f dir -i 2 --global --force
echo "########################################################################"
echo "# Clean every element with id '1' "
$PSQL << EOF
    insert into lock (type, id, owner, hostname)
    values
            ('media'::lock_type, '1', 1, 'host1'),
            ('object'::lock_type, '1', 3, 'host1'),
            ('media'::lock_type, '2', 3, 'host2');
EOF
run_command $phobos lock clean -i 1 --global --force

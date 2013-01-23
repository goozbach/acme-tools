#!/bin/bash 
 
## where does this script live?
## yes it is all needed to handle symlinks and multiple directories.
## sets the TOPLEVEL variable
SOURCE="${BASH_SOURCE[0]}"
TOPLEVEL="$( dirname "${SOURCE}" )"
while [ -h "${SOURCE}" ]
do 
  SOURCE="$(readlink "${SOURCE}")"
  [[ ${SOURCE} != /* ]] && SOURCE="${TOPLEVEL}/${SOURCE}"
  TOPLEVEL="$( cd -P "$( dirname "${SOURCE}"  )" && pwd )"
done
TOPLEVEL="$( cd -P "$( dirname "${SOURCE}" )" && pwd )"
 
# source functions
for i in ${TOPLEVEL}/../lib/*
do
  source $i
done

# main content of the script
echo "this is the main script"

# use the imported functions
add_on_exit "echo 'running from exit handler'"

log_info "this is a log4bats function (https://github.com/goozbach/log4bats)"

# create a tempfile
log_info "creating temp file"
TMPFILE=$(mktemp /tmp/${0##*/}-XXXXXXX)
add_on_exit 'rm -rf ${TMPFILE}'

# this command will fail thanks to stringent.sh
log_info "attempting to overwrite tmp file, this should fail"
echo "foo" > ${TMPFILE}

# you shouldn't see this command
echo "all is well"

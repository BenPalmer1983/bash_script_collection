#!/bin/bash

####################################################################################################
#
# no guarantees
# parts of these scripts may have been taken and modified from forums over the years
# always check what a script will do before running it
#
####################################################################################################

#
#  Run processes in parallel
#  Parts of this were taken from a batch processing script for TALYS
#

shopt -s nocaseglob
shopt -s nullglob
NUM=0
QUEUE=""
MAX_NPROC=6

function queue {
   QUEUE="$QUEUE $1"
   NUM=$(($NUM+1))
   echo Processing PID $1
}
#
function regeneratequeue {
   OLDREQUEUE=$QUEUE
   QUEUE=""
   NUM=0
   for PID in $OLDREQUEUE
   do
   if [ -d /proc/$PID  ] ; then
      QUEUE="$QUEUE $PID"
      NUM=$(($NUM+1))
       fi
    done
}
#
function checkqueue {
   OLDCHQUEUE=$QUEUE
    for PID in $OLDCHQUEUE
    do
   if [ ! -d /proc/$PID ] ; then
        regeneratequeue # at least one PID has finished
   break
     fi
   done
}
#
# Put file names into an array
n=0
for file in "$arg"*.{in,inp}; do
  if test -f "$file"; 
  then
    n=$(($n+1))
    file_list[$n]=$file
    echo $file
  fi
done
# loop through filenames and do something
for file in "${file_list[@]}"; do
  if test -f "$file"; 
  then
    ###################################
    # Do Something
    cmd="stat "$file" && sleep 10 && echo 'Done' > out."$file
    ###################################
    eval $cmd &
    PID=$!
    queue $PID
    while [ $NUM -ge $MAX_NPROC ]; do
      checkqueue
    done
    sleep 0.01
  fi
done














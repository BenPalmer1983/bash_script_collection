#!/bin/bash

####################################################################################################
#
# no guarantees
# parts of these scripts may have been taken and modified from forums over the years
# always check what a script will do before running it
#
####################################################################################################

#
#  Converts animated movies to x265
#


shopt -s nocaseglob

for file in "$arg"*.{mkv,mp4,m4v,mov,avi}; do

echo $file

  # Set up
  file_name=${file/[.][mM][kK][vV]/""}
  file_name=${file_name/[.][mM][pP][4]/""}
  file_name=${file_name/[.][mM][4][vV]/""}
  file_name=${file_name/[.][mM][oO][vV]/""}
  file_name=${file_name/[.][aA][vV][iI]/""}
  file_name=${file_name/[xX][2][6][4][.]/""}
  file_name=${file_name/[xX][2][6][4]/""}
  file_name=${file_name/[hH][2][6][4][.]/""}
  file_name=${file_name/[hH][2][6][4]/""}
  file_out=$file_name".enc_x265.mp4"

  if test -f "$file"; 
  then

    # Get video width
    w=$(ffprobe -v error -select_streams v:0 -show_entries stream=width -of csv=s=x:p=0 "$file")
    echo $w

    crf="19"
    speed="veryslow"

    if [[ "$w" -ge 1280 ]];
    then
      crf="22"
      speed="slower"
    fi

    if [[ "$w" -ge 1920 ]];
    then
      crf="24"
      speed="slower"
    fi

    if [[ "$w" -ge 3000 ]];
    then
      crf="27"
      speed="fast"
    fi

    echo $crf
    echo $speed


cmd="ffmpeg -y -i \""$file"\" \
-codec:v libx265 \
-preset "$speed" \
-pix_fmt yuv420p \
-movflags +faststart \
-crf "$crf" \
-x265-params profile=animation:tune=animation:min-keyint=60:subq=7:bframes=8:psy-rd=1.2:aq-mode=3:aq-strength=0.8:deblock=1,1 \
-codec:a aac \
-b:a 576k \
-ac 6 \
-f mp4 \
-threads 4 \
\""$file_out"\""
    echo $cmd
    eval $cmd

  fi
done

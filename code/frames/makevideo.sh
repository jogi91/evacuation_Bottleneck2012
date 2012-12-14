#!/bin/bash

#via http://chdk.setepontos.com/index.php?topic=5800.msg56701#msg56701

if [ -z "$1" ]; then
  echo "USAGE: $0 listfile fps type"
  echo
  echo "listfile contains filenames for input images:"
  echo "ls -1 1/*.JPG > listfile"
  echo "ls -1 2/*.JPG >> listfile"
  echo 
  echo "fps defaults to 25 frames/second"
  echo "type defaults to jpeg (png, tga, sgi also available)"
  echo
  exit 1
fi

listfile=$1

if [ -z "$2" ]; then fps=25; else fps=$2; fi
if [ -z "$3" ]; then ftype=jpeg; else ftype=$3; fi

mencoder "mf://@$listfile" -mf type="$ftype":fps=$fps -o timelapse_1080p.avi -ovc lavc -lavcopts vcodec=mpeg4:vpass=1:vbitrate=10000:autoaspect -vf scale=1200:900
mencoder "mf://@$listfile" -mf type="$ftype":fps=$fps -o timelapse_1080p.avi -ovc lavc -lavcopts vcodec=mpeg4:vpass=2:vbitrate=10000:autoaspect -vf scale=1200:900


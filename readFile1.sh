#!/bin/bash
filename="tempResults.txt"
tempFile="tempWGET.txt"
finalFile="outpus.txt"
if [ $# -ne 1 ]
then
  echo "$0 needs to a file to read the URLS"
fi

#creating necessary files
touch $filename
test -f $finalFile|| touch $finalFile

calculateAFile()
{
  wget -q $1 -O $2 #get and calculate the md5sum of each page
  if [ $? -ne 0 ]; then #if there is an error opening url
    echo $i FAILED >&2
    echo $i FAILED >> $filename
  else #if url working
    mde=($(md5sum $2))
    previousSum=($(cat $finalFile | grep $1))
    if [ "${previousSum[1]}" == "" ]; then #didn't find the that page from the previous run
      echo $i INIT
    elif [ "$md5" != "${previousSum[1]}" ]; then #the pages have changed from the previous run of the script
      echo $1
    fi
    echo $1 $md5 >> $filename
  fi
  rm -f $2
}

COUNTER=0

for i in `cat "$1" | grep "^[^#]"`; do
   calculateAFile $i $COUNTER
   ((COUNTER++))
  
done

#execute this command to send into the rubbish useless files
rm -f $finalFile
rm -f $tempFile
mv $filename $finalFile
rm -f $filename

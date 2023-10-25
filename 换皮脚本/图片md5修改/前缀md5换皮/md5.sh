#!/bin/bash
function modeMd5(){
  for file in $1/*
  do
    if [[ $file =~ " " ]]
    then
        continue
    fi
    if [ -f "$file" ]
    then
    if [[ "$file" != *.json* ]]
      then
        echo "$file"
        `echo -e -n "1" >> $file`
    fi
    else
        if [ "`ls -A $file`" != "" ]
        then
            modeMd5 "$file"
        fi
    fi
  done
}

function modiMd5(){
  for file in $1/*
  do
    if [[ $file =~ " " ]]
    then
        continue
    fi
    if [ -f "$file" ]
    then
    if [[ "$file" == *.png* || "$file" == *.mp3* || "$file" == *.svga* || "$file" == *.mp4* || "$file" == *.caf* || "$file" == *.wav* || "$file" == *.gif* || "$file" == *.jpg* || "$file" == *.ttf* || "$file" == *.otf* || "$file" == *.jpeg* || "$file" == *.Bundle* || "$file" == *.webp* ]]
      then
        echo "$file"
        chara="abcdefghijklmnopqrstuvwsyz1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        rand=`expr $RANDOM % 62`
        c=${chara:$rand:1}
        `echo -e -n $c >> $file`
    fi
    else
        if [ "`ls -A $file`" != "" ]
        then
            modiMd5 "$file"
        fi
    fi
  done
}

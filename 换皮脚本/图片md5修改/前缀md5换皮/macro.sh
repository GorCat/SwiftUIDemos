#!/bin/bash

function oper_modeCharaName(){
  for file in $1/*
  do
    # echo "$file"
    if [[ $file =~ " " ]]
    then
        continue
    fi
    if test -f $file
    then
      if [ "${file##*.}"x = "m"x ] 
      then
      array=(mcAutoNavigationBarSafeHeight mcIsIpns mcIpnsWidthScale mcWidthScale mcImageNamed mcScareNum mcHeightScareNum mcImgName mcLoadNib mcIsNilOrNull mcUserDefaultsStandard mcTextSize_MutiLine)
      for element in "${array[@]}"
        #也可以写成for element in ${array[*]}
        do
            newElement=${element/mc/kHee}
            # echo $newElement
            sed -i "" "s/$element/$newElement/g" $file
        done
      else
        echo "$file"
        continue
      fi
    else
        if [ "`ls -A $file`" != "" ]
        then
            oper_modeCharaName "$file"
        fi
    fi
  done
}

function deleteYcfile(){
     for file in $1/*
  do
    # echo "$file"
    if [[ $file =~ " " ]]
    then
        continue
    fi
    if test -f $file
    then
      if [[ "$file" =~ ^\.* ]]
      then 
        # rm $file
        echo $file
      fi
    else
        if [ "`ls -A $file`" != "" ]
        then
            deleteYcfile "$file"
        fi
    fi
  done
}

read -p "文件路径：" path
oper_modeCharaName $path
# deleteYcfile $path
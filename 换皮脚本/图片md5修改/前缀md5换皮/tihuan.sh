#!/bin/bash
function oper_modeFileName(){
  for file in $1/*
  do
#    echo "$file"
    if [[ $file =~ " " ]]
    then
        continue
    fi
    if [ -f "$file" ]
    then
    if [[ "$file" == *$2* ]] && [[ "$file" == *.h* || "$file" == *.m* || "$file" == *.swift* || "$file" == *.xib* || "$file" == *.storyboard* ]] && [[ "$file" != *.mp3* ]] && [[ "$file" != *.mp4* ]]
      then
        name=${file##*/}
        path=${file%/*}
        newName=${name/$2/$3}
        newPath=$path/$newName
#        echo "name:$name"
#        echo "path:$path"
#        echo "newName:$newName"
        echo "newPath:$newPath"
        `mv "$file" "$newPath"`
#        `rename "s/$2/$3/" "$file"`
    fi
    else
        if [ "`ls -A $file`" != "" ]
        then
            oper_modeFileName "$file" $2 $3
        fi
    fi
  done
}

function oper_modeClassName(){
    for file in $1/*
    do
      echo "$file"
      if [[ $file =~ " " ]]
      then
          continue
      fi
      if [ -f "$file" ]
      then
        if [[ "$file" == *.h* || "$file" == *.m* || "$file" == *.swift* || "$file" == *.xib* || "$file" == *.storyboard* ]] && [[ "$file" != *.mp3* ]] && [[ "$file" != *.mp4* ]]
        then
            sed -i "" "s/$2/$3/g" $file
        fi
      else
          if [ "`ls -A $file`" != "" ]
          then
              oper_modeClassName "$file" $2 $3
          fi
      fi
    done
}

function oper_modeCharaName(){
  for file in $1/*
  do
    echo "$file"
    if [[ $file =~ " " ]]
    then
        continue
    fi
    if test -f $file
    then
      sed -i "" "s/$2_/$3_/g" $file
    else
        if [ "`ls -A $file`" != "" ]
        then
            oper_modeCharaName "$file" $2 $3
        fi
    fi
  done
}

function oper_modeFolderName(){
  for file in $1/*
  do
    echo $file
    if test -d $file
    then
      mv $file ${file/$2/$3}
    fi
  done
}

function oper_findCharaAndRelaceLine(){
     for file in $1/*
      do
        echo "$file"
        if [[ $file =~ " " ]]
        then
            continue
        fi
        if test -f $file
        then
          sed -i "" "s/^[DIMTipAlert tipAlertStatus.*@\"\(.*\)\"/[[DIMNotiView shared] hee_shwoNoticeView:DIM_TipNotiType_Tip prompt:@\"\1\"];/g" $file
        else
            if [ "`ls -A $file`" != "" ]
            then
                oper_findCharaAndRelaceLine "$file" 
            fi
        fi
      done
}

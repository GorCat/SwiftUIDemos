#!/bin/bash
gaibianqian=()
gaibianhou=()
shells=()
function batchReplace_generateReplaceArByReadTxt(){
    read -p 'txt路径' path
    i=0
    for line in `cat $path`
    do
        # echo $line
        val=`expr $i % 2`
        if [ $val -eq 0 ]
        then
            gaibianqian[${#gaibianqian[@]}]=$line
        else
            gaibianhou[${#gaibianhou[@]}]=$line
        fi
        let i++
    done
    j=0
    for qian in "${gaibianqian[@]}";
    do
        hou=${gaibianhou[$j]}
        sh="sed -i '' \"s/$qian/$hou/g\""
        shells[${#shells[@]}]=$sh 
        let j++
        # echo $qian
        # echo $hou
    done
}

function batchReplace_modeFileName(){
  for file in $1/*
  do
    if [[ $file =~ " " ]]
    then
        continue
    fi
    if [ -f "$file" ]
    then
    if [[ "$file" == *.h* || "$file" == *.m* || "$file" == *.swift* || "$file" == *.xib* || "$file" == *.storyboard* || "$file" == *.strings* || "$file" == *.pch* ]] && [[ "$file" != *.mp3* ]] && [[ "$file" != *.mp4* ]]
    then
        name=${file##*/}
        sy=`batchReplace_suoyin $name`
        syar=($sy)
        echo "${syar[0]}"
        echo "${syar[1]}"

        suoy=${syar[0]}
        gaibianqianvalue=${syar[1]}
        gaibianhouvalue=${gaibianhou[$suoy]}
        path=${file%/*}
        newName=${name/$gaibianqianvalue/$gaibianhouvalue}
        newPath=$path/$newName
        echo "newPath:$newPath"
        `mv "$file" "$newPath"`
    fi
    else
        if [ "`ls -A $file`" != "" ]
        then
            batchReplace_modeFileName "$file"
        fi
    fi
  done
}

function batchReplace_suoyin(){
    i=0
    for ob in "${gaibianqian[@]}";
    do
        if [[ $1 =~ "$ob" ]]
        then
            arr=($i $ob)
            echo "${arr[@]}"
        else
            let i++
        fi
    done
}

function excuteShells(){
    shells=($2)
    # echo "${shells[*]}"
    for file in $1/*
    do
      if [[ $file =~ " " ]]
      then
          continue
      fi
      if [ -f "$file" ]
      then
        if [[ "$file" == *.h* || "$file" == *.m* || "$file" == *.swift* || "$file" == *.xib* || "$file" == *.storyboard* ]] && [[ "$file" != *.mp3* ]] && [[ "$file" != *.mp4* ]]
        then
            for i in "${shells[@]}";
            do
              shellyj=$i" "$file
              echo $shellyj
              eval $shellyj
            done;
        fi
      else
          if [ "`ls -A $file`" != "" ]
          then
              excuteShells "$file" "${shells[*]}"
          fi
      fi
    done
}

function getOCSwiftClassName(){
    for file in $1/*
    do
      if [[ $file =~ " " ]]
      then
          continue
      fi
      if [ -f "$file" ]
      then
        if [[ "$file" == *.m* || "$file" == *.swift* ]]
        then
            name=${file##*/}
            className=${name%.*}
#            if [[ "$className" == *DHQ* ]]
#            then
                echo $className
#            fi
        fi
      else
          if [ "`ls -A $file`" != "" ]
          then
              getOCSwiftClassName $file
          fi
      fi
    done
}

batchReplace_generateReplaceArByReadTxt
batchReplace_modeFileName '/Users/xuyan/Desktop/HuanPi/OWLMusicKit'

oldIFS=$IFS
IFS=$'\n'
excuteShells '/Users/xuyan/Desktop/HuanPi/OWLMusicKit' "${shells[*]}"
IFS=$oldIFS

#getOCSwiftClassName '/Users/xuyan/Desktop/HuanPi/OWLMusicKit'


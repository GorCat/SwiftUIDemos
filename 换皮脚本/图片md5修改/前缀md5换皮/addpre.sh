#!/bin/bash
##
# 方法添加前缀
###
function addpre(){
    str=`gsed -i 's/\+[ ]*\(void\)/&jt_/g' $1`
    echo "$str"
}

function oper_addpre(){
    str=`gsed -i 's/\+[ ]*\(void\)/&$2/g' $1`
}

#read -p "Folder path:" path;
#addpre "$path";

#!/bin/bash

source ./tihuan.sh
source ./md5.sh
source ./addpre.sh
function oper(){
   #  while [ $whattodo != 5 ]
   #  do
    read -p "你想干嘛？
            1、类名替换
            2、函数前缀替换
            3、函数添加前缀
            4、资源文件md5修改
            5、修改资源前缀
            6、退出
    " whattodo;
    case $whattodo in
    1) 
       echo "类名替换"
       read -p "类名旧的前缀：" oldpre
       read -p "类名新的前缀：" newpre
       read -p "类文件路径：" path
       oper_modeClassName $path $oldpre $newpre
       oper_modeFileName $path $oldpre $newpre
       ;;
    2)
       echo "函数前缀替换"
       read -p "函数名旧的前缀：" oldpre
       read -p "函数名新的前缀：" newpre
       read -p "文件路径：" path
       oper_modeCharaName $path $oldpre $newpre
       ;;
    3)
       echo "函数添加前缀"
       read -p "前缀名：" pre 
       read -p "文件路径：" path
       oper_addpre $path $pre
       ;;
    4)
       echo "资源文件md5修改"
       read -p "文件路径：" path
       modiMd5 $path
       ;;
    5)
       echo "修改资源文件前缀"
       read -p "旧的前缀：" oldpre
       read -p "新的前缀：" newpre
       read -p "文件路径：" path
       oper_modeFolderName $path $oldpre $newpre
       ;;
    esac
}
function oper_all(){
   read -p "类名旧的前缀：" oldpre
   read -p "类名新的前缀：" newpre
   read -p "函数名旧的前缀：" oldfuncpre
   read -p "函数名新的前缀：" newfuncpre
   read -p "文件路径：" path
   oper_modeFileName $path $oldpre $newpre
   oper_modeClassName $path $oldpre $newpre
   oper_modeCharaName $path $oldfuncpre $newfuncpre
   modiMd5 $path
}
oper

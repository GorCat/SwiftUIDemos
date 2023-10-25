#!/bin/bash
checkEnv() {
  $(bundle install)
}

echo 'input what you want to do'
echo '1. encrypt strings file with aes-128-cbc'
echo '2. replace prefix in directory'

read selected

case $selected in
    '1')
        echo 'enter encrypt key(16bit):'
        read key
        echo 'enter encrypt iv(16bit):'
        read iv
        echo 'start encrypt with $key $iv'
        $checkEnv
        $(ruby main.rb encrypt $key $iv)
        echo 'encrypt success'
        ;;
    '2')
        echo 'enter replace path'
        read path
        echo 'enter prefix which need to be replaced:'
        read prefix
        echo 'enter other_prefix which to replace:'
        read other_prefix
        echo "start replace prefix($prefix) with other($other_prefix) in path($path)"
        $checkEnv
        $(ruby main.rb resolve $path $prefix $other_prefix)
        echo 'end replace'
        ;;
esac
        
        

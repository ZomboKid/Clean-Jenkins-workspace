#!/bin/sh

cd /home/jenkins/workspace

IFS=$'\n'

arr=($(du -hs --time --time-style="+:%Y:%b:%d:" ./* | grep -v "@tmp" | sort -t ":" -k3M -k2 | awk -F ":" '{print $1,$4,$3,$2,$5}' | grep -v " 2019" | grep  -v -e "$(date +%d -d "yesterday") " -e "$(date +%d) "))

echo "We can delete the following folders older than 2 days:"

for (( j = 0 ; j < ${#arr[@]} ; j=$j+1 ));
do
        echo ${arr[${j}]}
done

read -r -p "Do you want to delete the specified folders? [Y/n] " input

case $input in
        [yY][eE][sS]|[yY])
                cd /home/jenkins/workspace
                for (( j = 0 ; j < ${#arr[@]} ; j=$j+1 ));
                do
                        path=($(echo "./"$(echo ${arr[${j}]} | awk -F "./" '{print $2}')))
                        echo "rm -rf $path"
                done
                unset IFS
        ;;
        [nN][oO]|[nN])
                echo "File deletion canceled"
                unset IFS
        ;;
        *)
                echo "Need to choose [Y/n]..."
                unset IFS
                exit 1
        ;;
esac

#!/bin/bash

declare options=" -A -Pn "
declare filename=""
declare threads=10

function nmap_cidr {
for line in $(cat $filename); do 
    echo "[*] Se esta Procesando El rango de Red $line" ;
    carpeta=$(echo $line  | sed 's/\//_/g' ):
    if [ ! -d "$carpeta" ]; then
        mkdir ./scan/$carpeta;
#    else
#        echo "El directorio  $carpeta ya existe";
    fi
    
    declare -a ips=$(./cidr.py $line);
    numthreads=$(ps -def |grep nmap | wc -l);

    for ip in $ips
    do
        while [ true ]; do
            numthreads=$(ps -def |grep nmap | wc -l);
            if [ $numthreads -le $threads ]; then
                echo "[*] Init scan $ip in ./scan/$carpeta/$ip.xml {$numthreads}" 
                nmap $options $ip -oA ./scan/$carpeta/$ip > /dev/null &
#                nmap $options $ip -oX ./scan/$carpeta/$ip.xml > /dev/null &
#                xsltproc ./$carpeta/$i.xml -o ./$carpeta/$i.html&
                sleep 2;
                break;
            else
                sleep 5;
	    fi
        done

    done
done
   
}

function nmap_ipList {
    for ip in $(cat $filename); do
        while [ true ];do
            num_threads=$(ps -def | grep nmap | wc -l);
            if [ $num_threads -le $threads ]; then
                echo "[*] Init scan $ip in ./scan/$ip.xml {$num_threads}" 
                nmap $options $ip -oA ./scan/$ip > /dev/null &
#                nmap $options $ip -oX ./scan/$ip.xml > /dev/null &
#                xsltproc ./$carpeta/$i.xml -o ./$carpeta/$i.html&
                sleep 2;
                break;
            else
                sleep 5
            fi
        done
    done
}


if [ -z $1 ]; then
    echo "[*] Parallel scan nmap"
    echo "[*] Usage: $0 < -iL list IPs/ -rL list Range ip >  < -t NumberTreads > \"<options nmap>\"" 
    exit
fi

if [ -f $2 ]; then
    filename="$2"
    echo "[*] Initial scanning to file $2"
else
    echo "[*] File not found $2, change file."
    exit
fi

if [ ! -d 'scan' ]; then
    mkdir scan;
    echo "[*] created directory"
fi 

if [ -z "$5" ]; then
    echo "[*] use default options nmap -A -Pn"
else
    options=$5
    echo "[*] use nmap options: nmap $options X.X.X.X -oX x.x.x.x.xml"
fi

if [ -z "$3" ]; then

    echo "[*] default number process is 10 "
    case "$1" in
        -iL)
            echo "[*] scan IP list"
            nmap_ipList
            ;;
        -rL)
            echo "[*] scan CIDR list"
            nmap_cidr
            ;;
        *)
            echo "Execute: ./nmap_cidr.sh"
            exit 1
    esac

else
    echo [*] number process is $4
    threads=$4
    case "$1" in
        -iL)
            echo "[*] scan lista of IP"
            nmap_ipList
            ;;
        -rL)
            echo "[*] scan range of IP"
            nmap_cidr
            ;;
        *)
            echo "Execute: ./nmap_cidr.sh"
            exit 1
    esac

fi



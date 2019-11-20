# nmapcidr
Used Nmap For list IP or CIDR Network notation

## USAGE:

help:
```bash
$ ./nmap_cidr.sh
```

scan ip list:
```bash
$ ./nmap_cidr.sh -iL ip_list
```
scan CIDR list: 
```bash
$ ./nmap_cidr.sh -rL range_list
```

to enable more processes, default is 10:
```bash
$ ./nmap_cidr.sh -ir/-rl <file> -t <Number Process>
$ ./nmap_cidr.sh -ir/-rl file_list -t 30
```

add new options to nmap, default is -A -Pn:
```bash
$ ./nmap_cidr.sh -ir/-rl file_list -t 30 "<options nmap>"
$ ./nmap_cidr.sh -ir/-rl file_list -t 30 "-sC -sT -p 8080" 
```

The script make a directory for CIDR network and save the xml format nmap output in one file per host of the CIDR network in this directory.

#!/bin/bash
# run then type the servername and hit enter
while read server; do 
    timeout 3 openssl s_client -connect $server:443 -no_ssl3 -no_tls1; 
    if [ $? -eq 0 ] ; then 
        echo "$server bad protocol"; 
    fi; 
    timeout 3 openssl s_client -connect $server:443 -cipher NULL,LOW; 
    if [ $? -eq 0 ] ; then 
        echo "$server bad cipher"; 
    fi;  
done

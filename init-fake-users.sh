#!/bin/bash

end=20
for i in $(seq 0 $end); 
    do
        uname="${i}_fake"
        uemail="temp+user${i}@tbs-sct.gc.ca"
        ckan user add $uname email=$uemail password=12345678
    done
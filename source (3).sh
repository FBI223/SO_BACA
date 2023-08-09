#Marcin Sztukowski
#!/bin/bash

read test

while read linia
do
    czy_exe=0
    czy_dir=0
	prawa=""
	user=0
	group=0
	others=0
    if [[ "${linia:0:1}" == "d" ]]; then
        czy_dir=1
    fi
	if [[ "${linia:1:1}" == "r" ]]; then
		user=$((user+4))
	fi
	if [[ "${linia:2:1}" == "w" ]]; then
		user=$((user+2))
	fi
	if [[ "${linia:3:1}" == "x" ]]; then
		user=$((user+1))
        czy_exe=1
	fi
	if [[ "${linia:4:1}" == "r" ]]; then
		group=$((group+4))
	fi
	if [[ "${linia:5:1}" == "w" ]]; then
		group=$((group+2))
	fi
	if [[ "${linia:6:1}" == "x" ]]; then
		group=$((group+1))
	fi
	if [[ "${linia:7:1}" == "r" ]]; then
		others=$((others+4))
	fi
	if [[ "${linia:8:1}" == "w" ]]; then
		others=$((others+2))
	fi
	if [[ "${linia:9:1}" == "x" ]]; then
		others=$((others+1))
	fi
    
    prawa="$user$group$others"
#    echo "$prawa"


    nazwa=""
    czy_p=0
    i=0
    n=${#linia}
    while [[ $i -lt $n ]]
    do
        if [[ "${linia:i:1}" == ":" ]]; then
            czy_p=1
	    i=$((i+3))
        elif [[ $czy_p -eq 1 ]]; then
            t="${linia:i:1}"
#	    echo $t
            nazwa="$nazwa$t"
        fi
        i=$((i+1))
    done
    
#    echo "$nazwa"

wynik="$nazwa"
if [[ $czy_dir -eq 1 ]]; then
    wynik="$wynik/ "
elif [[ $czy_exe -eq 1 ]]; then
    wynik="$wynik* "
else
    wynik="$wynik "
fi

wynik="$wynik$prawa"
echo "$wynik"
done

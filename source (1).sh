#Marcin Sztukowski
#!/bin/bash

arr=()
arr2=()
arr3=()
n=0

while read linia
do
	if [[ ${#linia} -ne 0 ]]; then
		j=0
		czy_k=0
		czy_z=0
		if [[ $n -eq 0 ]]; then
			czy_k=1
		fi
		while [[ $czy_k -ne 1 ]]
		do
			if [[ ${arr2[$j]} == $linia ]]; then
				czy_k=1
				czy_z=1
			else
				j=$((j+1))
				if [[ $j -ge $n ]]; then
					czy_k=1
				fi
			fi
		done

		if [[ $czy_z -eq 1 ]]; then
			temp=arr3[$j]
			temp=$((temp+1))
#			echo $temp
			arr3[$j]=$temp
		else
			arr2[$n]="$linia"
			arr3[$n]=1
			n=$((n+1))
#			echo '1'
		fi
	fi
done

kw="a"
vw=100000

i=0
while [[ $i -lt $n ]]
do
	if [[ ${arr3[$i]} -lt $vw ]]; then
		vw=${arr3[$i]}
		kw=${arr2[$i]}
	fi
	i=$((i+1))
done

if [[ $n -ne 0 ]]; then
	echo "$kw $vw"
fi

#Marcin Sztukowski
#!/bin/bash
#Marcin Sztukowski


i=0
suma=0
arr=()

while read linia
do
	
	if [[ ${#linia} -ne 0 ]]; then
	arr[$i]=$linia
	i=$((i+1))
	suma=$((suma+linia))
	fi
   
done

if [[ $i -eq 1 ]]; then
	echo "${arr[0]}"
	echo "0"

elif [[ $i -ne 0 ]]; then
	srednia=$((suma/i))
	echo $srednia
	#echo $srednia

	j=0
	wariancja=0
	#echo ""
	while [[ $j -lt $i ]]
	do
		temp=${arr[$j]}
		#echo $temp
		temp=$((temp-srednia))
		temp=$((temp*temp))
		#echo $temp
		wariancja=$((wariancja+temp))
		j=$((j+1))
	done
	#echo ""

	wariancja=$((wariancja/j))
	echo "$wariancja"
	#echo "$wariancja"
fi

	#n=$i
	#mod=$((n/2))
	#mod=$((mod*2))
	#if [[ $mod == $n ]]; then
		#t=$((n/2))
		#tt=$((t-1))
		#t=${arr[$t]}
		#tt=${arr[$tt]}
		#wynik=$((t+tt))
		#wynik=$((wynik/2))
		#echo "$wynik"
	#else
		#n=$((n/2))
		#echo "${arr[$n]}"
	#fi



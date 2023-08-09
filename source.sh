#Marcin Sztukowski
#!/bin/bash
#Marcin Sztukowski

read n
tempa=0
tempb=1

if [ $n = 1 ]; then
	echo '0'
elif [ $n = 2 ]; then
	echo '0'
	echo '1'
else

	trzy=3
	ilewykonan="$((n-trzy))"
	echo '0'
	echo '1'
	echo '1'
	i=0
	tempa=1
	tempb=1
	while [ $i -lt $ilewykonan ]
	do
		tempwynik=$((tempa+tempb))
		echo "$tempwynik"
		tempb="$tempa"
		tempa="$tempwynik"
		i=$((i+1))
	done		
	
fi

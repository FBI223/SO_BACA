#Marcin Sztukowski
#!/bin/bash
#Marcin Sztukowski


read poczatkowa_linia
len_poczatkowa="${#poczatkowa_linia}"

char_wejscie="${poczatkowa_linia:0:1}"


if [[ "$len_poczatkowa" -eq 2 ]]; then
	
	
	while read linia ; do
		wynik=0
        	len="${#linia}"
        	i=0
		while [[ "$i" -lt "$len" ]]
		do
                	char="${linia:$i:1}"
		
			if [[ "$char" == "$char_wejscie" ]]; then
				wynik=$(( wynik + 1 ))
			fi 
                	i=$((i+1))

        	done
		echo "$wynik"


	done



elif [[ "$len_poczatkowa" -eq 1 ]]; then


	wynik=0

		char_wejscie="${char_wejscie^^}"

	        while read linia ; do
		wynik=0
                len="${#linia}"
		i=0
		while [[ $i -lt $len ]]
		do
                        char="${linia:$i:1}"
			char="${char^^}"
                        if [[ "$char" == "$char_wejscie" ]]; then
                                wynik=$((wynik + 1 ))
                        fi 
			i=$((i+1))

                done
                echo "$wynik"

		done
fi

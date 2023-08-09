//Marcin Sztukowski

#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>

using namespace std;

int podziel(const char* s)
{

    int plik= open(s,O_RDONLY);
    int f1 = open("fragment1",  O_CREAT|O_WRONLY|O_TRUNC, 0777);
    int f2 = open("fragment2",  O_CREAT|O_WRONLY|O_TRUNC, 0777);


    if ( (plik==-1) || (f1 ==-1) || (f2==-1)  )
    {
        return -1;
    }

    char temp_char='\0';

    int dlg_plik = lseek(plik,0,SEEK_END);
    lseek(plik,0,SEEK_SET);

    int polowa = dlg_plik / 2 ;
    if ( (polowa*2) != dlg_plik )
    {
        polowa+=1;
    }

    int i=0;
    while ( i < polowa )
    {
        read(plik, &temp_char, sizeof(char));
        write(f1,&temp_char, sizeof(char));
        i++;
    }
    while ( i < dlg_plik )
    {
        read(plik, &temp_char, sizeof(char));
        write(f2,&temp_char, sizeof(char));
        i++;
    }


    close(plik);
    close(f1);
    close(f2);

    return 0;

}

//int main()
//{
//    podziel("C:\\Users\\msztu\\CLionProjects\\SO BACA\\6 pliki\\plik.txt");
//
//    return 0;
//}


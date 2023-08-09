--Marcin Sztukowski
--Marcin Sztukowski

with GNAT.OS_Lib;
use GNAT.OS_Lib;

package body Rozwiazanie is

  task body Synchronizator is


      type ThreadState is record
         Id: Integer := -1 ;
         Working: Boolean := False ;
         Logged: Boolean := False;
         LoggedInRound: Boolean := False;
      end record;

      type ThreadStateArray is array (Integer range <>) of ThreadState;
      ThreadList: ThreadStateArray(1..5);
      CurrentId: Integer := 1;
      CurrentRound: Integer := 1;
      n_zalogowanych: Integer := 0;
      n_zalogowanych_runda: Integer := 0;
      runda_nr: Integer := 1;

      czy_wszyscy_zalogowani: Boolean := False;

      J: Integer := 1;
      K: Integer := 1;
      temp: Integer := 1;

      temp_watek: ThreadState ;
      watek_pracowal_ostatnio: ThreadState ;

      task Muteks is
         entry Czekaj;
         entry Zwolnij;
      end Muteks;



      task body Muteks is
         Zajety : Boolean := False;
      begin
         loop
            select
               when not Zajety =>
                  accept Czekaj do
                     Zajety := True;
                  end Czekaj;
            or
               accept Zwolnij do
                  Zajety := False;
               end Zwolnij;
            or
               delay 0.001;
            end select;

         end loop;
      end Muteks;




    begin
      loop

         Muteks.Czekaj;

         select

            when not czy_wszyscy_zalogowani =>

               accept Logowanie (id: Integer) do
                  J := 1 ;
                  temp := 1;


                  while J <= 5 and temp = 1 loop
                     if ThreadList(J).Logged = False then

                        ThreadList(J).Logged := True;
                        ThreadList(J).LoggedInRound := True;
                        ThreadList(J).Id := id ;
                        ThreadList(J).Working := False ;

                        n_zalogowanych := n_zalogowanych + 1 ;
                        temp := 0;
                     end if;

                     J := J + 1 ;

                  end loop;


                  if n_zalogowanych = 5 then
                     n_zalogowanych_runda := n_zalogowanych;



                     for i in 1 .. 5 loop
                        for j in 1 .. 4 loop
                           if ThreadList(j).Id <= ThreadList(j + 1).Id then
                              temp_watek := ThreadList(j);
                              begin
                                 ThreadList(j) := ThreadList(j + 1);
                                 ThreadList(j + 1) := temp_watek;
                              end;
                           end if;
                        end loop;
                     end loop;


                     --Ada.Text_IO.Put_Line("");
                     --for i in ThreadList'Range loop
                        --Ada.Text_IO.Put_Line(Integer'Image(ThreadList(i).Id));
                     --end loop;
                     --Ada.Text_IO.Put_Line("");

                     czy_wszyscy_zalogowani := True ;

                  end if;


               end Logowanie;



         or when czy_wszyscy_zalogowani =>

               accept Koniec do

                  --Put_Line("koniec " & Integer'Image(watek_pracowal_ostatnio.Id) ) ;

                  J := 1 ;
                  while watek_pracowal_ostatnio.Id /= ThreadList(J).Id and J <= 5 loop
                     J := J + 1 ;
                  end loop;

                  ThreadList(J).Id := -100;
                  ThreadList(J).Working := False;
                  ThreadList(J).Logged := False;
                  ThreadList(J).LoggedInRound := False;

                  --Ada.Text_IO.Put_Line("");
                  --for i in ThreadList'Range loop
                     --Ada.Text_IO.Put_Line(Integer'Image(ThreadList(i).Id));
                  --end loop;
                  --Ada.Text_IO.Put_Line("");


                  temp := 0;
                  for i in 1 .. 5 loop
                     if ThreadList(i).Logged then
                        temp := temp + 1 ;
                     end if ;
                  end loop;


                  if temp = 0 then
                     GNAT.OS_Lib.OS_Exit(0);
                  end if;



               end Koniec;


         or when czy_wszyscy_zalogowani =>


               accept ChcePracowac(id: Integer; zgoda: out Boolean) do




                  -- ------------------------------------------------------------ sortuj
                  for i in 1 .. 5 loop
                     for j in 1 .. 4 loop
                        if not ThreadList(j).LoggedInRound and ThreadList(j + 1).LoggedInRound then
                           temp_watek := ThreadList(j);
                           begin
                              ThreadList(j) := ThreadList(j + 1);
                              ThreadList(j + 1) := temp_watek;
                           end;
                        end if;
                     end loop;
                  end loop;

                  J := 1;
                  temp := 0 ;

                  while J <= 5 loop
                     if ThreadList(J).LoggedInRound then
                        temp := temp + 1 ;
                        J := J+1 ;
                     else
                        exit;
                     end if ;

                  end loop;

                  if temp > 1 then

                     J := temp;
                     K := temp-1;

                     for i in 1 .. J loop
                        for j in 1 .. K loop
                           if ThreadList(j).Id <= ThreadList(j + 1).Id then
                              temp_watek := ThreadList(j);
                              begin
                                 ThreadList(j) := ThreadList(j + 1);
                                 ThreadList(j + 1) := temp_watek;
                              end;
                           end if;
                        end loop;
                     end loop;
                  end if ;

                  -- ------------------------------------------------------------ sortuj
                  -- sprawdz czy na poczatku kolejki jest interesujacy cie id , to znaczy ze mozesz wykonac taska
                  if ThreadList(1).Id = id and ThreadList(1).LoggedInRound then
                     watek_pracowal_ostatnio := ThreadList(1);
                     n_zalogowanych_runda := n_zalogowanych_runda - 1 ;
                     ThreadList(1).LoggedInRound := False;
                     ThreadList(1).Working := True;
                     zgoda := True;
                  else





                     zgoda := False;
                  end if;


               end ChcePracowac;

         or when czy_wszyscy_zalogowani =>

               accept Ponownie do
                  temp := 0;
                  for i in 1 .. 5 loop
                     if ThreadList(i).LoggedInRound then
                        temp := temp + 1 ;
                     end if ;
                  end loop;

                  if temp = 0  then
                     for i in 1 .. 5 loop
                        if ThreadList(i).Logged then
                           ThreadList(i).LoggedInRound := True ;
                        end if ;
                     end loop;

                     runda_nr := runda_nr + 1 ;

                     if runda_nr = 4 then
                        GNAT.OS_Lib.OS_Exit(0);
                     end if;

                  end if ;

               end Ponownie;



         end select;

           Muteks.Zwolnij;

      end loop;
    end Synchronizator;


end Rozwiazanie;



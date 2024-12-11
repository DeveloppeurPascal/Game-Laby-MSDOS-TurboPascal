program laby;
{
Auteur: Premartin Patrick
Date: (1.0) 27/08/1991. 28/08/1991. 29/08/1991.
      (1.1) 27/07/1992. 29/07/1992. 30/07/1992.
Langage: Turbo Pascal 6.0
But: Jeu se pilotant … la souris et au clavier: il faut prendre un objet, et se
     d‚placer sans se faire toucher par un ennemi.
}
{$m 32768, 0, 655360}

uses
    crt,
    laby_aff,
    laby_depl,
    laby_io,
    laby_mvt,
    laby_var,
    olf_software,
    u_msg,
    u_code_clavier,
    u_curseur,
    u_mouse,
    u_m_util,
    u_score;

const
     num_vers = '1.1';
     dat_vers = '07/30/1992';

var
   level_0,
   level_1,
   level_2 : p_level;   { Premier niveau de la s‚rie. }
   level : p_level;     { Niveau en cours. }
   ok : boolean;
   x_curs,
   y_curs : integer;
   i : longint;
   x,
   y : integer;
   touche : char;
   num_level,
   nb_vie : integer;

procedure aff_decor;
var
   i : integer;
begin
     hide_mouse;
     curseur_off;
     textcolor (lightgray);
     textbackground (black);
     clrscr;
     for i := 1 to 16 do
         begin
              gotoxy (i, 1);
              write (#177);
              gotoxy (i, 6);
              write (#177);
              gotoxy (i,8);
              write (#177);
         end;
     {endfor}
     for i := 1 to 8 do
         begin
              gotoxy (1, i);
              write (#177);
              gotoxy (16, i);
              write (#177);
         end;
     {endfor}
     gotoxy (3, 2);
     write ('Olf Software');
     gotoxy (5, 3);
     write (get_msg (23));
     gotoxy (6, 5);
     write ('Laby');
     gotoxy (2, 7);
     write (#232' PREPAT 08/91');
     for i := 22 to succ (22+max_larg) do
         begin
              gotoxy (i, 2);
              write (#176);
              gotoxy (i, succ (2+max_haut));
              write (#176);
         end;
     {endfor}
     for i := 2 to succ (2+max_haut) do
         begin
              gotoxy (22, i);
              write (#176);
              gotoxy (succ (22+max_larg), i);
              write (#176);
         end;
     {endfor}
     for i := 9 to 12 do
         begin
              gotoxy (2, i);
              case i of
                   9  : write (get_msg (24));
                   10 : write (get_msg (25));
                   11 : write ('');
                   12 : write (get_msg (26));
              end;
         end;
     {endfor}
     show_mouse;
     curseur_off;
end; { aff_decor }

procedure new_level (n_level, level : p_level);
var
   i : byte;
begin
     init_mvt;
     if (level <> nil)
     then
         if (n_level <> nil)
         then
             begin
                  move (n_level^, level^, sizeof (level^));
                  if laby_test (level)
                  then
                      begin
                           if (level^.exit_key.activ)
                           then
                               level^.exit_door.activ := false;
                           {endif}
                           aff_tableau (level);
                      end
                  else
                      begin
                           alert (get_msg (27), al_error);
                           ok := false;
                      end;
                  {endif}
             end
         else
             begin
                  n_level := level_1;
                  while (n_level^.previous <> nil) do
                        n_level := n_level^.previous;
                  {endwhile}
                  new_level (n_level, level);
             end;
     {endif}
     x_curs := 1;
     y_curs := 1;
     level_0 := n_level;
     for i := 1 to nb_max_door do
       if ((level^.door [i].x <> 0) or (level^.door [i].y <> 0))
       then
         case level^.door [i].sens of
           horiz :
             begin
                level^.decor [level^.door [i].x, pred (level^.door [i].y)] := 0;
                level^.decor [pred (level^.door [i].x), level^.door [i].y] := 100+i;
                level^.decor [level^.door [i].x, level^.door [i].y] := 100;
                level^.decor [succ (level^.door [i].x), level^.door [i].y] := 100+i;
                level^.decor [level^.door [i].x, succ (level^.door [i].y)] := 0;
             end;
           verti :
             begin
                level^.decor [level^.door [i].x, pred (level^.door [i].y)] := 100+i;
                level^.decor [pred (level^.door [i].x), level^.door [i].y] := 0;
                level^.decor [level^.door [i].x, level^.door [i].y] := 100;
                level^.decor [succ (level^.door [i].x), level^.door [i].y] := 0;
                level^.decor [level^.door [i].x, succ (level^.door [i].y)] := 100+i;
             end;
         end;
       {endif}
     {endfor}
end; { New_Level }

procedure restart_prog (level_1, level : p_level);
begin
     score := 0;
     num_level := 1;
     nb_vie := 5;
     aff_decor;
     aff_nb_vie (nb_vie);
     aff_num_level (num_level);
     aff_score (score);
     new_level (level_1, level);
     alert (get_msg (28), al_wait);
     show_mouse;
     curseur_off;
end; { Restart_Prog }

begin
     init_licence ('gamelaby');
     init_olf_message (mess_shareware);
     init_olf_software ('Laby '+num_vers, #155' PREPAT '+dat_vers);
     init_score ('LABY');
     laby_fich_name := c_laby_name;
     init_io;
     init_aff (23, 3);
     init_level (level_1, nil, 0, nil);
     init_level (level, nil, 0, nil);
     ok := ((level_1 <> nil) and (level <> nil));
     load_level (level_1);
     restart_prog (level_1, level);
     while ok do
       begin
         show_mouse;
         for i := 1 to delai_attente do
           begin
           end;
         {endfor}
         clic (x_curs, y_curs, x, y);
         clic_clavier (x_curs, y_curs, touche);
         if (joystick)
         then
           clic_joystick (x_curs, y_curs, touche);
         {endif}
         hide_mouse;
         aff_curseur (x_curs, y_curs, level);
         if ((x < 22) and (y > 8) and (y < 24))
         then
           case y of
             9 : ok := not confirm (get_msg (29));
             10 : if confirm (get_msg (30))
                  then
                    restart_prog (level_1, level);
                  {endif}
             12 : begin
                    level_2 := level_1;
                    laby_load (level_1);
                    if (level_2 <> level_1)
                    then
                      restart_prog (level_1, level);
                    {endif}
             end;
           end
         else
           if ((((x = x_curs+depl_x) and (y = y_curs+depl_y)) or (touche = ' '))
             and (x_curs > 0) and (y_curs > 0) and (x_curs <= max_larg) and (y_curs <= max_haut))
           then
             begin
               level^.player.dx := x_curs;
               level^.player.dy := y_curs;
             end;
           {endif}
         {endif}
         if (touche <> carac_nul)
         then
           case touche of
             touche_escape : ok := not confirm (get_msg (29));
             touche_f1 : if confirm (get_msg (30))
                         then
                           restart_prog (level_1, level);
                         {endif}
             touche_f3 : begin
                           level_2 := level_1;
                           laby_load (level_1);
                           if (level_1 <> level_2)
                           then
                             restart_prog (level_1, level);
                           {endif}
             end;
             '+' : delai_attente := max (0, delai_attente - 100);
             '-' : delai_attente := min (10000, delai_attente + 100);
             touche_page_up : delai_attente := max (0, delai_attente - 1000);
             touche_page_dn : delai_attente := min (10000, delai_attente + 1000);
             'P', 'p' :
               begin
                 while keypressed do
                   touche := readkey;
                 {endwhile}
                 repeat
                 until (upcase (readkey) = 'P');
                 while keypressed do
                   touche := readkey;
                 {endwhile}
                 touche := carac_nul;
               end;
           end;
         {endif}
         gere_mouvements (level);
         if dec_life
         then
           begin { moins_une_vie }
             dec_life := false;
             dec (nb_vie);
             aff_nb_vie (nb_vie);
             if (nb_vie < 1)
             then
               begin
                 alert (get_msg (31), al_ok);
                 textcolor (lightgray);
                 textbackground (black);
                 clrscr;
                 nouveau_score (score, -1);
                 affichage_score;
                 if confirm (get_msg (32))
                 then
                   sauve_score ('LABY');
                 {endif}
                 if confirm (get_msg (33))
                 then
                   restart_prog (level_1, level)
                 else
                   ok := false;
                 {endif}
               end
             else
               begin
                 alert (get_msg (34), al_ok);
                 new_level (level_0, level);
                 alert (get_msg (28), al_wait);
               end;
             {endif}
           end
         else
           if fin_part
           then
             begin
               fin_part := false;
               inc (score, 5*num_level);
               aff_score (score);
               inc (num_level);
               aff_num_level (num_level);
               alert (get_msg (35), al_ok);
               new_level (level^.next, level);
             end;
           {endif}
         {endif}
         ok := (ok and (level <> nil));
       end;
     {endwhile}
     clear_level (level_1);
     del_level (level);
     textcolor (lightgray);
     textbackground (black);
     hide_mouse;
     clrscr;
     writeln (get_msg (36));
     curseur_on;
end.

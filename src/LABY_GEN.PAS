program laby_gen;
{
Auteur: Pr‚martin Patrick.
Date: (1.0) 15/08/1991. 19/08/1991. 23/08/1991. 26/08/1991. 27/08/1991.
            28/08/1991. 29/08/1991.
      (1.1) 27/07/1992. 30/07/1992.
Langage: Turbo Pascal 6.0
But: G‚n‚rateur de d‚cors pour le jeu Laby.
}
{$m 32768, 0, 655360}

uses
    crt,
    laby_aff,
    laby_depl,
    laby_io,
    laby_var,
    olf_software,
    u_msg,
    u_code_clavier,
    u_curseur,
    u_m_util,
    u_mouse;

const
     num_vers : string [3] = '1.1';
     dat_vers : string [10] = '07/30/1992';

procedure aff_decor (num_opt : integer);
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
     gotoxy (2, 5);
     write ('Laby Generator');
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
     for i := 9 to 23 do
         begin
              gotoxy (2, i);
              case i of
                   9  : write (get_msg (24));
                   10 : write (get_msg (37));
                   11 : write (get_msg (38));
                   12 : write (get_msg (26));
                   13 : write (get_msg (39));
                   14 : write (get_msg (40));
                   15 : write ('');
                   16 : write (get_msg (41));
                   17 : write (get_msg (42));
                   18 : write (get_msg (43));
                   19 : write (get_msg (44));
                   20 : write (get_msg (45));
                   21 : write (get_msg (46));
                   22 : write (get_msg (47));
                   23 : write (get_msg (48));
              end;
         end;
     {endfor}
     if ((num_opt >=0) and (num_opt <= 7))
     then
         begin
              gotoxy (1, num_opt + 16);
              write ('#');
         end;
     {endif}
     show_mouse;
     curseur_on;
end; { aff_decor }

procedure un_activ (x, y : integer; level : p_level; num_opt : integer);
var
   i,
   j,
   k : integer;
begin
     if (level^.decor [x, y] <> num_opt)
     then
         case (level^.decor [x, y]) of
              2 : begin
                       level^.player.x := 0;
                       level^.player.y := 0;
              end;
              4 : begin
                       level^.exit_door.x := 0;
                       level^.exit_door.y := 0;
                       level^.exit_door.activ := false;
              end;
              5 : begin
                       level^.exit_key.x := 0;
                       level^.exit_key.y := 0;
                       level^.exit_key.activ := false;
              end;
              100..100+nb_max_door : begin
                                          if (level^.decor [x, y] > 100)
                                          then
                                              i := level^.decor [x, y]-100
                                          else
                                              i := level^.decor [succ (x), y]- 100;
                                          {endif}
                                          textcolor (lightgray);
                                          textbackground (black);
                                          j := level^.door [i].x;
                                          k := level^.door [i].y;
                                          aff_nothing (j, pred (k));
                                          level^.decor [j, pred (k)] := 0;
                                          aff_nothing (pred (j), k);
                                          level^.decor [pred (j), k] := 0;
                                          aff_nothing (j, k);
                                          level^.decor [j, k] := 0;
                                          aff_nothing (succ (j), k);
                                          level^.decor [succ (j), k] := 0;
                                          aff_nothing (j, succ (k));
                                          level^.decor [j, succ (k)] := 0;
                                          for j := 1 to nb_max_door do
                                              begin
                                                   if (level^.door [j].liaison = i)
                                                   then
                                                       level^.door [j].liaison := level^.door [i].liaison;
                                                   {endif}
                                                   if (level^.door [j].liaison = j)
                                                   then
                                                       level^.door [j].liaison := 0;
                                                   {endif}
                                              end;
                                          {endfor}
                                          level^.door [i].x := 0;
                                          level^.door [i].y := 0;
              end;
              201..200+nb_max_enemy : begin
                                           i := level^.decor [x, y]-200;
                                           textcolor (lightgray);
                                           textbackground (black);
                                           level^.enemy [i].x := 0;
                                           level^.enemy [i].y := 0;
              end;
         end;
     {endif}
end; { un_activ }

procedure delete_case (x, y : integer; level : p_level);
begin
     if (level <> nil)
     then
         begin
              un_activ (x, y, level, 0);
              level^.decor [x, y] := 0;
              aff_nothing (x, y);
         end;
     {endif}
end; { delete_case }

procedure put_block (x, y : integer; level : p_level);
begin
     if (level <> nil)
     then
         begin
              un_activ (x, y, level, 1);
              level^.decor [x, y] := 1;
              aff_block (x, y);
         end;
     {endif}
end; { put_block }

procedure put_player (x, y : integer; level : p_level);
begin
     if (level <> nil)
     then
         begin
              un_activ (x, y, level, 2);
              if ((level^.player.x > 0) or (level^.player.y > 0))
              then
                  delete_case (level^.player.x, level^.player.y, level);
              {endif}
              level^.player.x := x;
              level^.player.y := y;
              level^.player.dx := x;
              level^.player.dy := y;
              level^.decor [x, y] := 2;
              aff_player (level^.player);
         end;
     {endif}
end; { put_player }

procedure put_enemy (x, y : integer; level : p_level);
var
   i,
   num_enemy : integer;
begin
     if (level <> nil)
     then
         begin
              if ((level^.decor [x, y] > 200) and (level^.decor [x, y] <= 200+nb_max_enemy))
              then
                  num_enemy := level^.decor [x, y] -200
              else
                  begin
                       num_enemy := 0;
                       for i := nb_max_enemy downto 1 do
                           if ((level^.enemy [i].x = 0) and (level^.enemy [i].y = 0))
                           then
                               num_enemy := i;
                           {endif}
                       {endfor}
                  end;
              {endif}
              if (num_enemy > 0)
              then
                  begin
                       if (num_enemy+200 = level^.decor [x, y])
                       then
                           case (level^.enemy [num_enemy].dir_typ) of
                                left : level^.enemy [num_enemy].dir_typ := right;
                                right : level^.enemy [num_enemy].dir_typ := g_player;
                                g_player : level^.enemy [num_enemy].dir_typ := left;
                           end
                       else
                           begin
                                un_activ (x, y, level, 200+num_enemy);
                                level^.decor [x, y] := 200+num_enemy;
                                level^.enemy [num_enemy].x := x;
                                level^.enemy [num_enemy].y := y;
                           end;
                       {endif}
                       aff_enemy (level^.enemy [num_enemy]);
                       textcolor (lightgray);
                       textbackground (black);
                       gotoxy (depl_x+max_larg +2, 2);
                       clreol;
                       write (get_msg (49),' ', num_enemy, ' ', get_msg (50));
                       gotoxy (depl_x+max_larg +2, 3);
                       clreol;
                       case (level^.enemy [num_enemy].dir_typ) of
                            left : write (get_msg (51));
                            right : write (get_msg (52));
                            g_player : write (get_msg (20));
                       end;
                  end;
              {endif}
         end;
     {endif}
end; { put_enemy }

procedure put_door (x, y : integer; level : p_level);
var
   i,
   num_door : integer;
begin
     if ((level <> nil) and (x > 2) and (y > 2) and (x < max_larg -1) and (y < max_haut -1))
     then
         begin
              if ((level^.decor [x, y] > 100) and (level^.decor [x, y] <= 100+nb_max_door))
              then
                  num_door := level^.decor [x, y]- 100
              else
                  if (level^.decor [x, y] = 100)
                  then
                      num_door := level^.decor [succ (x), y]- 100
                  else
                      begin
                           num_door := 0;
                           for i := nb_max_door downto 1 do
                               if ((level^.door [i].x = 0) and (level^.door [i].y = 0))
                               then
                                   num_door := i;
                               {endif}
                           {endfor}
                      end;
                  {endif}
              {endif}
              if (num_door > 0)
              then
                  begin
                       if ((num_door +100 = level^.decor [x, y]) or (level^.decor [x, y] = 100))
                       then
                           case (level^.door [num_door].sens) of
                                horiz : level^.door [num_door].sens := verti;
                                verti : level^.door [num_door].sens := horiz;
                           end
                       else
                           begin
                                un_activ (x, pred (y), level, 100+num_door);
                                level^.decor [x, pred (y)] := 100+num_door;
                                un_activ (pred (x), y, level, 100+num_door);
                                level^.decor [pred (x), y] := 100+num_door;
                                un_activ (x, y, level, 100);
                                level^.decor [x, y] := 100;
                                un_activ (succ (x), y, level, 100+num_door);
                                level^.decor [succ (x), y] := 100+num_door;
                                un_activ (x, succ (y), level, 100+num_door);
                                level^.decor [x, succ (y)] := 100+num_door;
                                level^.door [num_door].x := x;
                                level^.door [num_door].y := y;
                           end;
                       {endif}
                       aff_door (level^.door [num_door]);
                  end;
              {endif}
         end;
     {endif}
end; { Put_Door }

procedure put_exit_key (x, y : integer; level : p_level);
begin
     if (level <> nil)
     then
         begin
              un_activ (x, y, level, 5);
              if ((level^.exit_key.x > 0) or (level^.exit_key.y > 0))
              then
                  delete_case (level^.exit_key.x, level^.exit_key.y, level);
              {endif}
              level^.exit_key.x := x;
              level^.exit_key.y := y;
              level^.exit_key.activ := true;
              level^.decor [x, y] := 5;
              aff_exit_key (level^.exit_key);
         end;
     {endif}
end; { Put_Exit_Key }

procedure put_exit_door (x, y : integer; level : p_level);
begin
     if (level <> nil)
     then
         begin
              un_activ (x, y, level, 4);
              if ((level^.exit_door.x > 0) or (level^.exit_door.y > 0))
              then
                  delete_case (level^.exit_door.x, level^.exit_door.y, level);
              {endif}
              level^.exit_door.x := x;
              level^.exit_door.y := y;
              level^.exit_door.activ := true;
              level^.decor [x, y] := 4;
              aff_exit_door (level^.exit_door);
         end;
     {endif}
end; { Put_Exit_Door }

procedure put_bonus (x, y : integer; level : p_level);
var
   old_case : byte;
begin
     if (level <> nil)
     then
         begin
              old_case := level^.decor [x, y];
              un_activ (x, y, level, 0);
              if ((old_case > 50) and (old_case < nb_max_bonus+50))
              then
                  inc (old_case)
              else
                  old_case := 51;
              {endif}
              level^.decor [x, y] := old_case;
              aff_bonus (x, y, level^.decor [x, y]);
         end;
     {endif}
end; { Put_Bonus }

var
   level_1 : p_level;
   level : p_level;
   num_level : integer;
   ok : boolean;
   x_curs,
   y_curs : integer;
   x,
   y : integer;
   num_opt : integer;
   touche : char;

begin
     init_licence ('gamelaby');
     init_olf_message (mess_shareware);
     init_olf_software ('Laby Generator '+num_vers, #155' PREPAT '+dat_vers);
     init_io;
     num_level := 1;
     init_level (level_1, nil, num_level, nil);
     ok := (level_1 <> nil);
     level := level_1;
     if (laby_fich_name <> '')
     then
         laby_load (level_1);
     {endif}
     x_curs := 1;
     y_curs := 1;
     num_opt := 0;
     init_aff (23, 3);
     aff_decor (num_opt);
     aff_tableau (level);
     show_mouse;
     curseur_off;
     while ok do
           begin
                show_mouse;
                clic (x_curs, y_curs, x, y);
                clic_clavier (x_curs, y_curs, touche);
                aff_curseur (x_curs, y_curs, level);
                if ((x < 22) and (y > 8) and (y < 24))
                then
                    case y of
                         9 : ok := not confirm (get_msg (53));
                         10 : begin
                                   laby_clear (level_1);
                                   level := level_1;
                                   aff_tableau (level);
                         end;
                         11 : laby_save (level_1);
                         12 : begin
                                   laby_load (level_1);
                                   level := level_1;
                                   aff_tableau (level);
                         end;
                         13 : if laby_test (level)
                              then
                                  begin
                                       if (level^.next = nil)
                                       then
                                           init_level (level^.next, level, succ (level^.current), nil);
                                       {endif}
                                       if (level^.next <> nil)
                                       then
                                           begin
                                                level := level^.next;
                                                aff_tableau (level);
                                           end;
                                       {endif}
                                  end;
                              {endif}
                         14 : if (level^.previous <> nil)
                              then
                                  begin
                                       level := level^.previous;
                                       aff_tableau (level);
                                  end;
                              {endif}
                         16..23 : begin
                                       textcolor (lightgray);
                                       textbackground (black);
                                       gotoxy (1, num_opt+16);
                                       write (' ');
                                       num_opt := y-16;
                                       gotoxy (1, num_opt+16);
                                       write ('#');
                         end;
                    end
                else
                    if ((((x = x_curs+depl_x) and (y = y_curs+depl_y)) or (touche = ' '))
                       and (x_curs > 1) and (y_curs > 1) and (x_curs < max_larg) and (y_curs < max_haut))
                    then
                        begin
                             hide_mouse;
                             case num_opt of
                                  0 : put_block (x_curs, y_curs, level);
                                  1 : put_player (x_curs, y_curs, level);
                                  2 : put_enemy (x_curs, y_curs, level);
                                  3 : put_door (x_curs, y_curs, level);
                                  4 : put_exit_key (x_curs, y_curs, level);
                                  5 : put_exit_door (x_curs, y_curs, level);
                                  6 : delete_case (x_curs, y_curs, level);
                                  7 : put_bonus (x_curs, y_curs, level);
                             end;
                        end;
                    {endif}
                {endif}
                if (touche <> carac_nul)
                then
                    begin
                         case touche of
                              touche_escape : ok := not confirm (get_msg (53));
                              touche_f1 : begin
                                               laby_clear (level_1);
                                               level := level_1;
                                               aff_tableau (level);
                              end;
                              touche_f2 : laby_save (level_1);
                              touche_f3 : begin
                                               laby_load (level_1);
                                               level := level_1;
                                               aff_tableau (level);
                              end;
                              touche_f4 : if laby_test (level)
                                          then
                                              begin
                                                   if (level^.next = nil)
                                                   then
                                                       init_level (level^.next, level, succ (level^.current), nil);
                                                   {endif}
                                                   if (level^.next <> nil)
                                                   then
                                                       begin
                                                            level := level^.next;
                                                            aff_tableau (level);
                                                       end;
                                                   {endif}
                                              end;
                                          {endif}
                              touche_f5 : if (level^.previous <> nil)
                                          then
                                              begin
                                                   level := level^.previous;
                                                   aff_tableau (level);
                                              end;
                                          {endif}
                              '0'..'7' : begin
                                              textcolor (lightgray);
                                              textbackground (black);
                                              gotoxy (1, num_opt+16);
                                              write (' ');
                                              num_opt := (ord (touche) - ord ('0'));
                                              gotoxy (1, num_opt+16);
                                              write ('#');
                              end;
                         end;
                    end;
                {endif}
           end;
     {endwhile}
     clear_level (level_1);
     textcolor (lightgray);
     textbackground (black);
     hide_mouse;
     clrscr;
     writeln (get_msg (36));
     show_mouse;
     curseur_on;
end.

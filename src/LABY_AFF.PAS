unit laby_aff;
{
Auteur: Premartin Patrick.
Date: 19/08/1991. 23/08/1991. 26/08/1991. 28/08/1991. 29/08/1991. 27/07/1992.
      30/07/1992.
Langage: Turbo Pascal 6.0
But: Affichage de l'‚cran de jeu et des divers objets en d‚placement.
}
interface
uses
    laby_var;

procedure init_aff (dx, dy : integer);
procedure aff_curseur (x, y : integer; level : p_level);
procedure aff_nothing (x, y : integer);
procedure aff_block (x, y : integer);
procedure aff_door (door : t_door);
procedure aff_enemy (enemy : t_enemy);
procedure aff_player (player : t_player);
procedure aff_exit_key (exit_key : t_exit_key);
procedure aff_exit_door (exit_door : t_exit_door);
procedure aff_tableau (level : p_level);
procedure aff_nb_vie (i : integer);
procedure aff_score (i : longint);
procedure aff_num_level (i : integer);
procedure aff_bonus (x, y, num_bonus : integer);

implementation
uses
    u_mouse,
    u_msg,
    crt;

var
   old_x,
   old_y : integer;

procedure writexy (x, y : integer; ch : string);
begin
     if ((x > 0) and (y > 0))
     then
         begin
              gotoxy (depl_x+x, depl_y+y);
              write (ch);
         end;
     {endif}
end; { writexy }

procedure init_aff (dx, dy : integer);
begin
     depl_x := pred (dx);
     depl_y := pred (dy);
end; { Init_Aff }

procedure eff_curseur (x, y : integer; level : p_level);
begin
     if ((x > 0) and (y > 0))
     then
         case (level^.decor [x, y]) of
              1 : aff_block (x, y);
              2 : aff_player (level^.player);
              4 : aff_exit_door (level^.exit_door);
              5 : aff_exit_key (level^.exit_key);
              51..50+nb_max_bonus : aff_bonus (x, y, level^.decor [x, y]);
              100 : if (level^.decor [succ (x), y] > 100)
                    then
                        aff_door (level^.door [level^.decor [succ (x), y] -100])
                    else
                        aff_door (level^.door [level^.decor [x, succ (y)] -100]);
                    {endif}
              101..100+nb_max_door : aff_door (level^.door [level^.decor [x, y] -100]);
              201..200+nb_max_enemy : aff_enemy (level^.enemy [level^.decor [x, y] -200]);
         else
             aff_nothing (x, y);
         end;
     {endif}
end; { Eff_Curseur }

procedure aff_curseur (x, y : integer; level : p_level);
begin
     if ((x <> old_x) or (y <> old_y))
     then
         eff_curseur (old_x, old_y, level);
     {endif}
     textcolor (lightgray);
     textbackground (black);
     gotoxy (x+depl_x, y+depl_y);
     write (#176);
     old_x := x;
     old_y := y;
end; { aff_curseur }

procedure aff_nothing (x, y : integer);
begin
     textcolor (lightgray);
     textbackground (black);
     writexy (x, y, ' ');
end; { aff_nothing }

procedure aff_block (x, y : integer);
begin
     textcolor (lightgray);
     textbackground (black);
     writexy (x, y, #219);
end; { aff_block }

procedure aff_door (door : t_door);
begin
     if ((door.x > 2) and (door.y > 2))
     then
         begin
              textcolor (yellow);
              textbackground (black);
              case (door.sens) of
                   horiz : begin
                                writexy (door.x, pred (door.y), ' ');
                                writexy (pred (door.x), door.y, #196#196#196);
                                writexy (door.x, succ (door.y), ' ');
                   end;
                   verti : begin
                                writexy (door.x, pred (door.y), #179);
                                writexy (pred (door.x), door.y, ' '#179' ');
                                writexy (door.x, succ (door.y), #179);
                   end;
              end;
         end;
     {endif}
end; { aff_door }

procedure aff_enemy (enemy : t_enemy);
begin
     textcolor (lightblue);
     textbackground (black);
     case (enemy.dx) of
          -1 : writexy (enemy.x, enemy.y, #17);
          +1 : writexy (enemy.x, enemy.y, #16);
          0 : case (enemy.dy) of
                   -1 : writexy (enemy.x, enemy.y, #30);
                   +1 : writexy (enemy.x, enemy.y, #31);
                   0 : writexy (enemy.x, enemy.y, #22);
          end;
     end;
end; { aff_enemy }

procedure aff_player (player : t_player);
begin
     textcolor (white);
     textbackground (black);
     writexy (player.x, player.y, #1);
end; { aff_player }

procedure aff_exit_key (exit_key : t_exit_key);
begin
     textcolor (white+blink);
     textbackground (black);
     if (exit_key.activ)
     then
         writexy (exit_key.x, exit_key.y, #11)
     else
         writexy (exit_key.x, exit_key.y, ' ');
     {endif}
end; { aff_exit_key }

procedure aff_exit_door (exit_door : t_exit_door);
begin
     textcolor (white+blink);
     textbackground (black);
     if (exit_door.activ)
     then
         writexy (exit_door.x, exit_door.y, #12)
     else
         writexy (exit_door.x, exit_door.y, ' ');
     {endif}
end; { aff_exit_door }

procedure aff_tableau (level : p_level);
var
   i,
   j : integer;
begin
     hide_mouse;
     if (level <> nil)
     then
         begin
              for i := 1 to max_larg do
                  for j := 1 to max_haut do
                      begin
                           case level^.decor [i, j] of
                                1 : aff_block (i, j);
                                51..50+nb_max_bonus : aff_bonus (i, j, level^.decor [i, j]);
                           else
                               aff_nothing (i, j);
                           end;
                      end;
                  {endfor}
              {endfor}
              aff_exit_key (level^.exit_key);
              aff_exit_door (level^.exit_door);
              for i := 1 to nb_max_door do
                  aff_door (level^.door [i]);
              {endfor}
              for i := 1 to nb_max_enemy do
                  aff_enemy (level^.enemy [i]);
              {endfor}
              aff_player (level^.player);
         end;
     {endif}
     show_mouse;
end; { Aff_Tableau }

procedure aff_nb_vie (i : integer);
begin
     textcolor (lightgray);
     textbackground (black);
     gotoxy (depl_x+ max_larg+ 5, 8);
     write (get_msg (20));
     textcolor (white);
     gotoxy (depl_x+ max_larg+ 5, 9);
     write (i : 6);
end; { Aff_Nb_Vie }

procedure aff_score (i : longint);
begin
     textcolor (lightgray);
     textbackground (black);
     gotoxy (depl_x+ max_larg+ 5, 5);
     write (get_msg (21));
     textcolor (white);
     gotoxy (depl_x+ max_larg+ 5, 6);
     write (i : 6);
end; { Aff_Score }

procedure aff_num_level (i : integer);
begin
     textcolor (lightgray);
     textbackground (black);
     gotoxy (depl_x+ max_larg+ 5, 2);
     write (get_msg (22));
     textcolor (white);
     gotoxy (depl_x+ max_larg+ 5, 3);
     write (i : 6);
end; { Aff_Num_Level }

procedure aff_bonus (x, y, num_bonus : integer);
begin
     textcolor (red);
     textbackground (blue);
     writexy (x, y, ch_bonus [num_bonus -50]);
end; { aff_bonus }

begin
     old_x := 0;
     old_y := 0;
end. { Fin de l'unit‚ 'Laby_Aff'. }

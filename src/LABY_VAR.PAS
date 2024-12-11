unit laby_var;
{
Auteur: Pr‚martin Patrick.
Date: 19/08/1991.
      23/08/1991.
      26/08/1991.
      27/08/1991.
      28/08/1991.
      29/08/1991.
      09/09/1991.
      29/07/1992.
Langage: Turbo Pascal 6.0
But: D‚clarations utilis‚es par le jeu Laby (et Laby Generator).
}
interface
const
     nb_max_door = 10;
     nb_max_enemy = 10;
     max_larg = 40;
     max_haut = 20;
     scr_exit_key = 50;
     scr_exit_door = 100;

     nb_max_bonus = 19;
     ch_bonus : string [nb_max_bonus] = #176#177#178#224#225#226#227#228#229#229#230#231#232#233#234#235#236#237#238;

type
    t_sens = (horiz, verti);
    t_door = record
                  x, y : integer;
                  sens : t_sens;
                  liaison : integer;
    end;
    t_tab_door = array [1..nb_max_door] of t_door;

    t_dir_typ = (left, right, g_player);
    t_enemy = record
                   x, y : integer;
                   dx, dy : integer;
                   dir_typ : t_dir_typ;
    end;
    t_tab_enemy = array [1..nb_max_enemy] of t_enemy;

    t_player = record
                     x, y : integer;
                     dx, dy : integer;
    end;

    t_exit_key = record
                       x, y : integer;
                       activ : boolean;
    end;

    t_exit_door = record
                        x, y : integer;
                        activ : boolean;
    end;

    t_case = byte;
    t_decor = array [0..max_larg, 0..max_haut] of t_case;
            { Code des cases du d‚cor:
                   0 - rien
                   1 - mur
                   2 - joueur
                   4 - porte de sortie
                   5 - cle de la porte de sortie
                   51..50+nb_max_bonus - bonus divers
                   100..100+nb_max_door - portes
                   201..200+nb_max_enemy - ennemis
            }

    p_level = ^t_level;
    t_level = record
                    door : t_tab_door;
                    enemy : t_tab_enemy;
                    player : t_player;
                    exit_key : t_exit_key;
                    exit_door : t_exit_door;
                    decor : t_decor;
                    previous : p_level;
                    current : integer;
                    next : p_level;
    end;

var
   depl_x,
   depl_y : integer;
   delai_attente : longint;
   joystick : boolean;

procedure init_level (var level : p_level; previous : p_level; current : integer; next : p_level);
procedure del_level (var level : p_level);

function min (a, b : integer) : integer;
function max (a, b : integer) : integer;

implementation
function min (a, b : integer) : integer;
begin
  if (a < b)
  then
      min := a
  else
      min := b;
  {endif}
end; { min }

function max (a, b : integer) : integer;
begin
     if (a > b)
     then max := a
     else max := b;
     {endif}
end; { max }

procedure init_decor (var decor : t_decor);
var
   i,
   j : integer;
begin
     for i := 2 to pred (max_larg) do
         for j := 2 to pred (max_haut) do
             decor [i, j] := 0;
         {endfor}
     {endfor}
     for i := 1 to max_larg do
         begin
              decor [i, 1] := 1;
              decor [i, max_haut] := 1;
         end;
     {endfor}
     for j := 1 to max_haut do
         begin
              decor [1, j] := 1;
              decor [max_larg, j] := 1;
         end;
     {endfor}
end; { init_decor }

procedure init_exit_door (var exit_door : t_exit_door);
begin
     with exit_door do
          begin
               x := 0;
               y := 0;
               activ := false;
          end;
     {endwith}
end; { init_exit_door }

procedure init_exit_key (var exit_key : t_exit_key);
begin
     with exit_key do
          begin
               x := 0;
               y := 0;
               activ := false;
          end;
     {endwith}
end; { init_exit_key }

procedure init_player (var player : t_player);
begin
     with player do
          begin
               x := 0;
               y := 0;
               dx := 0;
               dy := 0;
          end;
     {endwith}
end; { init_player }

procedure init_enemy (var enemy : t_enemy);
begin
     with enemy do
          begin
               x := 0;
               y := 0;
               dx := 0;
               dy := 0;
               dir_typ := left;
          end;
     {endwith}
end; { init_enemy }

procedure init_tab_enemy (var tab_enemy : t_tab_enemy);
var
   i : integer;
begin
     for i := 1 to nb_max_enemy do
         init_enemy (tab_enemy [i]);
     {endfor}
end; { init_tab_enemy }

procedure init_door (var door : t_door);
begin
     with door do
          begin
               x := 0;
               y := 0;
               sens := horiz;
               liaison := 0;
          end;
     {endwith}
end; { init_door }

procedure init_tab_door (var tab_door : t_tab_door);
var
   i : integer;
begin
     for i := 1 to nb_max_door do
         init_door (tab_door [i]);
     {endfor}
end; { init_tab_door }

procedure init_level (var level : p_level; previous : p_level; current : integer; next : p_level);
var
   niv : integer;
begin
     new (level);
     if (level <> nil)
     then
         begin
              level^.previous := previous;
              level^.current := current;
              level^.next := next;
              for niv := 0 to 5 do
                  case niv of
                       0 : init_decor (level^.decor);
                       1 : init_exit_door (level^.exit_door);
                       2 : init_exit_key (level^.exit_key);
                       3 : init_player (level^.player);
                       4 : init_tab_enemy (level^.enemy);
                       5 : init_tab_door (level^.door);
                  end;
              {endfor}
         end;
     {endif}
end; { Init_Level }

procedure del_level (var level : p_level);
var
   ptr : p_level;
begin
     if (level <> nil)
     then
         begin
              ptr := level;
              if (ptr^.next <> nil)
              then
                  ptr^.next^.previous := ptr^.previous;
              {endif}
              if (level^.previous <> nil)
              then
                  ptr^.previous^.next := ptr^.next;
              {endif}
              dispose (ptr);
              ptr := nil;
              level := nil;
         end;
     {endif}
end; { del_level }

end. { Fin de l'unit‚ 'Laby_Var'. }

unit laby_depl;
{
Auteur: Pr‚martin Patrick.
Date: 19/08/1991.
      23/08/1991.
      27/08/1991.
      29/07/1992.
Langage: Turbo Pascal 6.0
But: Gestion des d‚placements dans Laby (le jeu) et Laby_Gen (l'‚diteur de
     tableaux).
}
interface
procedure clic (var x_curs, y_curs, x, y : integer);
procedure clic_clavier (var x_curs, y_curs : integer; var touche : char);
procedure clic_joystick (var x_curs, y_curs : integer; var touche : char);

implementation
uses
    crt,
    laby_var,
    u_joystick,
    u_code_clavier,
    u_curseur,
    u_mouse;

procedure clic (var x_curs, y_curs, x, y : integer);
var
   mx, my, mk : integer;
begin
     show_mouse;
     mouse_x_y_k_txt (mx, my, mk);
     if (mk > 0)
     then
         begin
              if ((mx > depl_x) and (my > depl_y) and (mx < succ (depl_x+max_larg)) and (my < succ (depl_y+max_haut)))
              then
                  begin
                       x_curs := mx-depl_x;
                       y_curs := my-depl_y;
                  end;
              {endif}
              x := mx;
              y := my;
         end
     else
         begin
              x := 0;
              y := 0;
         end;
     {endif}
end; { clic }

procedure clic_clavier (var x_curs, y_curs : integer; var touche : char);
begin
     curseur_off;
     if not keypressed
     then
         touche := carac_nul
     else
         begin
              touche := readkey;
              if (touche = carac_nul)
              then
                  begin
                       touche := readkey;
                       case touche of
                            touche_haut : begin
                                               touche := carac_nul;
                                               if (y_curs > 1)
                                               then
                                                   dec (y_curs);
                                               {endif}
                            end;
                            touche_bas : begin
                                              touche := carac_nul;
                                              if (y_curs < max_haut)
                                              then
                                                  inc (y_curs);
                                              {endif}
                            end;
                            touche_gauche : begin
                                                 touche := carac_nul;
                                                 if (x_curs > 1)
                                                 then
                                                     dec (x_curs);
                                                 {endif}
                            end;
                            touche_droite : begin
                                                 touche := carac_nul;
                                                 if (x_curs < max_larg)
                                                 then
                                                     inc (x_curs);
                                                 {endif}
                            end;
                       end;
                  end;
              {endif}
         end;
     {endif}
end; { clic_clavier }

procedure clic_joystick (var x_curs, y_curs : integer; var touche : char);
begin
  case stick (stick_a) of
    1 :
      begin
        inc (x_curs);
        dec (y_curs);
      end;
    2 :
      begin
        inc (x_curs);
      end;
    3 :
      begin
        inc (x_curs);
        inc (y_curs);
      end;
    4 :
      begin
        inc (y_curs);
      end;
    5 :
      begin
        dec (x_curs);
        inc (y_curs);
      end;
    6 :
      begin
        dec (x_curs);
      end;
    7 :
      begin
        dec (x_curs);
        dec (y_curs);
      end;
    8 :
      begin
        dec (y_curs);
      end;
  end;
  if (x_curs < 1)
  then
    x_curs := 1;
  {endif}
  if (y_curs < 1)
  then
    y_curs := 1;
  {endif}
  if (x_curs >= max_larg)
  then
    x_curs := max_larg;
  {endif}
  if (y_curs >= max_haut)
  then
    y_curs := max_haut;
  {endif}
  if ((strig and (strig_a_1+strig_a_2)) > 0)
  then
    touche := ' ';
  {endif}
end; { clic_joystick }

end. { Fin de l'unit‚ 'Laby_Depl'. }

unit laby_mvt;
{
Auteur: Pr‚martin Patrick
Date: 27/08/1991.
      28/08/1991.
      29/08/1991.
      27/07/1992.
Langage: Turbo Pascal 6.0
But: Gestion des mouvements du jeu LABY.
}
interface
uses
    laby_aff,
    laby_var;

var
   dec_life,
   fin_part : boolean;
   score : integer;

procedure init_mvt;
procedure gere_mouvements (level : p_level);

implementation
procedure init_mvt;
begin
     fin_part := false;
     dec_life := false;
end; { Init_Mvt }

procedure mvt_player (level : p_level);
var
   tst : boolean;
   num_door,
   vx,
   vy : integer;
begin
     if (level <> nil)
     then
         with level^ do
              if ((player.dx > 0) or (player.dy > 0))
              then
                  begin
                       num_door := 0;
                       if (player.x < player.dx)
                       then
                           vx := 1
                       else
                           if (player.x > player.dx)
                           then
                               vx := -1
                           else
                               vx := 0;
                           {endif}
                       {endif}
                       if (player.y < player.dy)
                       then
                           vy := 1
                       else
                           if (player.y > player.dy)
                           then
                               vy := -1
                           else
                               vy := 0;
                           {endif}
                       {endif}
                       if ((vx <> 0) and (vy <> 0) and not ((decor [player.x, player.y+ vy] in [0, 101..100+nb_max_door])
                                                       or (decor [player.x+ vx, player.y] in [0, 101..100+nb_max_door])))
                       then
                           vy := 0;
                       {endif}
                       tst := true;
                       while (tst) do
                             case (decor [player.x+ vx, player.y+ vy]) of
                                  100,
                                  1 : if ((vx = 0) and (vy = 0))
                                      then
                                          tst := false
                                      else
                                          if (vy = 0)
                                          then
                                              begin
                                                   if (player.y < player.dy)
                                                   then
                                                       vy := 1
                                                   else
                                                       if (player.y > player.dy)
                                                       then
                                                           vy := -1
                                                       else
                                                           vy := 0;
                                                       {endif}
                                                   {endif}
                                                   vx := 0;
                                                   tst := true;
                                              end
                                          else
                                              begin
                                                   vy := 0;
                                                   tst := true;
                                              end;
                                          {endif}
                                      {endif}
                                  4 : begin
                                           if ((exit_door.activ) and (not exit_key.Activ))
                                           then
                                               begin
                                                    fin_part := true;
                                                    inc (score, scr_exit_door);
                                                    aff_score (score);
                                               end;
                                           {endif}
                                           tst := false;
                                  end;
                                  5 : begin
                                           if (exit_key.activ)
                                           then
                                               begin
                                                    exit_door.activ := true;
                                                    exit_key.activ := false;
                                                    aff_nothing (exit_key.x, exit_key.y);
                                                    level^.decor [level^.exit_door.x, level^.exit_door.y] := 4;
                                                    aff_exit_door (exit_door);
                                                    inc (score, scr_exit_key);
                                                    aff_score (score);
                                               end;
                                           {endif}
                                           tst := false;
                                  end;
                                  51..50+nb_max_bonus : begin
                                                             score := score + 2* (decor [player.x+vx, player.y+vy]-50);
                                                             aff_score (score);
                                                             tst := false;
                                  end;
                                  201..200+nb_max_enemy : begin
                                                               dec_life := true;
                                                               tst := false;
                                  end;
                                  101..100+nb_max_door : begin
                                                              num_door := decor [player.x+ vx, player.y+ vy] -100;
                                                              case (door [num_door].sens) of
                                                                   horiz : if ((vy <> 0) or ((vy = 0) and (vx <> 0)))
                                                                           then
                                                                               door [num_door].sens := verti;
                                                                           {endif}
                                                                   verti : if ((vx <> 0) or ((vx = 0) and (vy <> 0)))
                                                                           then
                                                                               door [num_door].sens := horiz;
                                                                           {endif}
                                                              end;
                                                              tst := false;
                                  end;
                             else
                                 tst := false;
                             end;
                       {endwhile}
                       decor [player.x, player.y] := 0;
                       aff_nothing (player.x, player.y);
                       player.x := player.x + vx;
                       player.y := player.y + vy;
                       decor [player.x, player.y] := 2;
                       aff_player (player);
                       if (num_door > 0)
                       then
                         case (door [num_door].sens) of
                           horiz :
                             begin
                                level^.decor [door [num_door].x, pred (door [num_door].y)] := 0;
                                level^.decor [pred (door [num_door].x), door [num_door].y] := 100+num_door;
                                level^.decor [door [num_door].x, door [num_door].y] := 100;
                                level^.decor [succ (door [num_door].x), door [num_door].y] := 100+num_door;
                                level^.decor [door [num_door].x, succ (door [num_door].y)] := 0;
                                aff_door (door [num_door]);
                             end;
                           verti :
                             begin
                                level^.decor [door [num_door].x, pred (door [num_door].y)] := 100+num_door;
                                level^.decor [pred (door [num_door].x), door [num_door].y] := 0;
                                level^.decor [door [num_door].x, door [num_door].y] := 100;
                                level^.decor [succ (door [num_door].x), door [num_door].y] := 0;
                                level^.decor [door [num_door].x, succ (door [num_door].y)] := 100+num_door;
                                aff_door (door [num_door]);
                             end;
                         end;
                       {endif}
                  end;
              {endif}
         {endwith}
     {endif}
end; { Mvt_Player }

procedure mvt_enemy (level : p_level);
var
   vx,
   vy,
   j,
   i : integer;
   obstacle,
   tst : boolean;
begin
     if (level <> nil)
     then
         with level^ do
              for i := 1 to nb_max_enemy do
                  if ((enemy [i].x > 0) and (enemy [i].y > 0))
                  then
                      begin
                           vx := enemy [i].dx;
                           vy := enemy [i].dy;
                           if ((vx = 0) and (vy = 0))
                           then
                               case (enemy [i].dir_typ) of
                                    left : vx := -1;
                                    right : vx := 1;
                                    g_player : begin
                                                    if (enemy [i].x < player.x)
                                                    then
                                                        vx := 1
                                                    else
                                                        if (enemy [i].x > player.x)
                                                        then
                                                            vx := -1
                                                        else
                                                            vx := 0;
                                                        {endif}
                                                    {endif}
                                                    if (enemy [i].y < player.y)
                                                    then
                                                        vy := 1
                                                    else
                                                        if (enemy [i].y > player.y)
                                                        then
                                                            vy := -1
                                                        else
                                                            vy := 0;
                                                        {endif}
                                                    {endif}
                                    end;
                               end;
                           {endif}
                           if ((vx <> 0) and (vy <> 0)
                              and (decor [enemy [i].x, enemy [i].y+ vy] > 0)
                              and (decor [enemy [i].x+ vx, enemy [i].y] > 0))
                           then
                               vy := 0;
                           {endif}
                           tst := true;
                           j := 0;
                           obstacle := false;
                           while (tst and (j < 4)) do
                                 begin
                                      case (decor [enemy [i].x+ vx, enemy [i].y+ vy]) of
                                        51..50+nb_max_bonus,
                                        100,
                                        201..200+nb_max_enemy,
                                        1,
                                        4,
                                        5 : obstacle := true;
                                        2 : begin
                                              tst := false;
                                              dec_life := true and not fin_part;
                                        end;
                                        101..100+nb_max_door :
                                          case (door [decor [enemy [i].x+ vx, enemy [i].y+ vy]- 100].sens) of
                                            horiz : obstacle := ((vy <> 0) or ((vx <> 0) and (vy = 0)));
                                            verti : obstacle := ((vx <> 0) or ((vy <> 0) and (vx = 0)));
                                          end;
                                      else
                                          tst := false;
                                      end;
                                      if obstacle
                                      then
                                          begin
                                               obstacle := false;
                                               case (enemy [i].dir_typ) of
                                                    left : case vx of
                                                                -1 : begin
                                                                          vx := 0;
                                                                          vy := 1;
                                                                          inc (j);
                                                                end;
                                                                1 : begin
                                                                         vx := 0;
                                                                         vy := -1;
                                                                         inc (j);
                                                                end;
                                                                0 : case vy of
                                                                         -1 : begin
                                                                                   vy := 0;
                                                                                   vx := -1;
                                                                                   inc (j);
                                                                         end;
                                                                         1 : begin
                                                                                  vy := 0;
                                                                                  vx := 1;
                                                                                  inc (j);
                                                                         end;
                                                                         0 : tst := false;
                                                                end;
                                                    end;
                                                    right : case vx of
                                                                 -1 : begin
                                                                           vx := 0;
                                                                           vy := -1;
                                                                           inc (j);
                                                                 end;
                                                                 1 : begin
                                                                          vx := 0;
                                                                          vy := 1;
                                                                          inc (j);
                                                                 end;
                                                                 0 : case vy of
                                                                          -1 : begin
                                                                                    vy := 0;
                                                                                    vx := 1;
                                                                                    inc (j);
                                                                          end;
                                                                          1 : begin
                                                                                   vy := 0;
                                                                                   vx := -1;
                                                                                   inc (j);
                                                                          end;
                                                                          0 : tst := false;
                                                                 end;
                                                    end;
                                                    g_player : begin
                                                                    vx := 0;
                                                                    vy := 0;
                                                                    tst := false;
                                                    end;
                                               end;
                                          end
                                      else
                                          tst := false;
                                      {endif}
                                 end;
                           {endwhile}
                           decor [enemy [i].x, enemy [i].y] := 0;
                           aff_nothing (enemy [i].x, enemy [i].y);
                           enemy [i].x := enemy [i].x + vx;
                           enemy [i].dx := vx;
                           enemy [i].y := enemy [i].y + vy;
                           enemy [i].dy := vy;
                           decor [enemy [i].x, enemy [i].y] := 200+i;
                           aff_enemy (enemy [i]);
                      end;
                  {endif}
              {endfor}
         {endwith}
     {endif}
end; { Mvt_Enemy }

procedure gere_mouvements (level : p_level);
begin
     if (level <> nil)
     then
         begin
              mvt_player (level);
              mvt_enemy (level);
         end;
     {endif}
end; { Gere_Mouvements }

end. { Fin de l'unit‚ 'Laby_Mvt'. }

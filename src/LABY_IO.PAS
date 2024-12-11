unit laby_io;
{
Auteur: Premartin Patrick
Date: 26/08/1991.
      27/08/1991.
      28/08/1991.
      29/08/1991.
      27/07/1992.
      29/07/1992.
      30/07/1992.
Langage: Turbo Pascal 6.0
But: Gestion des entrees/sorties pour les tableaux de Laby.
}
interface
uses
    laby_var;

const
     laby_ext : string [3] = 'LBD';
     c_laby_name : string [8] = 'LABY.LBD';

var
   laby_fich_name : string;

function laby_test (level : p_level) : boolean;
procedure clear_level (var level : p_level);
procedure load_level (var level_1 : p_level);
procedure laby_save (level : p_level);
procedure laby_load (var level : p_level);
procedure laby_clear (var level : p_level);
procedure init_io;

implementation
uses
    crt,
    dos,
    u_msg,
    u_parametre,
    u_m_util;

procedure clear_level (var level : p_level);
begin
     if (level <> nil)
     then
         begin
              while (level^.previous <> nil) do
                    del_level (level^.previous);
              {endwhile}
              while (level^.next <> nil) do
                    del_level (level^.next);
              {endwhile}
              del_level (level);
         end;
     {endif}
end; { Clear_Level }

procedure load_level (var level_1 : p_level);
var
   fich : file of t_level;
   level_0,
   level : p_level;
   erreur : boolean;
begin
     if (laby_fich_name <> '.'+laby_ext)
     then
         begin
              assign (fich, laby_fich_name);
              {$i-}
              reset (fich);
              {$i+}
              if (ioresult = 0)
              then
                  begin
                       erreur := false;
                       level_0 := nil;
                       level := level_1;
                       while not (eof (fich) or erreur or (level = nil)) do
                             begin
                                  {$i-}
                                  read (fich, level^);
                                  {$i+}
                                  erreur := (ioresult <> 0);
                                  level^.previous := level_0;
                                  level_0 := level;
                                  init_level (level^.next, level, 0, nil);
                                  level := level^.next;
                             end;
                       {endwhile}
                       close (fich);
                       del_level (level);
                       if (erreur)
                       then
                           alert (get_msg (1), al_error);
                       {endif}
                  end
              else
                  alert (get_msg (2), al_error);
              {endif}
         end
     else
         alert (get_msg (3), al_cancel);
     {endif}
end; { Load_Level }

function laby_test (level : p_level) : boolean;
var
   ok,
   erreur : boolean;
begin
     if (level <> nil)
     then
         begin
              ok := true;
              erreur := ((level^.player.x = 0) or (level^.player.y = 0));
              if erreur
              then
                  begin
                       alert (get_msg (4), al_error);
                       ok := false;
                  end;
              {endif}
              erreur := ((level^.exit_door.x = 0) or (level^.exit_door.y = 0));
              if erreur
              then
                  begin
                       alert (get_msg (5), al_error);
                       ok := false;
                  end;
              {endif}
         end
     else
         begin
              ok := false;
              alert (get_msg (6), al_error);
         end;
     {endif}
     laby_test := ok;
end; { Laby_Test }

procedure laby_save (level : p_level);
var
   fich : file of t_level;
   erreur : boolean;
begin
     if (confirm (get_msg (7)) and (level <> nil))
     then
         begin
              while (level^.previous <> nil) do
                    level := level^.previous;
              {endwhile}
              laby_fich_name := get_fich_name (laby_fich_name, laby_ext);
              if (laby_fich_name <> '.'+laby_ext)
              then
                  begin
                       assign (fich, laby_fich_name);
                       {$i-}
                       rewrite (fich);
                       {$i+}
                       if (ioresult = 0)
                       then
                           begin
                                erreur := false;
                                while ((level <> nil) and not (erreur)) do
                                      begin
                                           {$i-}
                                           write (fich, level^);
                                           {$i+}
                                           erreur := (ioresult <> 0);
                                           level := level^.next;
                                      end;
                                {endwhile}
                                close (fich);
                                if erreur
                                then
                                    alert (get_msg (8), al_error)
                                else
                                    alert (get_msg (9), al_ok);
                                {endif}
                           end
                       else
                           alert (get_msg (10), al_cancel);
                       {endif}
                  end
              else
                  alert (get_msg (8), al_error);
              {endif}
         end;
     {endif}
end; { Laby_Save }

procedure laby_load (var level : p_level);
var
   level_1 : p_level;
begin
     if (confirm (get_msg (11)) and (level <> nil))
     then
         begin
              clear_level (level);
              init_level (level_1, nil, 1, nil);
              laby_fich_name := get_fich_name (laby_fich_name, laby_ext);
              load_level (level_1);
              level := level_1;
         end;
     {endif}
end; { Laby_Load }

procedure laby_clear (var level : p_level);
begin
     if (confirm (get_msg (12)) and (level <> nil))
     then
         begin
              clear_level (level);
              init_level (level, nil, 1, nil);
         end;
     {endif}
end; { Laby_Clear }

procedure init_io;
var
   path : dirstr;
   name : namestr;
   ext : extstr;
   result,
   i : integer;
begin
  if (param_del ('/H') or param_del ('/?'))
  then
    begin
      textcolor (lightgray);
      textbackground (black);
      clrscr;
      writeln;
      writeln (get_msg (13));
      writeln (get_msg (14));
      writeln (get_msg (15));
      writeln (get_msg (16));
      writeln (get_msg (17));
      writeln (get_msg (18));
      alert (get_msg (19), al_wait);
      clrscr;
    end;
  {endif}
  delai_attente := 0;
  joystick := false;
  for i := 1 to paramcount do
    if (param_del ('/J'))
    then
        joystick := true
    else
      if ((copy (paramstr (i), 1, 2) = '/f') or (copy (paramstr (i), 1, 2) = '/F'))
      then
        begin
          laby_fich_name := copy (paramstr (i), 3, 8);
          fsplit (fexpand (laby_fich_name), path, name, ext);
          chdir (copy (path, 1, pred (length (path))));
          laby_fich_name := name+'.'+laby_ext;
        end
      else
        if ((copy (paramstr (i), 1, 2) = '/s') or (copy (paramstr (i), 1, 2) = '/S'))
        then
          begin
            val (copy (paramstr (i), 3, length (paramstr (i))), delai_attente, result);
            if ((result <> 0) or (delai_attente > 10000))
            then
              delai_attente := 0
            else
              delai_attente := 10000-delai_attente;
            {endif}
          end;
        {endif}
      {endif}
    {endif}
  {endfor}
end; { Init_Io }

begin
     laby_fich_name := '';
end. { Fin de l'unit‚ 'Laby_Io'. }

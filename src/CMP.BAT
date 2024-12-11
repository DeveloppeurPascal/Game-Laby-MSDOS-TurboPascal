@echo off
set code=gamelaby
mkmsg gamelaby.txt gamelaby.msg
lha a c:\olf_soft\lzh\%code% laby.doc laby.exe laby_gen.exe laby.lbd gamelaby.msg
lha a c:\olf_soft\lzh\%code% setup.cfg c:\prg\others\divers\setstick.Exe c:\prg\others\divers\setdflt.exe
set code=
echo on

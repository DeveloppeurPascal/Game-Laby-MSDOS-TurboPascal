@echo off
set code=laby01
olf_dat 0 gamelaby 0
lha a c:\olf_soft\lzh\%code% go01.bat laby01.lbd olf_soft.dat
del olf_soft.dat
set code=
echo on

# !/in/bash


gfortran ../md_restart.f90 -o md
echo 10 | ./md
rm md


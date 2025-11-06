# !/in/bash


gfortran ../md_restart.f90 -o md
echo 1 | ./md
rm md


# !/in/bash


gfortran ../md_restart.f90 -o md
echo 100 | ./md
rm md


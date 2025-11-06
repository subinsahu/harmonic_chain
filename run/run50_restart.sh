# !/in/bash


gfortran ../md_restart.f90 -o md
echo 50 | ./md
rm md

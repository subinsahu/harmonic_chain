# !/in/bash


gfortran ../md_restart.f90 -o md
echo 0.05 | ./md
rm md


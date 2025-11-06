# !/in/bash


gfortran ../md.f90 -o md
echo 1 | ./md
rm md


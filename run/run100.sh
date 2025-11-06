# !/in/bash


gfortran ../md.f90 -o md
echo 100 | ./md
rm md


# !/in/bash


gfortran ../md.f90 -o md
echo 0.1 | ./md
rm md


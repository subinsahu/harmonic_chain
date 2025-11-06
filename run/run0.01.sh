# !/in/bash


gfortran ../md.f90 -o md
echo 0.01 | ./md
rm md


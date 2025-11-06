# !/in/bash


gfortran ../md.f90 -o md
echo 0.05 | ./md
rm md


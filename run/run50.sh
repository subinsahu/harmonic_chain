# !/in/bash


gfortran ../md.f90 -o md
echo 50 | ./md
rm md

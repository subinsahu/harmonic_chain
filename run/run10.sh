# !/in/bash


gfortran ../md.f90 -o md
echo 10 | ./md
rm md


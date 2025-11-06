# !/in/bash

gfortran ../md.f90 -o md
echo 30 | ./md
rm md


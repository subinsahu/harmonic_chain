# !/in/bash

gfortran ../md.f90 -o md
echo 3 | ./md
rm md


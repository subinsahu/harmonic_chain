# !/in/bash

gfortran ../md.f90 -o md
echo 0.03 | ./md
rm md


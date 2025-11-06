# !/in/bash

gfortran ../md.f90 -o md
echo 0.5 | ./md
rm md


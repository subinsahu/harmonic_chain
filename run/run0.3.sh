# !/in/bash

gfortran ../md.f90 -o md
echo 0.3 | ./md
rm md


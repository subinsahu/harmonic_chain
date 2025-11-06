# !/in/bash
gfortran ../md.f90 -o md
echo 5 | ./md
rm md


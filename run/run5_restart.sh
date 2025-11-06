# !/in/bash
gfortran ../md_restart.f90 -o md
echo 5 | ./md
rm md


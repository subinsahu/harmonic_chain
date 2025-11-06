set autoscale
unset log
unset label
set title 'time curve PBD model'
set xlabel 'time (micro seconds)'
set ylabel 'sigma'
#set yrange [-.01:.2 ]
f(x)=0
set term jpeg
set output out_file
   plot  in_file using ($1/1000):50 every :: 100  with linespoints title "cumulative average current",f(x) title 'x=0'

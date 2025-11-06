set autoscale
set key left
unset log
unset label
set logscale x
set logscale y
set title 'heat conductivity in harmonic lattice'
set xlabel 'gamma'
set ylabel 'sigma'
   f1(x)=(1+4*x**2-sqrt(1+2*x**2)*sqrt(1+6*x**2))/(4*x**3)
   d=1
   k=1
   f2(x)=(sqrt(d+4*k)-sqrt(d))/6.28


set yrange [0.001:2]
   set xrange [10**-4:10**3]
set term jpeg
   set output 'harmonic.jpg'

  plot "plot.dat" using 1:2 with linespoint title "thermal current(Nr=1)", f1(x)  title "sigma3 (Nr=1)",f1(100*x) title "sigma1 (Nr=100)",f2(x) title "sigma2"

# plot "plot.dat" using 1:50 with linespoint title "thermal current", f1(x)  title "sigma2",f2(x)

#plot  "< awk '{sum=0 ; for (i=2;i<=NF;i++) sum +=$i;print $1, 160*sum/(NF-1)}' plot.dat" using 1:2 with linespoints title "bbk",f(x) title "sigma max"
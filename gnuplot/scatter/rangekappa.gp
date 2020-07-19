
reset
#!/usr/bin/gnuplot -persist

set terminal postscript eps size 6.0,4.5 enhanced color font 'Helvetica,40' lw 3
set output "k11range.eps"

set style line 1 linecolor @uniSblue linetype 8 linewidth 1.5 #blue
set style line 2 linecolor rgb '#dd181f' linetype 1 linewidth 3.0 #red
#set style line 3 linecolor rgb '#008000' linetype 1 linewidth 1.5 #green
#set style line 3 linecolor rgb '#e8c915' linetype 1 linewidth 3.5 #yellow
set style line 3 linecolor rgb '#00ff00' linetype 1 linewidth 3.5 #yellow
set style line 4 linecolor @uniSlblue linetype 8 linewidth 1.5

set style fill solid 0.65 border -1
set style boxplot outliers pointtype 5
set style data boxplot

set xrange[0.15:0.85]
set yrange[0.2:0.9]
set ytics 0.2 #textcolor rgb "red"
set xtics 0.2

set grid xtics ytics lt 8 lc rgb '#000000' lw 1 dt '-'

#set xtics('0.2' 1, '0.3' 2, '0.4' 3, '0.5' 4)

#set title "kappa11"
set xlabel "fp"
set ylabel "kappa11" offset 0.5,0
#set key inside top right width 0.1 Left spacing 1.4 box lt 1 lw 2 lc rgb '#000000'

set key inside top right width 1.1 Left spacing 1.2 box lt 1 lw 2 lc rgb '#000000'
set border lw 1.5

set rmargin 1.5
set lmargin 4.0
set bmargin 3.25
set tmargin 0.75

plot \
	"range_kappa.data"	every 15 u 5:6 w p ls 1 notitle ,\
	"range_kappa.data"	every 15 u 1:2 w p ls 1 title "k11",\
	"bounds_kappa_fb.data" 	u 1:2 w l ls 2 notitle,\
	"bounds_kappa_fb.data" 	u 1:8 w l ls 2 title "minmax" ,\
	"bounds_kappa_fb.data" 	u 1:5 w l ls 3 title "mean",\
	


set output "k22range.eps"

#set title "kappa22"
set ylabel "kappa22"

plot \
	"range_kappa.data"	every 15 u 5:7 w p ls 1 notitle 	,\
	"range_kappa.data"	every 15 u 1:3 w p ls 1 title "k22"	,\
	"bounds_kappa_fb.data" 	u 1:3 w l ls 2 notitle			,\
	"bounds_kappa_fb.data" 	u 1:9 w l ls 2 title "minmax" 		,\
	"bounds_kappa_fb.data" 	u 1:6 w l ls 3 title "mean"		,\


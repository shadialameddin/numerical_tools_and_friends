
#!/usr/bin/gnuplot -persist

set terminal postscript eps size 4.5,5.0 enhanced color font 'Helvetica,40' lw 3
#set terminal postscript enhanced eps color font "helvetica,12" size 6cm,5cm dl 0.5 dashed

set style line 1 linecolor rgb "#0000ff" linetype 1 linewidth 3
set style line 2 linecolor @uniSred100 linetype 1 linewidth 3
set style line 3 linecolor @gimpgray80 linetype 1 linewidth 3
set style line 4 linecolor rgb "#0000ff" linetype 1 linewidth 3 dt '-'
set style line 5 linecolor @uniSred100 linetype 1 linewidth 3 dt '-'
set style line 6 linecolor @gimpgray80 linetype 1 linewidth 3 dt '-'

set style line 7 lc rgb '#00ff00' lt 1 lw 3

#set style line 3 linecolor @Spurple linetype 1 linewidth 3
#set style line 1 linecolor rgb '#dd181f' linetype 1 linewidth 3 #red
#set style line 2 linecolor rgb '#ff8000' linetype 1 linewidth 3 #orange
#set style line 3 linecolor rgb '#0000cc' linetype 1 linewidth 3 #blue
#set style line 4 linecolor rgb '#008000' linetype 1 linewidth 3 #green

set xrange[2:30]
set yrange[0.000:0.040]
unset ytics
set ytics 0.005
#set format y "%.0s*10^{%S}"

set grid xtics ytics lt 8 lc rgb '#000000' lw 1 dt '-'

set xlabel "red coeff"
set ylabel "mean" offset 0.7,0
set key inside top right width 1.0 Left spacing 0.9 box lt 1 lw 2 lc rgb '#000000'

set border lw 1.5
set rmargin 3.1
set lmargin 3.3
set bmargin 3.25
set tmargin 2.15


####################train circ, mean errors
set output "circ_training_mean.eps"
set title "circ"

plot \
	"e_over_h_v1_2norm" u 1:2 w l ls 1 title "cir"   ,\
	"e_over_h_v1_2norm" u 1:3 w l ls 2 title "rec" ,\
	"e_over_h_v1_2norm" u 1:4 w l ls 3 title "mi"   ,\
	"GPM_e_over_h_ver1_2norm" u 1:2 w l ls 4 notitle    ,\
	"GPM_e_over_h_ver1_2norm" u 1:3 w l ls 5 notitle  ,\
	"GPM_e_over_h_ver1_2norm" u 1:4 w l ls 6 notitle   ,\
	#"acc_tests/e_over_h_v1_mit_pd" u 1:2 w l ls 7 notitle    ,\
	#"acc_tests/e_over_h_v1_mit_pd" u 1:3 w l ls 7 notitle  ,\
	#"acc_tests/e_over_h_v1_mit_pd" u 1:4 w l ls 7 notitle   ,\
	#"e_over_h_v1_overkill_model" u 1:2 w l ls 7 notitle    ,\
	#"e_over_h_v1_overkill_model" u 1:3 w l ls 7 notitle  ,\
	#"e_over_h_v1_overkill_model" u 1:4 w l ls 7 notitle   ,\


####################train rect, mean errors
set output "rect_training_mean.eps"

set title "rect"

plot \
	"e_over_h_v2_2norm" u 1:2 w l ls 1 title "cir"   ,\
	"e_over_h_v2_2norm" u 1:3 w l ls 2 title "rec" ,\
	"e_over_h_v2_2norm" u 1:4 w l ls 3 title "mi"   ,\
	"GPM_e_over_h_ver2_2norm" u 1:2 w l ls 4 notitle    ,\
	"GPM_e_over_h_ver2_2norm" u 1:3 w l ls 5 notitle  ,\
	"GPM_e_over_h_ver2_2norm" u 1:4 w l ls 6 notitle   ,\
	#"acc_tests/e_over_h_v2_mit_pd" u 1:2 w l ls 7 notitle    ,\
	#"acc_tests/e_over_h_v2_mit_pd" u 1:3 w l ls 7 notitle  ,\
	#"acc_tests/e_over_h_v2_mit_pd" u 1:4 w l ls 7 notitle   ,\

	
####################train mix, mean errors
set output "mixed_training_mean.eps"

#unset key
#set key at screen 0.5,0.55 width 1.0 Left spacing 0.9 box lt 1 lw 2 lc rgb '#000000'
#set key inside bot center  width 1.0 Left spacing 0.9 box lt 1 lw 2 lc rgb '#000000'
set title "mix"

plot \
	"e_over_h_v3_2norm" u 1:2 w l ls 1 title "cir"   ,\
	"e_over_h_v3_2norm" u 1:3 w l ls 2 title "rec" ,\
	"e_over_h_v3_2norm" u 1:4 w l ls 3 title "mi"   ,\
	"GPM_e_over_h_ver3_2norm" u 1:2 w l ls 4 notitle    ,\
	"GPM_e_over_h_ver3_2norm" u 1:3 w l ls 5 notitle  ,\
	"GPM_e_over_h_ver3_2norm" u 1:4 w l ls 6 notitle   ,\
	#"acc_tests/e_over_h_v3_mit_pd" u 1:2 w l ls 7 notitle    ,\
	#"acc_tests/e_over_h_v3_mit_pd" u 1:3 w l ls 7 notitle  ,\
	#"acc_tests/e_over_h_v3_mit_pd" u 1:4 w l ls 7 notitle   ,\

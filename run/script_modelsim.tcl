
vlib work

set i0 +incdir+../rtl
set i1 +incdir+../tb

set s0 ../rtl/*.*v
set s1 ../tb/*.*v

vlog $i0 $i1 $s0 $s1 
vsim -novopt work.nf_tb
run -all

wave zoom full

#quit
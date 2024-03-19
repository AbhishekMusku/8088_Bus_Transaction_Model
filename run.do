vlib work
vdel -all
vlib work
vlog 8088if.svp -sv +acc
vlog mem.sv -sv +acc
vlog IO.sv -sv +acc
#vlog new_MIO.sv -sv +acc
vlog top-3.sv -sv +acc
vsim work.top
#do wave.do
add wave -r *
run -all

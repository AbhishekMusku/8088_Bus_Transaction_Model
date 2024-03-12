vlib work
vdel -all
vlib work
vlog 8088.svp -sv +acc
vlog mem.sv -sv +acc
vlog IO.sv -sv +acc
#vlog new1.sv -sv +acc
vlog top-3.sv -sv +acc
vsim work.top
#do wave.do
add wave -r *
run -all
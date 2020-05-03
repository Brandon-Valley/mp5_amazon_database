vsim -voptargs=+acc work.shop_tb_v
 
add wave -position insertpoint    \
sim:/shop_tb_v/i_clk   \
sim:/shop_tb_v/i_reset \
sim:/shop_tb_v/i_rdy   \
sim:/shop_tb_v/i_u     \
sim:/shop_tb_v/i_a     \
sim:/shop_tb_v/o_a    

run 5000ns
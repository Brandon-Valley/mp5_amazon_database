vsim -voptargs=+acc work.shop_tb_v
 
add wave -position insertpoint    \
sim:/shop_tb_v/i_reset \
sim:/shop_tb_v/i_u     \
sim:/shop_tb_v/i_a     \
sim:/shop_tb_v/o_a     \
sim:/shop_tb_v/i_rdy   \
sim:/shop_tb_v/i_clk   \
sim:/shop_tb_v/uut/cur_cmd \
sim:/shop_tb_v/uut/cur_state \
sim:/shop_tb_v/uut/in_a_known_username \
sim:/shop_tb_v/uut/in_a_valid_cmd \
sim:/shop_tb_v/uut/cur_user__num \
sim:/shop_tb_v/uut/cur_user__username \
sim:/shop_tb_v/uut/uv__usernames
run 1900ns
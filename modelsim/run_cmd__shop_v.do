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
sim:/shop_tb_v/uut/cur_user_num \
sim:/shop_tb_v/uut/cur_user_perms \
sim:/shop_tb_v/uut/cur_username \
sim:/shop_tb_v/uut/in_a_known_username \
sim:/shop_tb_v/uut/in_a_valid_cmd \
sim:/shop_tb_v/uut/out__ask_cmd \
sim:/shop_tb_v/uut/out__invalid_cmd \
sim:/shop_tb_v/uut/out__invalid_perms

run 1900ns
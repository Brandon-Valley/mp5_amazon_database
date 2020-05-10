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
sim:/shop_tb_v/uut/next_state \
sim:/shop_tb_v/uut/in_a__known_username \
sim:/shop_tb_v/uut/in_a__valid_cmd \
sim:/shop_tb_v/uut/in_a__valid_cmd__user_has_perms_for \
sim:/shop_tb_v/uut/cur_user__num \
sim:/shop_tb_v/uut/cur_user__username \
sim:/shop_tb_v/uut/uv__usernames \
sim:/shop_tb_v/uut/cur_user__password \
sim:/shop_tb_v/uut/cur_user__perms 
run 1900ns
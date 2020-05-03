// -- python C:\Users\Brandon\Documents\Personal_Projects\my_utils\modelsim_utils\auto_run.py -d run_cmd__shop_v.do

// `timescale 1ms/1ms
`timescale 1ns/1ns







module shop_tb_v;

    parameter I_A_NUM_ASCII_CHARS   = 7                      ; // must fit longest CMD_KEY
    parameter O_A_NUM_ASCII_CHARS   = 9                      ; // must fit longest out__
  
    parameter I_A_NUM_BITS          = I_A_NUM_ASCII_CHARS * 8;
    parameter I_U_NUM_BITS          = 4                      ; // max 15
    parameter O_A_NUM_BITS          = O_A_NUM_ASCII_CHARS * 8;
  
    parameter MAX_USERS             = 5                      ;  // includes admin
                                                             
    parameter CMD_KEY__LOGOUT       = "Logout"               ;
    parameter CMD_KEY__LOGIN        = "Login"                ;
    parameter CMD_KEY__ADD_USER     = "AddUsr"               ;
    parameter CMD_KEY__DELETE_USER  = "DelUsr"               ;
    parameter CMD_KEY__ADD_ITEM     = "AddItem"              ;
    parameter CMD_KEY__DELETE_ITEM  = "DelItem"              ;
    parameter CMD_KEY__BUY          = "Buy"                  ;
    parameter CMD_KEY__NONE         = "NONE"                 ;
  
  // tb params
  parameter tc = 50; //for clk
  parameter time_between_test_inputs = (5 * tc);
  
  reg                               i_clk  ;
  reg                               i_reset; // must be set high then low at start of tb
  reg                               i_rdy  ;  
  reg unsigned [I_U_NUM_BITS - 1:0] i_u    ;
  reg          [I_A_NUM_BITS - 1:0] i_a    ;
  wire         [O_A_NUM_BITS - 1:0] o_a    ;
  
  
  
  
  // reg        a     ;
  // reg        b     ;
  // reg        c     ;
  // reg  unsigned [23:0] i_code;
  // wire [23:0] o_f   ;
  
  reg [4:0] d_in = 5'b00000;
  integer i;
  
  // duv port map options:
  shop_v  uut (
                            .i_clk  (i_clk  ),
                            .i_reset(i_reset),
                            .i_rdy  (i_rdy  ),
                            .i_u    (i_u    ),
                            .i_a    (i_a    ),
                            .o_a    (o_a    )
  );


  task apply_test(input real i_u_t, i_a_t);
    begin
      i_u = i_u_t;
      i_a = i_a_t;
      #tc
      i_rdy = 1'b1;
      #tc
      i_rdy = 1'b0;

    end
  endtask



  // clk gen
  always 
  begin
    #(tc / 2)      i_clk = 1'b1;
    #(tc - tc / 2) i_clk = 1'b0;
  end


  // initial reset
  initial begin
    i_reset <= 1'b1;
    #(4 * tc) i_reset <= 1'b0;
  end

  //procedure statement
  initial begin


  
  // a = 1'b1;
  // b = 1'b1;
  // c = 1'b1;
  
  // #1000 i_code  = 24'h434241;
  // #1000 i_code  = 24'h7a6167;
  // #1000 i_code  = " hi";
  // #1000 i_code  = "Tes";
  // #1000 i_code  = "hi";
  // #1000 i_code  = 66;
  // #1000 i_code  = 24'h434244;  
  
  
  #(time_between_test_inputs) apply_test(4, CMD_KEY__LOGIN);
  #(time_between_test_inputs) apply_test(5, CMD_KEY__ADD_ITEM);
  #(time_between_test_inputs) apply_test(6, CMD_KEY__LOGIN);
  #(time_between_test_inputs) apply_test(7, "hi");
  
  // i_clk   = 1'b1; 
  // i_reset = 1'b1;
  // i_rdy   = 1'b1;
  // i_u     = 4;
  // i_a     = "HI";    
  
  // #tc
  // apply_test(5, "ww");
  
  // i_clk   = 1'b1; 
  // i_reset = 1'b0;
  // i_rdy   = 1'b1;
  // i_u     = 5;
  // i_a     = "by";    
    
  // #tc
  
  // i_clk   = 1'b1; 
  // i_rdy   = 1'b1;
  // i_u     = 2;
  // i_a     = "kk";    
    
  // #tc
  
  // i_clk   = 1'b1; 
  // i_rdy   = 1'b1;
  // i_u     = 3;
  // i_a     = "qq";    
    
      // for (i = 0 ; i < 34 ; i = i + 1) begin
        // #1000 a      = d_in[0];
              // b      = d_in[1];
              // c      = d_in[2];
              // i_code = d_in[4:3];
      
      
      
        // // #1000 i_code = d_in;
        // // #1000 o_code[0] = d_in[0]; o_code[1] = d_in[1]; o_code[2] = d_in[]; i_d = d_in[4];
        // d_in = d_in + 1;
      // end
          
    end

endmodule

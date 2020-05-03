// -- python C:\Users\Brandon\Documents\Personal_Projects\my_utils\modelsim_utils\auto_run.py -d run_cmd__shop_v.do

`timescale 1ms/1ms

module shop_tb_v;
  
  reg        a     ;
  reg        b     ;
  reg        c     ;
  reg  unsigned [23:0] i_code;
  wire [23:0] o_f   ;
  
  reg [4:0] d_in = 5'b00000;
  integer i;
  
  // duv port map options:
  shop_v  uut (
                            .a     (a     ),
                            .b     (b     ),
                            .c     (c     ),
                            .i_code(i_code),
                            .o_f   (o_f   )
  );

  //procedure statement
  initial begin



    // //procedure statement
  // initial begin
  
  a = 1'b1;
  b = 1'b1;
  c = 1'b1;
  
  #1000 i_code  = 24'h434241;
  #1000 i_code  = 24'h7a6167;
  #1000 i_code  = " hi";
  #1000 i_code  = "Tes";
  #1000 i_code  = "hi";
  #1000 i_code  = 66;
  #1000 i_code  = 24'h434244;  
  


      
      
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

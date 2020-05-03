// -- python C:\Users\Brandon\Documents\Personal_Projects\my_utils\modelsim_utils\auto_run.py -d run_cmd__shop_v.do

// ////////////////////////////////
// //  Behavior Model
// ////////////////////////////////

module shop_v

  (
    input        a     ,
    input        b     ,
    input        c     ,
    input  unsigned [23:0] i_code,
    output [23:0] o_f
  );
  
  // $monitor("t=%3d x=%d,y=%d,z=%d \n",$time,x,y,z, )
  // $monitor("a=%d \n",a )
  assign o_f = i_code;
  
  // initial
   // FIRST_BLOCK : begin
     // $display ("This is first block");  
   // end 
  
  
  
  
  // assign o_f = i_code == 00 ?    a ^ b ^ c    : 
               // i_code == 01 ? ~ (a & b & c)   : 
               // i_code == 10 ? ~ ( a |  b | c) : 
                              // (~a & ~b & ~c) | (~a & b & c) | (a & ~b & c) | (a & b & ~c);
endmodule


// ////////////////////////////
 // // Component Model - Uses MUX
// ////////////////////////////
// module shop_v

  // (
    // input        a     ,
    // input        b     ,
    // input        c     ,
    // input  [1:0] i_code,
    // output       o_f
  // );
  
  
  // // final outputs of each gate
  // wire xor_f;
  // wire nand_f;
  // wire nor_f;
  // wire xnor_f;
  
  // // internal gate outputs
  // wire nor_or_f;   // OR4 output befor NOT output for NOR
  // wire xnor_xor_f; // XOR outup befor NOT output for XNOR
  
  
  
  // // XOR3
  // XOR4_gate_v  xor_0  (a, b, c, 1'b0, xor_f);
  
  // // NAND3
  // NAND4_gate_v nand_0 (a, b, c, 1'b1, nand_f);
  
  // // NOR3
  // OR4_gate_v   or_0   (a, b, c, 1'b0, nor_or_f);
  // NOT1_gate_v  not_0  (nor_or_f, nor_f);
  
  // // XNOR3
  // XOR4_gate_v  xor_1  (a, b, c, 1'b0, xnor_xor_f);
  // NOT1_gate_v  not_1  (xnor_xor_f, xnor_f);
  
  // // shop
  // MUX_4_1_v mux0 (1'b1, {xnor_f, nor_f, nand_f, xor_f}, i_code, o_f);

// endmodule

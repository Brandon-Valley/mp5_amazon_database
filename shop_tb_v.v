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
    
    parameter ADMIN_USERNAME        = "Adm"                  ;       
    parameter ADMIN_PASSWORD        = "123"                  ;
                                                             
    parameter CMD_KEY__LOGOUT       = "Logout"               ;
    parameter CMD_KEY__LOGIN        = "Login"                ;
    parameter CMD_KEY__ADD_USER     = "AddUsr"               ;
    parameter CMD_KEY__DELETE_USER  = "DelUsr"               ;
    parameter CMD_KEY__ADD_ITEM     = "AddItem"              ;
    parameter CMD_KEY__DELETE_ITEM  = "DelItem"              ;
    parameter CMD_KEY__BUY          = "Buy"                  ;
    parameter CMD_KEY__NONE         = "NONE"                 ;
    
    //perm keys
    parameter PERM_KEY__EMPTY       = "EMPTY"                ;
    parameter PERM_KEY__ADMIN       = "ADMIN"                ;
    parameter PERM_KEY__SELLER      = "SELLER"               ;
    parameter PERM_KEY__BUYER       = "BUYER"                ;
  
  // tb params
  parameter tc = 50; //for clk
  parameter time_between_test_inputs = (1 * tc);
  
  reg                                 i_clk  ;
  reg                                 i_reset; // must be set high then low at start of tb
  reg                                 i_rdy  ;  
  reg unsigned [(I_U_NUM_BITS - 1):0] i_u    ;
  reg          [(I_A_NUM_BITS - 1):0] i_a    ;
  wire         [(O_A_NUM_BITS - 1):0] o_a    ;
  
  
 
  
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


  task apply_test(input [I_U_NUM_BITS-1:0] i_u_t, input [I_A_NUM_BITS-1:0] i_a_t);
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
    i_rdy <= 1'b0;
    i_reset <= 1'b1;
    #tc i_reset <= 1'b0;
  end



  //procedure statement
  initial begin
    
    // // all CMD errors
    // // VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
    
    // // cur_user  == EMPTY
    // // cur_state == CMD
    // // Cmd? > give invalid command > InvalCmd > Cmd? 
    // #(time_between_test_inputs) apply_test(4'bXXXX, "sdfsdf");

    // // cur_user  == EMPTY
    // // cur_state == CMD  
    // // Cmd? > give command that you dont have perms for because you are not logged in > InvalPerm > Cmd?
    // #(time_between_test_inputs) apply_test(4'bXXXX, CMD_KEY__LOGOUT);
    
    // // ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    //  Login
    //
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // // USERNAME errors
    // // VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
    
    // // cur_user  == EMPTY
    // // cur_state == CMD
    // // Cmd? > give command that you do have perms for: LOGIN > state: USERNAME > Username?
    // #(time_between_test_inputs) apply_test(4'bXXXX, CMD_KEY__LOGIN);
    
    // // cur_user  == EMPTY
    // // cur_state == USERNAME
    // // Username? > give unknown username > unknown username > Cmd?
    // #(time_between_test_inputs) apply_test(4'bXXXX, "Uun");
    
    // // ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    
    
    // // PASSWORD errors
    // // VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
    
    // // cur_user  == EMPTY
    // // cur_state == CMD
    // // Cmd? > LOGIN > state: USERNAME > Username?
    // #(time_between_test_inputs) apply_test(4'bXXXX, CMD_KEY__LOGIN);
    
    // // cur_user  == EMPTY
    // // cur_state == USERNAME
    // // Username? > give admin username > state: PASSWORD > Password?
    // #(time_between_test_inputs) apply_test(4'bXXXX, ADMIN_USERNAME);
    
    // // cur_user  == EMPTY
    // // cur_state == PASSWORD
    // // Password? > give wrong pass > Cmd?
    // #(time_between_test_inputs) apply_test(4'bXXXX, "Wpw"); 

    // // ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


    // VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
    //
    // Login Admin
    //
    // VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
    
    // cur_user  == EMPTY
    // cur_state == CMD
    // Cmd? > LOGIN > state: USERNAME > Username?
    #(time_between_test_inputs) apply_test(4'bXXXX, CMD_KEY__LOGIN);
    
    // cur_user  == EMPTY
    // cur_state == USERNAME
    // Username? > give admin username > state: PASSWORD > Password?
    #(time_between_test_inputs) apply_test(4'bXXXX, ADMIN_USERNAME);
    
    // cur_user  == EMPTY
    // cur_state == PASSWORD
    // Password? > admin pass > logged in > Cmd?
    #(time_between_test_inputs) apply_test(4'bXXXX, "123"); 
    
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    //  Add User  -  Dependencies: Login Admin
    //
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    
    // // USERNAME errors
    // // VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
        
    // // cur_user  == Admin
    // // cur_state == CMD
    // // Cmd? > Add user > state: USERNAME > Username?
    // #(time_between_test_inputs) apply_test(4'bXXXX, CMD_KEY__ADD_USER);
    
    // // cur_user  == Admin
    // // Username? > admin's username (taken so will give error) > username taken > Cmd?
    // #(time_between_test_inputs) apply_test(4'bXXXX, ADMIN_USERNAME);
    
    
    // PERMS errors
    // VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
        
    // // cur_user  == Admin
    // // Cmd? > Add user > state: USERNAME > Username?
    // #(time_between_test_inputs) apply_test(4'bXXXX, CMD_KEY__ADD_USER);
    
    // // cur_user  == Admin
    // // Username? > non-taken username > Password?
    // #(time_between_test_inputs) apply_test(4'bXXXX, "Us1");   

    // // cur_user  == Admin
    // // Password? > any password > Perms?
    // #(time_between_test_inputs) apply_test(4'bXXXX, "Ps1");     
    
    // // cur_user  == Admin
    // // Perms? > invalid perm type > invalid perm type > Cmd?
    // #(time_between_test_inputs) apply_test(4'bXXXX, "qqq");     

    // VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
    //
    // Add User: Us1 - seller
    //
    // VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
        
    // cur_user  == Admin
    // Cmd? > Add user > state: USERNAME > Username?
    #(time_between_test_inputs) apply_test(4'bXXXX, CMD_KEY__ADD_USER);
    
    // cur_user  == Admin
    // Username? > non-taken username > Password?
    #(time_between_test_inputs) apply_test(4'bXXXX, "Us1");   

    // cur_user  == Admin
    // Password? > any password > Perms?
    #(time_between_test_inputs) apply_test(4'bXXXX, "Ps1");     
    
    // cur_user  == Admin
    // Perms? > invalid perm type > seller perm type > User Added > Cmd?
    #(time_between_test_inputs) apply_test(4'bXXXX, PERM_KEY__SELLER);    
    

    // // VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
    // // Add User: Ub1 - Buyer
    // // VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
    // #(time_between_test_inputs) apply_test(4'bXXXX, CMD_KEY__ADD_USER);
    // #(time_between_test_inputs) apply_test(4'bXXXX, "Ub1");   
    // #(time_between_test_inputs) apply_test(4'bXXXX, "Pb1");     
    // #(time_between_test_inputs) apply_test(4'bXXXX, PERM_KEY__BUYER); 
    
    // // VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
    // // Add 2 Users: Us2 - Seller , Ub2 - Buyer
    // // VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
    // #(time_between_test_inputs) apply_test(4'bXXXX, CMD_KEY__ADD_USER);
    // #(time_between_test_inputs) apply_test(4'bXXXX, "Us2");   
    // #(time_between_test_inputs) apply_test(4'bXXXX, "Ps2");     
    // #(time_between_test_inputs) apply_test(4'bXXXX, PERM_KEY__SELLER); 
    
    // #(time_between_test_inputs) apply_test(4'bXXXX, CMD_KEY__ADD_USER);
    // #(time_between_test_inputs) apply_test(4'bXXXX, "Ub2");   
    // #(time_between_test_inputs) apply_test(4'bXXXX, "Pb2");     
    // #(time_between_test_inputs) apply_test(4'bXXXX, PERM_KEY__BUYER);   

    // // Users Full Error
    // //                    Dependencies: Add User: Us1 - seller
    // //                                  Add User: Ub1 - Buyer
    // //                                  Add 2 Users: Us2 - Seller , Ub2 - Buyer
    // //                                  run 3700ns
    // // VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV   
    // // cur_user  == Admin
    // // Cmd? > Add user > Users full > Cmd?
    // #(time_between_test_inputs) apply_test(4'bXXXX, CMD_KEY__ADD_USER);
    
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    //  Delete User  -  Dependencies: Login Admin
    //                  Add User: Us1 - seller              
    //
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////    
     
    // cant del admin !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    
    // USERNAME errors
    // VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
    
    // cur_user  == Admin
    // Cmd? > Del user > Username?
    #(time_between_test_inputs) apply_test(4'bXXXX, CMD_KEY__DELETE_USER);
    
    // Username? > unknown username > Unknown username > Cmd?
    #(time_between_test_inputs) apply_test(4'bXXXX, "qqq");   
  

    
  end

endmodule















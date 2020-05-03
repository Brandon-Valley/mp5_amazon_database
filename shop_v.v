// -- python C:\Users\Brandon\Documents\Personal_Projects\my_utils\modelsim_utils\auto_run.py -d run_cmd__shop_v.do




module shop_v



  #(
  
    parameter I_A_NUM_BITS          = 24       ,
    parameter I_U_NUM_BITS          = 4        ,
    parameter O_A_NUM_BITS          = 24       ,
  
    parameter MAX_USERS             = 5        ,  // includes admin
  
    parameter CMD_KEY__LOGOUT       = "Logout" ,
    parameter CMD_KEY__LOGIN        = "Login"  ,
    parameter CMD_KEY__ADD_USER     = "AddUsr" ,
    parameter CMD_KEY__DELETE_USER  = "DelUsr" ,
    parameter CMD_KEY__ADD_ITEM     = "AddItem",
    parameter CMD_KEY__DELETE_ITEM  = "DelItem",
    parameter CMD_KEY__BUY          = "Buy"    ,
    parameter CMD_KEY__NONE         = "NONE"   ,
  
    parameter ADMIN_USERNAME        = "Adm"    
  )(
    input                                i_clk,
    input                                i_reset, // must be set high then low at start of tb
    input                                i_rdy,    
    input  unsigned [I_U_NUM_BITS - 1:0] i_u,
    input           [I_A_NUM_BITS - 1:0] i_a,
    output reg      [O_A_NUM_BITS - 1:0] o_a
  );
  
  
  // assign o_a = "hi?"; // testing !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  
  
  // internal registers
  reg unsigned [2 ** (MAX_USERS -1):0] cur_user_num;
  
  reg [I_A_NUM_BITS - 1:0] cur_cmd;
  
  reg in_a_valid_cmd;
  reg user_has_perms_for_i_a_cmd;
  reg in_a_known_username;
  reg cur_username;
  reg cur_user_perms;
  
  reg out__ask_cmd        ;
  reg out__invalid_cmd    ;
  reg out__invalid_perms  ;
  reg out__ask_username   ;
  reg out__username_unkown;
  reg out__username_taken ;
  reg out__cant_del_admin ;
  
  // define states
  parameter [2:0] state_cmd        = 3'b000,
                  state_username   = 3'b001,
                  state_password   = 3'b010,
                  state_perms      = 3'b011,
                  state_item_name  = 3'b100,
                  state_item_stock = 3'b101
                  ;
  reg [2:0] cur_state;
  reg [2:0] next_state;
  
  // do eqn / behave assigns with on always blocks VVVVVV, testing @!!!!!!!!!!!!!
  
  
  // reset logic
  // reset must be set high then low at start of tb to set init state
  // Async. reset
  always @(posedge i_clk or posedge i_reset) begin
    if (i_reset) cur_state <= state_cmd;
    else cur_state <= next_state;
  end
  

  // next state logic
  always @(posedge i_clk) begin
    case(cur_state)
      
      // cmd
      state_cmd:  
      begin
        if ( i_rdy & in_a_valid_cmd & user_has_perms_for_i_a_cmd) 
          begin 
            // you already know you will be moving to a new state, so save the cmd
            cur_cmd = i_a;
            
            case(i_a)
              // CMD_KEY__LOGOUT     :  next_state = 
              CMD_KEY__LOGIN      :  next_state = state_cmd       ;
              CMD_KEY__ADD_USER   :  next_state = state_username  ;
              CMD_KEY__DELETE_USER:  next_state = state_password  ;
              CMD_KEY__ADD_ITEM   :  next_state = state_perms     ;
              CMD_KEY__DELETE_ITEM:  next_state = state_item_name ;
              CMD_KEY__BUY        :  next_state = state_item_stock;
            endcase
          end
          
        else
          begin
            next_state = state_cmd;
            cur_cmd = CMD_KEY__NONE;
          end
      end
                  
      // // username            
      // state_username:
      // begin
      
      
        // // if  (cur_cmd === CMD_KEY__LOGIN      ) & i_rdy & (   in_a_known_username) )
        // // // if  (cur_cmd === CMD_KEY__LOGIN      ) )
        // // // if  ( i_rdy & in_a_valid_cmd & user_has_perms_for_i_a_cmd) 
          // // begin 
            // // // you already know you will be moving to a new state, so save the cmd
            // // cur_cmd = i_a;
            
            // // case(i_a)
              // // // CMD_KEY__LOGOUT     :  next_state = 
              // // CMD_KEY__LOGIN      :  next_state = state_cmd       ;
              // // CMD_KEY__ADD_USER   :  next_state = state_username  ;
              // // CMD_KEY__DELETE_USER:  next_state = state_password  ;
              // // CMD_KEY__ADD_ITEM   :  next_state = state_perms     ;
              // // CMD_KEY__DELETE_ITEM:  next_state = state_item_name ;
              // // CMD_KEY__BUY        :  next_state = state_item_stock;
            // // endcase
          // // end
        // if      ( (cur_cmd = CMD_KEY__LOGIN      ) & i_rdy & (   in_a_known_username) )                                     next_state = state_password;
        // else if ( (cur_cmd = CMD_KEY__ADD_USER   ) & i_rdy & (!  in_a_known_username) )                                     next_state = state_password;
         // // else if ( (cut_cmd = CMD_KEY__DELETE_USER) & i_rdy & (   in_a_known_username) & (cur_username != ADMIN_USERNAME) )  next_state = state_cmd + delete the user?????;
         
        // // assign next_state = ( (cur_cmd = CMD_KEY__LOGIN      ) & i_rdy & (   in_a_known_username) )  ?  state_password;
        // // assign next_state =  state_password;
         
        // // if      ( (cur_cmd = CMD_KEY__LOGIN      ) & i_rdy & (   in_a_known_username) ) 
        // // begin
          // // assign next_state = state_password;
        // // end
        // // else if ( (cur_cmd = CMD_KEY__ADD_USER   ) & i_rdy & (!  in_a_known_username) ) begin                                  next_state <= state_password end;
         // // else if ( (cut_cmd = CMD_KEY__DELETE_USER) & i_rdy & (   in_a_known_username) & (cur_username != ADMIN_USERNAME) )  next_state = state_cmd + delete the user?????;
      // end
      
      
    endcase
  end
  
  

  
  // output print logic
  always @(posedge i_clk) begin
    if (out__ask_cmd        ) o_a <= "Cmd?";
    // if (out__ask_cmd        ) assign o_a = "Cmd?";
    // if (out__invalid_cmd    ) o_a <= "InvalCmd";
    // if (out__invalid_perms  ) o_a <= "InvalPerm";
    // if (out__ask_username   ) o_a <= "Usrname?";
    // if (out__username_unkown) o_a <= "UsrUnknwn";
    // if (out__username_taken ) o_a <= "UsrTaken";
    // if (out__cant_del_admin ) o_a <= "NoDelAdmn";
  end  
  
  
  
  
  // main combinational logic
  always @(posedge i_clk) begin
    // reset outs
    // EX: out__ask_cmd <= 1'b0;  // maybe just =?
    
    // test VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
    out__ask_cmd <= 1'b1;
    
    // main VVVVVVVVVV
  end  
  
endmodule


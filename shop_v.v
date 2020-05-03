// -- python C:\Users\Brandon\Documents\Personal_Projects\my_utils\modelsim_utils\auto_run.py -d run_cmd__shop_v.do

module shop_v
  #(
    parameter I_A_NUM_ASCII_CHARS   = 7                      , // must fit longest CMD_KEY
    parameter O_A_NUM_ASCII_CHARS   = 9                      , // must fit longest out__
  
    parameter I_A_NUM_BITS          = I_A_NUM_ASCII_CHARS * 8,
    parameter I_U_NUM_BITS          = 4                      , // max 15
    parameter O_A_NUM_BITS          = O_A_NUM_ASCII_CHARS * 8,
  
    parameter MAX_USERS             = 5                      ,  // includes admin
                                                             
    parameter CMD_KEY__LOGOUT       = "Logout"               ,
    parameter CMD_KEY__LOGIN        = "Login"                ,
    parameter CMD_KEY__ADD_USER     = "AddUsr"               ,
    parameter CMD_KEY__DELETE_USER  = "DelUsr"               ,
    parameter CMD_KEY__ADD_ITEM     = "AddItem"              ,
    parameter CMD_KEY__DELETE_ITEM  = "DelItem"              ,
    parameter CMD_KEY__BUY          = "Buy"                  ,
    parameter CMD_KEY__NONE         = "NONE"                 ,
  
    parameter ADMIN_USERNAME        = "Adm"    
  )(
    input                                i_clk,
    input                                i_reset, // must be set high then low at start of tb
    input                                i_rdy,    
    input  unsigned [I_U_NUM_BITS - 1:0] i_u,
    input           [I_A_NUM_BITS - 1:0] i_a,
    output reg      [O_A_NUM_BITS - 1:0] o_a
  );
    
  
  // internal registers
  reg unsigned [2 ** (MAX_USERS -1):0] cur_user_num;
  
  reg [I_A_NUM_BITS - 1:0] cur_cmd;
  
  wire in_a_valid_cmd;
  reg user_has_perms_for_i_a_cmd;
  reg in_a_known_username;
  reg cur_username;
  wire cur_user_perms;
  
  reg out__ask_cmd        ;
  reg out__invalid_cmd    ;
  reg out__invalid_perms  ;
  reg out__ask_username   ;
  reg out__username_unkown;
  reg out__username_taken ;
  reg out__cant_del_admin ;
  reg out__user_deleted   ;
  reg out__items_full     ;
  reg out__ask_item_name  ;
  reg out__item_exists    ;
  reg out__ask_stock      ;
  reg out__item_added     ;
  reg out__item_unknown   ;
  reg out__not_your_item  ;
  reg out__item_deleted   ;
  reg out__no_stock       ;
  reg out__item_bought    ;
 
  
  
  assign in_a_valid_cmd = i_a == CMD_KEY__LOGOUT      |
                          i_a == CMD_KEY__LOGIN       |
                          i_a == CMD_KEY__ADD_USER    |
                          i_a == CMD_KEY__DELETE_USER |
                          i_a == CMD_KEY__ADD_ITEM    |
                          i_a == CMD_KEY__DELETE_ITEM |
                          i_a == CMD_KEY__BUY         ? 1'b1 : 1'b0;
                          
  // assign in_a_valid_cmd = i_rdy ? 1'b1 : 1'b0;
  // assign in_a_valid_cmd = i_a == CMD_KEY__LOGIN       ? 1'b1 : 1'b0;
  // (i_a = CMD_KEY__LOGOUT     ) |
                          // (i_a = CMD_KEY__LOGIN      ) |
                          // (i_a = CMD_KEY__ADD_USER   ) |
                          // (i_a = CMD_KEY__DELETE_USER) |
                          // (i_a = CMD_KEY__ADD_ITEM   ) |
                          // (i_a = CMD_KEY__DELETE_ITEM) |
                          // (i_a = CMD_KEY__BUY        ) ? 1'b1 : 1'b0;
  
  
  // wire rdy_i = i_rdy;
  
  // if ( rdy_i )
  // begin
    // assign cur_user_perms = 1'b1;
  // end
  
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
    // no 2 outs should ever be high at the same time
    if (out__ask_cmd        ) o_a <= "Cmd?";
    if (out__invalid_cmd    ) o_a <= "InvalCmd";
    if (out__invalid_perms  ) o_a <= "InvalPerm";
    if (out__ask_username   ) o_a <= "Usrname?";
    if (out__username_unkown) o_a <= "UsrUnknwn";
    if (out__username_taken ) o_a <= "UsrTaken";
    if (out__cant_del_admin ) o_a <= "NoDelAdmn";
    
    if (out__user_deleted   ) o_a <= "UsrDeletd";
    if (out__items_full     ) o_a <= "ItmsFull";
    if (out__ask_item_name  ) o_a <= "ItmName?";
    if (out__item_exists    ) o_a <= "ItmExists";
    if (out__ask_stock      ) o_a <= "Stock?";
    if (out__item_added     ) o_a <= "ItmAdded";
    if (out__item_unknown   ) o_a <= "ItmUnknwn";
    if (out__not_your_item  ) o_a <= "NtYourItm";
    if (out__item_deleted   ) o_a <= "ItmDeletd";
    if (out__no_stock       ) o_a <= "NoStock";
    if (out__item_bought    ) o_a <= "ItmBought";
    
  end  
  
  
  
  
  // main combinational logic
  always @(posedge i_clk) begin
  
    out__ask_cmd         <= 1'b0;
    out__invalid_cmd     <= 1'b0;
    out__invalid_perms   <= 1'b0;
    out__ask_username    <= 1'b0;
    out__username_unkown <= 1'b0;
    out__username_taken  <= 1'b0;
    out__cant_del_admin  <= 1'b0;
    out__user_deleted    <= 1'b0;
    out__items_full      <= 1'b0;
    out__ask_item_name   <= 1'b0;
    out__item_exists     <= 1'b0;
    out__ask_stock       <= 1'b0;
    out__item_added      <= 1'b0;
    out__item_unknown    <= 1'b0;
    out__not_your_item   <= 1'b0;
    out__item_deleted    <= 1'b0;
    out__no_stock        <= 1'b0;
    out__item_bought     <= 1'b0;
    
    
    
  
  
    // reset outs
    // EX: out__ask_cmd <= 1'b0;  // maybe just =?
    
    // test VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
    if (! in_a_valid_cmd)
      out__ask_cmd <= 1'b1;
    else
      out__ask_item_name <= 1'b1;
    
    // main VVVVVVVVVV
  end  
  
endmodule


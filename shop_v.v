// -- python C:\Users\Brandon\Documents\Personal_Projects\my_utils\modelsim_utils\auto_run.py -d run_cmd__shop_v.do

module shop_v
  #(
    parameter I_A_NUM_ASCII_CHARS   = 7                      , // must fit longest CMD_KEY
    parameter O_A_NUM_ASCII_CHARS   = 9                      , // must fit longest out__
  
    parameter I_A_NUM_BITS          = I_A_NUM_ASCII_CHARS * 8,
    parameter I_U_NUM_BITS          = 4                      , // max 15
    parameter O_A_NUM_BITS          = O_A_NUM_ASCII_CHARS * 8,
      
    parameter MAX_USERS             = 6                      ,  // includes admin(1) and empty(0)
    
    parameter ADMIN_USERNAME        = "Adm"                  ,    

    // command keys
    parameter CMD_KEY__LOGOUT       = "Logout"               ,
    parameter CMD_KEY__LOGIN        = "Login"                ,
    parameter CMD_KEY__ADD_USER     = "AddUsr"               ,
    parameter CMD_KEY__DELETE_USER  = "DelUsr"               ,
    parameter CMD_KEY__ADD_ITEM     = "AddItem"              ,
    parameter CMD_KEY__DELETE_ITEM  = "DelItem"              ,
    parameter CMD_KEY__BUY          = "Buy"                  ,
    parameter CMD_KEY__NONE         = "NONE"                 ,
      
    // states
    parameter STATE_NUM_ASCII_BITS  = 7                      ,
   
    parameter STATE__CMD            = "CMD"                  ,
    parameter STATE__USERNAME       = "USRNAME"              ,
    parameter STATE__PASSWORD       = "PASSWRD"              ,
    parameter STATE__PERMS          = "PERMS"                ,
    parameter STATE__ITEM_NAME      = "ITMNAME"              ,
    parameter STATE__ITEM_STOCK     = "ITMSTCK"              ,

    // out strings
    parameter OUT_STR__ASK_CMD         = "Cmd?"              , 
    parameter OUT_STR__INVALID_CMD     = "InvalCmd"          ,
    parameter OUT_STR__INVALID_PERMS   = "InvalPerm"         ,
    parameter OUT_STR__ASK_USERNAME    = "Usrname?"          ,
    parameter OUT_STR__USERNAME_UNKOWN = "UsrUnknwn"         , 
    parameter OUT_STR__USERNAME_TAKEN  = "UsrTaken"          ,
    parameter OUT_STR__CANT_DEL_ADMIN  = "NoDelAdmn"         , 

    parameter OUT_STR__USER_DELETED    = "UsrDeletd"         , 
    parameter OUT_STR__ITEMS_FULL      = "ItmsFull"          ,
    parameter OUT_STR__ASK_ITEM_NAME   = "ItmName?"          ,
    parameter OUT_STR__ITEM_EXISTS     = "ItmExists"         , 
    parameter OUT_STR__ASK_STOCK       = "Stock?"            ,
    parameter OUT_STR__ITEM_ADDED      = "ItmAdded"          ,
    parameter OUT_STR__ITEM_UNKNOWN    = "ItmUnknwn"         , 
    parameter OUT_STR__NOT_YOUR_ITEM   = "NtYourItm"         , 
    parameter OUT_STR__ITEM_DELETED    = "ItmDeletd"         , 
    parameter OUT_STR__NO_STOCK        = "NoStock"           ,
    parameter OUT_STR__ITEM_BOUGHT     = "ItmBought"            

  )(
    input                                  i_clk,
    input                                  i_reset, // must be set high then low at start of tb
    input                                  i_rdy,   // must be set low at start of tb 
    input  unsigned [(I_U_NUM_BITS - 1):0] i_u,
    input           [(I_A_NUM_BITS - 1):0] i_a,
    
    output reg      [(O_A_NUM_BITS - 1):0] o_a
  );
    
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  //  Not Always
  //
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
  
  
  // internal registers
  reg unsigned [2 ** (MAX_USERS -1):0] cur_user_num;
  
  reg [I_A_NUM_BITS - 1:0] cur_cmd;
  
  reg [(STATE_NUM_ASCII_BITS * 8) - 1:0] cur_state;
  reg [(STATE_NUM_ASCII_BITS * 8) - 1:0] next_state;
  
  wire in_a_valid_cmd;
  wire user_has_perms_for_i_a_cmd;
  reg in_a_known_username;
  reg cur_username;
  wire cur_user_perms;
  
  // reg out__ask_cmd        ;
  // reg out__invalid_cmd    ;
  // reg out__invalid_perms  ;
  // reg out__ask_username   ;
  // reg out__username_unkown;
  // reg out__username_taken ;
  // reg out__cant_del_admin ;
  // reg out__user_deleted   ;
  // reg out__items_full     ;
  // reg out__ask_item_name  ;
  // reg out__item_exists    ;
  // reg out__ask_stock      ;
  // reg out__item_added     ;
  // reg out__item_unknown   ;
  // reg out__not_your_item  ;
  // reg out__item_deleted   ;
  // reg out__no_stock       ;
  // reg out__item_bought    ;
  
  // user vectors
  reg [MAX_USERS - 1   :0] uv__slot_taken;
  reg [I_A_NUM_BITS - 1:0] uv__usernames [MAX_USERS - 1:0];
  reg [I_A_NUM_BITS - 1:0] uv__passwords [MAX_USERS - 1:0];
  reg [I_A_NUM_BITS - 1:0] uv__perms     [MAX_USERS - 1:0];

  
 
  
  // 1 / 0 if in_a is a valid cmd
  assign in_a_valid_cmd = i_a == CMD_KEY__LOGOUT      |
                          i_a == CMD_KEY__LOGIN       |
                          i_a == CMD_KEY__ADD_USER    |
                          i_a == CMD_KEY__DELETE_USER |
                          i_a == CMD_KEY__ADD_ITEM    |
                          i_a == CMD_KEY__DELETE_ITEM |
                          i_a == CMD_KEY__BUY         ? 1'b1 : 1'b0;
  
  
  
  
  
  
  
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  //  Always Blocks
  //
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  //  FSM
  //
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
  // reset logic
  // reset must be set high then low at start of tb to set init state
  // Async. reset
  always @(posedge i_clk or posedge i_reset) begin
    if (i_reset == 1'b1) cur_state = STATE__CMD;
    else cur_state <= next_state;
  end
  

  // next state logic
  always @(posedge i_clk) begin
    case(cur_state)
      
      // cmd
      STATE__CMD:  
      begin
        if ( i_rdy & in_a_valid_cmd & user_has_perms_for_i_a_cmd) 
          begin 
            // you already know you will be moving to a new state, so save the cmd
            cur_cmd = i_a;
            
            case(i_a)
              // CMD_KEY__LOGOUT     :  next_state = 
              CMD_KEY__LOGIN      :  next_state = STATE__CMD       ;
              CMD_KEY__ADD_USER   :  next_state = STATE__USERNAME  ;
              CMD_KEY__DELETE_USER:  next_state = STATE__PASSWORD  ;
              CMD_KEY__ADD_ITEM   :  next_state = STATE__PERMS     ;
              CMD_KEY__DELETE_ITEM:  next_state = STATE__ITEM_NAME ;
              CMD_KEY__BUY        :  next_state = STATE__ITEM_STOCK;
            endcase
          end
          
        else
          begin
            next_state = STATE__CMD;
            cur_cmd = CMD_KEY__NONE;
          end
      end
                  
      // username            
      STATE__USERNAME:
      begin

        if      ( cur_cmd == CMD_KEY__LOGIN    & i_rdy &   in_a_known_username )                                     next_state = STATE__PASSWORD;
        else if ( cur_cmd == CMD_KEY__ADD_USER & i_rdy & ! in_a_known_username )                                     next_state = STATE__PASSWORD;
         // else if ( (cut_cmd = CMD_KEY__DELETE_USER) & i_rdy & (   in_a_known_username) & (cur_username != ADMIN_USERNAME) )  next_state = STATE__CMD + delete the user?????;
        
      end
      
      
    endcase
  end
  
  

  
  // // output print logic
  // always @(posedge i_clk) begin
    // // no 2 outs should ever be high at the same time
    // if (out__ask_cmd        ) o_a <= "Cmd?";
    // if (out__invalid_cmd    ) o_a <= "InvalCmd";
    // if (out__invalid_perms  ) o_a <= "InvalPerm";
    // if (out__ask_username   ) o_a <= "Usrname?";
    // if (out__username_unkown) o_a <= "UsrUnknwn";
    // if (out__username_taken ) o_a <= "UsrTaken";
    // if (out__cant_del_admin ) o_a <= "NoDelAdmn";
    
    // if (out__user_deleted   ) o_a <= "UsrDeletd";
    // if (out__items_full     ) o_a <= "ItmsFull";
    // if (out__ask_item_name  ) o_a <= "ItmName?";
    // if (out__item_exists    ) o_a <= "ItmExists";
    // if (out__ask_stock      ) o_a <= "Stock?";
    // if (out__item_added     ) o_a <= "ItmAdded";
    // if (out__item_unknown   ) o_a <= "ItmUnknwn";
    // if (out__not_your_item  ) o_a <= "NtYourItm";
    // if (out__item_deleted   ) o_a <= "ItmDeletd";
    // if (out__no_stock       ) o_a <= "NoStock";
    // if (out__item_bought    ) o_a <= "ItmBought";
    
  // end  
  
  
  
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  //  Main Combinational Logic
  //
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



  // main combinational logic
  always @(posedge i_clk) begin
     
    // // state: CMD
    // out__ask_cmd         <= 1'b0;
    // out__invalid_cmd     <= 1'b0;
    // out__invalid_perms   <= 1'b0;
    
    // // state outs: USERNAME
    // out__ask_username    <= 1'b0;
    // out__username_unkown <= 1'b0;
    // out__username_taken  <= 1'b0;
    // out__cant_del_admin  <= 1'b0;
    // out__user_deleted    <= 1'b0;



    ///////////////////////////////
    //
    // state logic: CMD 
    //
    ///////////////////////////////
    if (cur_state == STATE__CMD)
    begin
      if      ( ! i_rdy                    ) o_a <= OUT_STR__ASK_CMD;//  out__ask_cmd     <= 1'b1;
      else if (   i_rdy & ! in_a_valid_cmd ) o_a <= OUT_STR__INVALID_CMD; //out__invalid_cmd <= 1'b1;
    end
    
    
    // if (out__ask_cmd        ) o_a <= "Cmd???";
    
    
    
    
    ///////////////////////////////
    //
    // state logic: USERNAME
    //
    ///////////////////////////////
  
  

  end  
  
  
  
  
    // // output print logic
  // always @(posedge i_clk) begin
    // // no 2 outs should ever be high at the same time
    // if (out__ask_cmd        ) o_a <= "Cmd?";
    // if (out__invalid_cmd    ) o_a <= "InvalCmd";
    // if (out__invalid_perms  ) o_a <= "InvalPerm";
    // if (out__ask_username   ) o_a <= "Usrname?";
    // if (out__username_unkown) o_a <= "UsrUnknwn";
    // if (out__username_taken ) o_a <= "UsrTaken";
    // if (out__cant_del_admin ) o_a <= "NoDelAdmn";
    
    // if (out__user_deleted   ) o_a <= "UsrDeletd";
    // if (out__items_full     ) o_a <= "ItmsFull";
    // if (out__ask_item_name  ) o_a <= "ItmName?";
    // if (out__item_exists    ) o_a <= "ItmExists";
    // if (out__ask_stock      ) o_a <= "Stock?";
    // if (out__item_added     ) o_a <= "ItmAdded";
    // if (out__item_unknown   ) o_a <= "ItmUnknwn";
    // if (out__not_your_item  ) o_a <= "NtYourItm";
    // if (out__item_deleted   ) o_a <= "ItmDeletd";
    // if (out__no_stock       ) o_a <= "NoStock";
    // if (out__item_bought    ) o_a <= "ItmBought";
    
  // end  
  
  
  
  
  // /////////////////////////////////////////////////////////////////////////////////////////////////
  
  // ///////////////////////////////
  // //
  // // state logic: CMD 
  // //
  // ///////////////////////////////
  // always @(posedge i_clk) begin
    // out__ask_cmd         <= 1'b0;
    // out__invalid_cmd     <= 1'b0;
    // out__invalid_perms   <= 1'b0;

    // if (cur_state == STATE__CMD)
    // begin
      // if      ( ! i_rdy                    ) out__ask_cmd     <= 1'b1;
      // else if (   i_rdy & ! in_a_valid_cmd ) out__invalid_cmd <= 1'b1;
    // end
    
    
    // if (out__ask_cmd        ) o_a <= "Cmd???";
    
    
    
    
    
    // // // test VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
    // // if (! in_a_valid_cmd)
      // // out__ask_cmd <= 1'b1;
    // // else
      // // out__ask_item_name <= 1'b1;
    
    // // main VVVVVVVVVV
  // end  
  

  // ///////////////////////////
  
  // // state logic: USERNAME
  
  // ///////////////////////////
  // always @(posedge i_clk) begin
    // out__ask_username    <= 1'b0;
    // out__username_unkown <= 1'b0;
    // out__username_taken  <= 1'b0;
    // out__cant_del_admin  <= 1'b0;
    // out__user_deleted    <= 1'b0;
  // end  
  

  // ///////////////////////////////
  // //
  // // state logic: PASSWORD
  // //
  // ///////////////////////////////  
  // always @(posedge i_clk) begin
  // end  
  
  
  // ///////////////////////////////
  // //  
  // // state logic: PERMS
  // //
  // ///////////////////////////////
  // always @(posedge i_clk) begin
  // end  
  
 
  // ///////////////////////////////
  // //
  // // state logic: ITEM NAME
  // //
  // ///////////////////////////////  
  // always @(posedge i_clk) begin
    // out__items_full      <= 1'b0;
    // out__ask_item_name   <= 1'b0;
    // out__item_exists     <= 1'b0;
    // out__item_unknown    <= 1'b0;
    // out__not_your_item   <= 1'b0;
    // out__item_deleted    <= 1'b0;
    // out__no_stock        <= 1'b0;
    // out__item_bought     <= 1'b0;
  // end  


  // ///////////////////////////////
  // //
  // // state logic: STOCK
  // //
  // ///////////////////////////////  
  // always @(posedge i_clk) begin   
    // out__ask_stock       <= 1'b0;
    // out__item_added      <= 1'b0;
  // end  
  

  
endmodule
// -- python C:\Users\Brandon\Documents\Personal_Projects\my_utils\modelsim_utils\auto_run.py -d run_cmd__shop_v.do

module shop_v
  #(
    parameter I_A_NUM_ASCII_CHARS   = 7                      , // must fit longest CMD_KEY
    parameter O_A_NUM_ASCII_CHARS   = 9                      , // must fit longest out__
  
    parameter I_A_NUM_BITS          = I_A_NUM_ASCII_CHARS * 8,
    parameter I_U_NUM_BITS          = 4                      , // max 15
    parameter O_A_NUM_BITS          = O_A_NUM_ASCII_CHARS * 8,
      
    parameter MAX_USERS             = 6                      ,  // includes admin(1) and empty(0)
    parameter NUM_BITS_MAX_USER_NUM = 3                      ,  // [log2(MAX_USERS - 1)]+1
    
    
    // default empy and admin
    parameter ADMIN_USERNAME        = "Adm"                  ,    
    parameter EMPTY_USERNAME        = "Nnn"                  ,   
    
    parameter ADMIN_PASSWORD        = "123"                  ,    
    parameter EMPTY_PASSWORD        = "nnn"                  ,    
    
    parameter ADMIN_USER_NUM        = 1                      ,    
    parameter EMPTY_USER_NUM        = 0                      ,  
    parameter NO_USER_NUM           = 4'bZZZ                 ,  // num bits  = NUM_BITS_MAX_USER_NUM

    //perm keys
    parameter PERM_KEY__EMPTY       = "EMPTY"                ,
    parameter PERM_KEY__ADMIN       = "ADMIN"                ,
    parameter PERM_KEY__SELLER      = "SELLER"               ,
    parameter PERM_KEY__BUYER       = "BUYER"                ,
    
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
    parameter STATE__STOCK          = "ITMSTCK"              ,

    // out strings
    // CMD
    parameter OUT_STR__ASK_CMD         = "Cmd?"              , 
    parameter OUT_STR__INVALID_CMD     = "InvalCmd"          ,
    parameter OUT_STR__INVALID_PERMS   = "InvalPerm"         ,
    
    // USERNAME
    parameter OUT_STR__ASK_USERNAME    = "Username?"         ,
    parameter OUT_STR__UNKOWN_USERNAME = "UnkwnUser"         ,
    parameter OUT_STR__USERNAME_UNKOWN = "UsrUnknwn"         , 
    parameter OUT_STR__USERNAME_TAKEN  = "UsrTaken"          ,
    parameter OUT_STR__CANT_DEL_ADMIN  = "NoDelAdmn"         , 
    parameter OUT_STR__USER_DELETED    = "UsrDeletd"         , 
    
    // PASSWORD
    parameter OUT_STR__ASK_PASSWORD    = "Password?"         ,
    parameter OUT_STR__PASSWORD_WRONG  = "WrongPass"         ,

    
    parameter OUT_STR__ITEMS_FULL      = "ItmsFull"          ,
    parameter OUT_STR__ASK_ITEM_NAME   = "ItmName?"          ,
    parameter OUT_STR__ITEM_EXISTS     = "ItmExists"         , 
    parameter OUT_STR__ASK_STOCK       = "Stock?"            ,
    parameter OUT_STR__ITEM_ADDED      = "ItmAdded"          ,
    parameter OUT_STR__ITEM_UNKNOWN    = "ItmUnknwn"         , 
    parameter OUT_STR__NOT_YOUR_ITEM   = "NtYourItm"         , 
    parameter OUT_STR__ITEM_DELETED    = "ItmDeletd"         , 
    parameter OUT_STR__NO_STOCK        = "NoStock"           ,
    parameter OUT_STR__ITEM_BOUGHT     = "ItmBought"         , 
    
    parameter OUT_STR__ASK_PERMS       = "Perms?"            

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
  
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  //  Declarations
  //
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
  // internal registers
  
  // reg unsigned [2 ** (MAX_USERS -1):0] cur_user_num;
  
  reg [I_A_NUM_BITS - 1:0] cur_cmd; // the current VALIDATD command, has nothing to do with checking if user has perms to execute given cmd
  
  reg [(STATE_NUM_ASCII_BITS * 8) - 1:0] cur_state;
  reg [(STATE_NUM_ASCII_BITS * 8) - 1:0] next_state;
  
  reg unsigned [NUM_BITS_MAX_USER_NUM - 1:0] given_user__num; // num for user given by user by username
  
  reg unsigned [NUM_BITS_MAX_USER_NUM - 1:0] cur_user__num;
  reg [I_A_NUM_BITS - 1:0] cur_user__username;
  reg [I_A_NUM_BITS - 1:0] cur_user__password;
  reg [I_A_NUM_BITS - 1:0] cur_user__perms;
  
  reg                                        in_a__known_username;
  wire                                       in_a__valid_cmd; // don't need this declaration because assigned, just here to keep things straight
  reg                                        in_a__valid_cmd__user_has_perms_for;
  reg                                        in_a__correct_password_for__given_user;
  reg unsigned [NUM_BITS_MAX_USER_NUM - 1:0] in_a__user_num__if__known_username;
  
  // wire user_has_perms_for_i_a_cmd;


  
  // user vectors
  reg [MAX_USERS    - 1:0] uv__slot_taken;
  reg [I_A_NUM_BITS - 1:0] uv__usernames [MAX_USERS - 1:0];
  reg [I_A_NUM_BITS - 1:0] uv__passwords [MAX_USERS - 1:0];
  reg [I_A_NUM_BITS - 1:0] uv__perms     [MAX_USERS - 1:0];


  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  //  Assigns
  //
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
  
  // 1 / 0 if in_a is a valid cmd
  assign in_a__valid_cmd = i_a == CMD_KEY__LOGOUT      |
                           i_a == CMD_KEY__LOGIN       |
                           i_a == CMD_KEY__ADD_USER    |
                           i_a == CMD_KEY__DELETE_USER |
                           i_a == CMD_KEY__ADD_ITEM    |
                           i_a == CMD_KEY__DELETE_ITEM |
                           i_a == CMD_KEY__BUY         ? 1'b1 : 1'b0;
                          
                          
  // assign cur_user__username = uv__usernames[cur_user__num];

                          
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
    if (i_reset) 
      begin 
        cur_state = STATE__CMD;
        // reset_i = 1'b1;
      end
    else 
      begin
        cur_state = next_state;
        // reset_i = 1'b0;
      end
  end
  


  // next state logic
  always @(posedge i_clk) begin
    case(cur_state)
      
      
      // CMD
      STATE__CMD:  
      begin
        if ( i_rdy & in_a__valid_cmd__user_has_perms_for) 
          begin 
            // you already know you will be moving to a new state, so save the cmd
            cur_cmd = i_a;
            
            case(i_a)
              // CMD_KEY__LOGOUT     :  next_state = 
              CMD_KEY__LOGIN      :  next_state = STATE__USERNAME  ;
              CMD_KEY__ADD_USER   :  next_state = STATE__USERNAME  ;
              CMD_KEY__DELETE_USER:  next_state = STATE__PASSWORD  ;
              CMD_KEY__ADD_ITEM   :  next_state = STATE__PERMS     ;
              CMD_KEY__DELETE_ITEM:  next_state = STATE__ITEM_NAME ;
              CMD_KEY__BUY        :  next_state = STATE__STOCK;
            endcase
          end
          
        else
          begin
            next_state = STATE__CMD;
            cur_cmd = CMD_KEY__NONE;
          end
      end
                  
                  
      // USERNAME          
      STATE__USERNAME:
      begin        
        if      ( cur_cmd == CMD_KEY__LOGIN & i_rdy & ! in_a__known_username )  begin                                                                                         
                                                                                       next_state = STATE__CMD;                               
                                                                                end
        else if ( cur_cmd == CMD_KEY__LOGIN & i_rdy &   in_a__known_username )  begin  
                                                                                       next_state = STATE__PASSWORD;  
                                                                                       given_user__num = in_a__user_num__if__known_username;
                                                                                end
        // else if ( cur_cmd == CMD_KEY__ADD_USER & i_rdy & ! in_a__known_username )  next_state = STATE__PASSWORD;
         // else if ( (cut_cmd = CMD_KEY__DELETE_USER) & i_rdy & (   in_a__known_username) & (cur_username != ADMIN_USERNAME) )  next_state = STATE__CMD + delete the user?????;
        
      end
      
      
    endcase
  end
  

  
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
    /////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    // init on reset
    //
    /////////////////////////////////////////////////////////////////////////////////////////////////////
    if (i_reset)
      begin
        // user vectors: empty(0) and admin(1)
        uv__slot_taken[EMPTY_USER_NUM] = 1'b1;
        uv__slot_taken[ADMIN_USER_NUM] = 1'b1;
        
        uv__usernames [EMPTY_USER_NUM] = EMPTY_USERNAME;
        uv__usernames [ADMIN_USER_NUM] = ADMIN_USERNAME;
        
        uv__passwords [EMPTY_USER_NUM] = EMPTY_PASSWORD;
        uv__passwords [ADMIN_USER_NUM] = ADMIN_PASSWORD;
        
        uv__perms     [EMPTY_USER_NUM] = PERM_KEY__EMPTY;
        uv__perms     [ADMIN_USER_NUM] = PERM_KEY__ADMIN;
      
        // current user num starts at empty because not logged in
        cur_user__num = EMPTY_USER_NUM;
      end
      
      
    /////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    // Always set
    //
    /////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // cur user vars
    cur_user__username = uv__usernames[cur_user__num];
    cur_user__password = uv__passwords[cur_user__num];
    cur_user__perms    = uv__perms    [cur_user__num];
    
    
    // in_a__valid_cmd__user_has_perms_for
    if (in_a__valid_cmd)
      if ( 
            (cur_user__perms == PERM_KEY__EMPTY  & ( 
                                                     i_a == CMD_KEY__LOGIN      
                                                   )                              ) | 
            (cur_user__perms == PERM_KEY__ADMIN  & ( 
                                                     i_a == CMD_KEY__LOGOUT      |
                                                     i_a == CMD_KEY__ADD_USER    |
                                                     i_a == CMD_KEY__DELETE_USER    
                                                   )                              ) |     
            (cur_user__perms == PERM_KEY__SELLER & ( 
                                                    i_a == CMD_KEY__LOGOUT      |
                                                    i_a == CMD_KEY__ADD_ITEM    |
                                                    i_a == CMD_KEY__DELETE_ITEM    
                                                   )                              ) |  
            (cur_user__perms == PERM_KEY__BUYER  & ( 
                                                    i_a == CMD_KEY__LOGOUT      |
                                                    i_a == CMD_KEY__BUY      
                                                   )                              )                                                     
                                                                                      )  in_a__valid_cmd__user_has_perms_for = 1'b1;
    else                                                                                 in_a__valid_cmd__user_has_perms_for = 1'b0;
    
    
    // in_a__known_username and in_a__user_num__if__known_username, don't check username for [0] - empty
    if      ( i_a == uv__usernames[1] ) begin  in_a__known_username = 1'b1;  in_a__user_num__if__known_username = 1;  end
    else if ( i_a == uv__usernames[2] ) begin  in_a__known_username = 1'b1;  in_a__user_num__if__known_username = 2;  end
    else if ( i_a == uv__usernames[3] ) begin  in_a__known_username = 1'b1;  in_a__user_num__if__known_username = 3;  end
    else if ( i_a == uv__usernames[4] ) begin  in_a__known_username = 1'b1;  in_a__user_num__if__known_username = 4;  end
    else if ( i_a == uv__usernames[5] ) begin  in_a__known_username = 1'b1;  in_a__user_num__if__known_username = 5;  end

    else                                begin  in_a__known_username = 1'b0;  in_a__user_num__if__known_username = NO_USER_NUM; end

    // if ( 
          // i_a == uv__usernames[1] |
          // i_a == uv__usernames[2] |
          // i_a == uv__usernames[3] |
          // i_a == uv__usernames[4] |
          // i_a == uv__usernames[5] // MAX_USERS - 1
                                                    // ) in_a__known_username = 1'b1;
    // else                                              in_a__known_username = 1'b0;                                                      
     

    /////////////////////////////////////////////////////////////////////////////////////////////////////
    //
    // State Logic
    //
    /////////////////////////////////////////////////////////////////////////////////////////////////////
    case(cur_state)
      
      ///////////////////////////////
      //
      // state logic: CMD 
      //
      ///////////////////////////////
      // if (cur_state == STATE__CMD)
      STATE__CMD:
        begin
          if      ( ! i_rdy                                         ) o_a = OUT_STR__ASK_CMD;
          else if (   i_rdy & ! in_a__valid_cmd                     ) o_a = OUT_STR__INVALID_CMD;
          else if (   i_rdy & ! in_a__valid_cmd__user_has_perms_for ) o_a = OUT_STR__INVALID_PERMS;
        end

    
      ///////////////////////////////
      //
      // state logic: USERNAME
      //
      ///////////////////////////////
      STATE__USERNAME:
        begin
          if      ( ! i_rdy                                         ) o_a = OUT_STR__ASK_USERNAME;
          else if (   i_rdy & ! in_a__known_username                ) begin 
                                                                            o_a = OUT_STR__UNKOWN_USERNAME;
                   // this should not be here !!!!!!!!!! put up top by change state       given_user__num = in_a__user_num__if__known_username; 
                                                                      end
          // else if (   i_rdy & ! in_a__valid_cmd__user_has_perms_for ) o_a = OUT_STR__INVALID_PERMS;          
        end

      ///////////////////////////////
      //
      // state logic: PASSWORD
      //
      ///////////////////////////////  
      STATE__PASSWORD:
        begin
          if      ( ! i_rdy                                         ) o_a = OUT_STR__ASK_PASSWORD;        
        end
     
      ///////////////////////////////
      //  
      // state logic: PERMS
      //
      ///////////////////////////////
      STATE__PERMS:
        begin
          if      ( ! i_rdy                                         ) o_a = OUT_STR__ASK_PERMS;        
        end
     
      ///////////////////////////////
      //
      // state logic: ITEM NAME
      //
      ///////////////////////////////  
      STATE__ITEM_NAME:
        begin
          if      ( ! i_rdy                                         ) o_a = OUT_STR__ASK_ITEM_NAME;        
        end
        
      ///////////////////////////////
      //
      // state logic: STOCK
      //
      ///////////////////////////////  
      STATE__STOCK:
        begin
          if      ( ! i_rdy                                         ) o_a = OUT_STR__ASK_STOCK;        
        end
        
    endcase
  

  end  

  
endmodule
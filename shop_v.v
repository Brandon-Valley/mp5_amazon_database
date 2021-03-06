// -- python C:\Users\Brandon\Documents\Personal_Projects\my_utils\modelsim_utils\auto_run.py -d run_cmd__shop_v.do

module shop_v
  #(
    parameter I_A_NUM_ASCII_CHARS   = 7                            , // must fit longest CMD_KEY
    parameter O_A_NUM_ASCII_CHARS   = 9                            , // must fit longest out__
                                                                   
    parameter I_A_NUM_BITS          = I_A_NUM_ASCII_CHARS * 8      ,
    parameter I_U_NUM_BITS          = 4                            , // max 15
    parameter O_A_NUM_BITS          = O_A_NUM_ASCII_CHARS * 8      ,
                                                                   
    parameter MAX_USERS             = 6                            ,  // includes admin(1) and empty(0)
    parameter NUM_BITS_MAX_USER_NUM = 3                            ,  // [log2(MAX_USERS - 1)]+1
                                                                   
    parameter MAX_ITEMS             = 4                            ,  
    parameter NUM_BITS_MAX_ITEM_NUM = 4                            ,  // Max stock = 15
                                                                   
                                                                   
    // default empy and admin                                      
    parameter ADMIN_USERNAME        = "Adm"                        ,    
    parameter EMPTY_USERNAME        = "Nnn"                        ,   
                                                                   
    parameter ADMIN_PASSWORD        = "123"                        ,    
    parameter EMPTY_PASSWORD        = "nnn"                        ,    
                                                                   
    parameter ADMIN_USER_NUM        = 1                            ,    
    parameter EMPTY_USER_NUM        = 0                            ,  
                                                                   
    parameter NO_USER_NUM           = 3'bZZZ                       ,  // num bits  = NUM_BITS_MAX_USER_NUM
    parameter NO_ITEM_NUM           = 2'bZZ                        ,  // num bits  = NUM_BITS_MAX_USER_NUM
    parameter NO_USERNAME           = {I_A_NUM_BITS{1'bZ}}         ,  // num bits  = I_A_NUM_BITS
    parameter NO_PASSWORD           = {I_A_NUM_BITS{1'bZ}}         ,  // num bits  = I_A_NUM_BITS
    parameter NO_PERMS              = {I_A_NUM_BITS{1'bZ}}         ,  // num bits  = I_A_NUM_BITS
    parameter NO_STOCK              = {NUM_BITS_MAX_ITEM_NUM{1'bZ}},  // num bits  = I_A_NUM_BITS

    //perm keys
    parameter PERM_KEY__EMPTY       = "EMPTY"  ,
    parameter PERM_KEY__ADMIN       = "ADMIN"  ,
    parameter PERM_KEY__SELLER      = "SELLER" ,
    parameter PERM_KEY__BUYER       = "BUYER"  ,
    
    // command keys
    parameter CMD_KEY__LOGOUT       = "Logout" ,
    parameter CMD_KEY__LOGIN        = "Login"  ,
    parameter CMD_KEY__ADD_USER     = "AddUsr" ,
    parameter CMD_KEY__DELETE_USER  = "DelUsr" ,
    parameter CMD_KEY__ADD_ITEM     = "AddItem",
    parameter CMD_KEY__DELETE_ITEM  = "DelItem",
    parameter CMD_KEY__BUY          = "Buy"    ,
    parameter CMD_KEY__NONE         = "NONE"   ,
      
    // states
    parameter STATE_NUM_ASCII_BITS  = 7        ,
   
    parameter STATE__CMD            = "CMD"    ,
    parameter STATE__USERNAME       = "USRNAME",
    parameter STATE__PASSWORD       = "PASSWRD",
    parameter STATE__PERMS          = "PERMS"  ,
    parameter STATE__ITEM_NAME      = "ITMNAME",
    parameter STATE__STOCK          = "ITMSTCK",

    // out strings
    // CMD
    parameter OUT_STR__ASK_CMD           = "Cmd?"     , 
    parameter OUT_STR__INVALID_CMD       = "InvalCmd" ,
    parameter OUT_STR__INVALID_PERMS     = "InvalPerm",
    parameter OUT_STR__USERS_FULL        = "UsrsFull" ,
    parameter OUT_STR__LOGGED_OUT        = "LoggedOut",
    parameter OUT_STR__ITEMS_FULL        = "ItmsFull" ,

    // USERNAME                          
    parameter OUT_STR__ASK_USERNAME      = "Username?",
    parameter OUT_STR__UNKOWN_USERNAME   = "UnkwnUser",
    parameter OUT_STR__USERNAME_UNKOWN   = "UsrUnknwn", 
    parameter OUT_STR__USERNAME_TAKEN    = "UsrTaken" ,
    parameter OUT_STR__CANT_DEL_ADMIN    = "NoDelAdmn", 
    parameter OUT_STR__USER_DELETED      = "UsrDeletd", 

    // PASSWORD                          
    parameter OUT_STR__ASK_PASSWORD      = "Password?",
    parameter OUT_STR__PASSWORD_WRONG    = "WrongPass",
    parameter OUT_STR__LOGGED_IN         = "LoggedIn" ,
    
    // PERMS
    parameter OUT_STR__ASK_PERMS         = "Perms?"            , 
    parameter OUT_STR__PERM_TYPE_INVALID = "PrmTypInv"         ,
    parameter OUT_STR__USER_ADDED        = "UsrAdded"          ,
    
    // ITEM_NAME
    parameter OUT_STR__ASK_ITEM_NAME     = "ItmName?"          ,
    parameter OUT_STR__ITEM_EXISTS       = "ItmExists"         , 
    parameter OUT_STR__ITEM_UNKNOWN      = "ItmUnknwn"         ,
    parameter OUT_STR__ITEM_NOT_YOURS    = "NtYourItm"         , 
    parameter OUT_STR__ITEM_DELETED      = "ItmDeletd"         ,
    parameter OUT_STR__NO_STOCK          = "NoStock"           ,
    parameter OUT_STR__ITEM_BOUGHT       = "ItmBought"         ,
    
    // STOCK
    parameter OUT_STR__ASK_STOCK         = "Stock?"            ,
    parameter OUT_STR__ITEM_ADDED        = "ItmAdded"          
    
    
     
 
           

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
  reg pass;
  
  // reg unsigned [2 ** (MAX_USERS -1):0] cur_user_num;
  
  reg [I_A_NUM_BITS - 1:0] cur_cmd; // the current VALIDATD command, has nothing to do with checking if user has perms to execute given cmd
  
  reg [(STATE_NUM_ASCII_BITS * 8) - 1:0] cur_state;
  reg [(STATE_NUM_ASCII_BITS * 8) - 1:0] next_state;
  
  // save for making new user
  reg          [I_A_NUM_BITS - 1:0] given_username; 
  reg unsigned [I_A_NUM_BITS - 1:0] given_password; 
  
  reg unsigned [NUM_BITS_MAX_USER_NUM - 1:0] next_available_user_num;
  reg unsigned [NUM_BITS_MAX_ITEM_NUM - 1:0] next_available_item_num;
  
  reg unsigned [NUM_BITS_MAX_ITEM_NUM - 1:0] given_item__num;
  reg          [I_A_NUM_BITS - 1:0]          given_item__name;  
  
  reg unsigned [NUM_BITS_MAX_USER_NUM - 1:0] given_user__num; // num for user given by user by username
  reg          [I_A_NUM_BITS - 1:0]          given_user__username; // need?
  reg unsigned [I_A_NUM_BITS - 1:0]          given_user__password;
  reg          [I_A_NUM_BITS - 1:0]          given_user__perms;
  
  reg unsigned [NUM_BITS_MAX_USER_NUM - 1:0] cur_user__num;
  reg          [I_A_NUM_BITS - 1:0]          cur_user__username;
  reg          [I_A_NUM_BITS - 1:0]          cur_user__password;
  reg          [I_A_NUM_BITS - 1:0]          cur_user__perms;
  
  reg                                        in_a__item_name__of__cur_user;
  reg                                        in_a__known_username;
  reg                                        in_a__known_item_name;
  wire                                       in_a__valid_cmd; // don't need this declaration because assigned, just here to keep things straight
  wire                                       in_a__valid_perm_type; // don't need this declaration because assigned, just here to keep things straight
  reg                                        in_a__valid_cmd__user_has_perms_for;
  reg                                        in_a__correct_password_for__given_user;
  reg unsigned [NUM_BITS_MAX_USER_NUM - 1:0] in_a__user_num__if__known_username;
  reg unsigned [NUM_BITS_MAX_USER_NUM - 1:0] in_a__item_num__if__known_item_name;
  

  // user vectors
  reg [MAX_USERS    - 1:0] uv__slot_taken;
  reg [I_A_NUM_BITS - 1:0] uv__usernames [MAX_USERS - 1:0];
  reg [I_A_NUM_BITS - 1:0] uv__passwords [MAX_USERS - 1:0];
  reg [I_A_NUM_BITS - 1:0] uv__perms     [MAX_USERS - 1:0];
  
  // item vectors
  reg [MAX_ITEMS    - 1:0]          iv__slot_taken;
  reg [I_A_NUM_BITS - 1:0]          iv__item_names[MAX_ITEMS - 1:0];
  reg [NUM_BITS_MAX_ITEM_NUM - 1:0] iv__stock     [MAX_ITEMS - 1:0];
  reg [I_A_NUM_BITS - 1:0]          iv__usernames [MAX_ITEMS - 1:0];


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
                           
  // 1 / 0 if in_a is a valid perm type, can't add admin
  assign in_a__valid_perm_type = i_a == PERM_KEY__SELLER |
                                 i_a == PERM_KEY__BUYER  ? 1'b1 : 1'b0;                           
                          
                          
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
      
      
      ////////////////////////////////////////////////////////////////////////////////////////////////////
      //
      // state logic: CMD 
      //
      ////////////////////////////////////////////////////////////////////////////////////////////////////
      STATE__CMD:  
      begin
      
        if      ( ! i_rdy                                         ) o_a = OUT_STR__ASK_CMD;
        else if (   i_rdy & ! in_a__valid_cmd                     ) o_a = OUT_STR__INVALID_CMD;
        else if (   i_rdy & ! in_a__valid_cmd__user_has_perms_for ) o_a = OUT_STR__INVALID_PERMS;
      
      
        if ( i_rdy & in_a__valid_cmd__user_has_perms_for) 
          begin 
            // you already know you will be moving to a new state, so save the cmd
            cur_cmd = i_a;
            
            case(i_a)
              CMD_KEY__LOGOUT     :  
                                    begin
                                      next_state = STATE__CMD; 
                                      o_a = OUT_STR__LOGGED_OUT;
                                      cur_user__num = EMPTY_USER_NUM;
                                    end
              CMD_KEY__LOGIN      :  next_state = STATE__USERNAME  ;
              CMD_KEY__ADD_USER   :  
                                    begin
                                          if (uv__slot_taken == 6'b111111)  
                                            o_a = OUT_STR__USERS_FULL;
                                          else 
                                            next_state = STATE__USERNAME;
                                    end
              CMD_KEY__DELETE_USER:  next_state = STATE__USERNAME  ;
              CMD_KEY__ADD_ITEM   :  
                                    begin
                                          if (iv__slot_taken == 4'b1111)  
                                            o_a = OUT_STR__ITEMS_FULL;
                                          else 
                                            next_state = STATE__ITEM_NAME;
                                    end
              CMD_KEY__DELETE_ITEM:  next_state = STATE__ITEM_NAME ;
              CMD_KEY__BUY        :  next_state = STATE__ITEM_NAME ; 
            endcase
          end
          
        else
          begin
            next_state = STATE__CMD;
            cur_cmd = CMD_KEY__NONE;
          end
      end
                  
                  
      ////////////////////////////////////////////////////////////////////////////////////////////////////
      //
      // state logic: USERNAME
      //
      ////////////////////////////////////////////////////////////////////////////////////////////////////       
      STATE__USERNAME:
      begin     
        if               ( i_rdy )                                                               
          begin
            case(cur_cmd)
            
              // LOGIN
              CMD_KEY__LOGIN:
                begin
                              if (in_a__known_username)  
                                                        begin  
                                                              next_state = STATE__PASSWORD;  
                                                              given_user__num = in_a__user_num__if__known_username;
                                                        end
                                
                              else
                                                        begin
                                                              next_state = STATE__CMD; 
                                                              o_a = OUT_STR__UNKOWN_USERNAME; 
                                                        end
                end
                
            
              // ADD_USER
              CMD_KEY__ADD_USER:
                begin
                              if (in_a__known_username)  
                                                        begin  
                                                              next_state = STATE__CMD; 
                                                              o_a = OUT_STR__USERNAME_TAKEN; 
                                                        end
                                
                              else
                                                        begin
                                                              next_state = STATE__PASSWORD;  
                                                              given_username = i_a;                                                        
                                                        end
                end
                
              // DELETE_USER
              CMD_KEY__DELETE_USER:
                begin
                              if (in_a__known_username)  
                                                        begin  
                                                              if (i_a == ADMIN_USERNAME)
                                                                begin
                                                                      o_a = OUT_STR__CANT_DEL_ADMIN;
                                                                      next_state = STATE__CMD;
                                                                end
                                                              else
                                                                begin
                                                                      o_a = OUT_STR__USER_DELETED;
                                                                      next_state = STATE__CMD;
                                                                      
                                                                      // delete user
                                                                      uv__slot_taken[in_a__user_num__if__known_username] = 1'b0;
                                                                      uv__usernames [in_a__user_num__if__known_username] = NO_USERNAME;
                                                                      uv__passwords [in_a__user_num__if__known_username] = NO_PASSWORD;
                                                                      uv__perms     [in_a__user_num__if__known_username] = NO_PERMS   ;
                                                                      
                                                                      // delete user's items if they are a seller
                                                                          if (iv__usernames[0] == i_a) 
                                                                          begin 
                                                                            iv__slot_taken [0] = 1'b0;
                                                                            iv__item_names [0] = NO_USERNAME;
                                                                            iv__stock      [0] = NO_STOCK;
                                                                            iv__usernames  [0] = NO_USERNAME;
                                                                          end
                                                                          
                                                                          if (iv__usernames[1] == i_a) 
                                                                          begin 
                                                                            iv__slot_taken [1] = 1'b0;
                                                                            iv__item_names [1] = NO_USERNAME;
                                                                            iv__stock      [1] = NO_STOCK;
                                                                            iv__usernames  [1] = NO_USERNAME;
                                                                          end

                                                                          if (iv__usernames[2] == i_a) 
                                                                          begin 
                                                                            iv__slot_taken [2] = 1'b0;
                                                                            iv__item_names [2] = NO_USERNAME;
                                                                            iv__stock      [2] = NO_STOCK;
                                                                            iv__usernames  [2] = NO_USERNAME;
                                                                          end

                                                                          if (iv__usernames[3] == i_a) 
                                                                          begin 
                                                                            iv__slot_taken [3] = 1'b0;
                                                                            iv__item_names [3] = NO_USERNAME;
                                                                            iv__stock      [3] = NO_STOCK;
                                                                            iv__usernames  [3] = NO_USERNAME;
                                                                        end
                                                                end
                                                        end
                                
                              else
                                                        begin
                                                              next_state = STATE__CMD; 
                                                              o_a = OUT_STR__UNKOWN_USERNAME;                                                       
                                                        end
                end                

              //cur_cmds...
            endcase
          end
        else                                                  o_a = OUT_STR__ASK_USERNAME;
      end
      
      
      ////////////////////////////////////////////////////////////////////////////////////////////////////
      //
      // state logic: PASSWORD
      //
      ////////////////////////////////////////////////////////////////////////////////////////////////////
      STATE__PASSWORD:
      begin     
        if               ( i_rdy )                                                               
          begin
            case(cur_cmd)
            
              // LOGIN
              CMD_KEY__LOGIN:
                begin
                  if (i_a == given_user__password)  
                    begin  
                      next_state = STATE__CMD;  
                      o_a = OUT_STR__LOGGED_IN;  
                      cur_user__num = given_user__num;
                    end
                    
                  else
                    begin
                      next_state = STATE__CMD; 
                      o_a = OUT_STR__PASSWORD_WRONG; 
                    end
                end
                
                
              // ADD_USER
              CMD_KEY__ADD_USER:
                begin
                  next_state = STATE__PERMS;
                  given_password = i_a;
                end                
              
              // cur_cmds...
                
            endcase
          end
        else                                                  o_a = OUT_STR__ASK_PASSWORD;
      end

     
      ////////////////////////////////////////////////////////////////////////////////////////////////////
      //  
      // state logic: PERMS
      //
      ////////////////////////////////////////////////////////////////////////////////////////////////////
      STATE__PERMS:
      begin     
        if               ( i_rdy )                                                               
          begin
            case(cur_cmd)
            
              // ADD_USER
              CMD_KEY__ADD_USER:
                begin
                  if (in_a__valid_perm_type)
                    begin
                      o_a = OUT_STR__USER_ADDED;
                      next_state = STATE__CMD;
                    
                      // add user
                      uv__slot_taken[next_available_user_num] = 1'b1;
                      uv__usernames [next_available_user_num] = given_username;
                      uv__passwords [next_available_user_num] = given_password;
                      uv__perms     [next_available_user_num] = i_a;
                    end
                    
                  else
                    begin
                      o_a = OUT_STR__PERM_TYPE_INVALID;
                      next_state = STATE__CMD;
                    end
                end                
              
              // cur_cmds...
            endcase
          end
        else                                                  o_a = OUT_STR__ASK_PERMS;
      end      


      ////////////////////////////////////////////////////////////////////////////////////////////////////
      //
      // state logic: ITEM NAME
      //
      //////////////////////////////////////////////////////////////////////////////////////////////////// 
      STATE__ITEM_NAME:
      begin     
        if               ( i_rdy )                                                               
          begin
            case(cur_cmd)
            
              // ADD_ITEM
              CMD_KEY__ADD_ITEM:
                begin
                              if (in_a__known_item_name)  
                                                        begin  
                                                              next_state = STATE__CMD; 
                                                              o_a = OUT_STR__ITEM_EXISTS; // like username taken 
                                                        end
                                
                              else
                                                        begin
                                                              next_state = STATE__STOCK;  
                                                              given_item__name = i_a;                                                        
                                                        end
                end
                
              // DELTET_ITEM
              CMD_KEY__DELETE_ITEM:
                begin
                              if (in_a__known_item_name)  
                                                        begin  
                                                              if (in_a__item_name__of__cur_user)
                                                                begin
                                                                      // delete item
                                                                      o_a = OUT_STR__ITEM_DELETED;
                                                                      next_state = STATE__CMD;
                                                                      
                                                                      iv__slot_taken [in_a__item_num__if__known_item_name] = 1'b0;
                                                                      iv__item_names [in_a__item_num__if__known_item_name] = NO_USERNAME;
                                                                      iv__stock      [in_a__item_num__if__known_item_name] = NO_STOCK;
                                                                      iv__usernames  [in_a__item_num__if__known_item_name] = NO_USERNAME;
                                                                end
                                                              else
                                                                begin                                                                      
                                                                      o_a = OUT_STR__ITEM_NOT_YOURS;
                                                                      next_state = STATE__CMD;
                                                                end
                                                        end
                                
                              else
                                                        begin
                                                              next_state = STATE__CMD; 
                                                              o_a = OUT_STR__ITEM_UNKNOWN;                                                       
                                                        end
                end            

              // BUY
              CMD_KEY__BUY:
                begin
                              if (in_a__known_item_name)  
                                                        begin  
                                                              if (iv__stock[in_a__item_num__if__known_item_name] == 4'b0000)
                                                                begin
                                                                  o_a = OUT_STR__NO_STOCK;
                                                                  next_state = STATE__CMD;
                                                                end
                                                              else
                                                                begin               
                                                                  // buy item
                                                                  o_a = OUT_STR__ITEM_BOUGHT;
                                                                  iv__stock[in_a__item_num__if__known_item_name] = iv__stock[in_a__item_num__if__known_item_name] - 1'b1;
                                                                  next_state = STATE__CMD; 
                                                                end
                                                        end
                                
                              else
                                                        begin
                                                              next_state = STATE__CMD; 
                                                              o_a = OUT_STR__ITEM_UNKNOWN;                                                       
                                                        end
                end                              
                
              // cur_cmds...
            endcase
          end
        else                                                  o_a = OUT_STR__ASK_ITEM_NAME;
      end      
      
      
      ////////////////////////////////////////////////////////////////////////////////////////////////////
      //
      // state logic: STOCK
      //
      ////////////////////////////////////////////////////////////////////////////////////////////////////  
      STATE__STOCK:
      begin     
        if               ( i_rdy )                                                               
          begin
            case(cur_cmd)
            
              // ADD_USER
              CMD_KEY__ADD_ITEM:
                begin
                
                  // add item
                  o_a = OUT_STR__ITEM_ADDED;
                  next_state = STATE__CMD;              
              
                  iv__slot_taken[next_available_item_num] = 1'b1;
                  iv__item_names[next_available_item_num] = given_item__name;
                  iv__stock     [next_available_item_num] = i_u;
                  iv__usernames [next_available_item_num] = cur_user__username;
                end
                
              // cur_cmds...
            endcase
          end
        else                                                  o_a = OUT_STR__ASK_STOCK;
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
        uv__usernames [EMPTY_USER_NUM] = EMPTY_USERNAME;
        uv__usernames [ADMIN_USER_NUM] = ADMIN_USERNAME;
        
        uv__passwords [EMPTY_USER_NUM] = EMPTY_PASSWORD;
        uv__passwords [ADMIN_USER_NUM] = ADMIN_PASSWORD;
        
        uv__perms     [EMPTY_USER_NUM] = PERM_KEY__EMPTY;
        uv__perms     [ADMIN_USER_NUM] = PERM_KEY__ADMIN;
        
        uv__slot_taken[EMPTY_USER_NUM] = 1'b1;
        uv__slot_taken[ADMIN_USER_NUM] = 1'b1;
        
        // set rest of uv__slot_taken to 0
        uv__slot_taken[2] = 1'b0;
        uv__slot_taken[3] = 1'b0;
        uv__slot_taken[4] = 1'b0;
        uv__slot_taken[5] = 1'b0;
        
        // item vectors init
        iv__slot_taken = 4'b0000;
      
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
    
    // given user vars
    given_user__username = uv__usernames[given_user__num];
    given_user__password = uv__passwords[given_user__num];
    given_user__perms    = uv__perms    [given_user__num];
    
    
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
    
    
    // in_a__known_username and in_a__user_num__if__known_username
    // don't check username for [0] - empty
    if      ( i_a == uv__usernames[1] ) begin  in_a__known_username = 1'b1;  in_a__user_num__if__known_username = 1;  end
    else if ( i_a == uv__usernames[2] ) begin  in_a__known_username = 1'b1;  in_a__user_num__if__known_username = 2;  end
    else if ( i_a == uv__usernames[3] ) begin  in_a__known_username = 1'b1;  in_a__user_num__if__known_username = 3;  end
    else if ( i_a == uv__usernames[4] ) begin  in_a__known_username = 1'b1;  in_a__user_num__if__known_username = 4;  end
    else if ( i_a == uv__usernames[5] ) begin  in_a__known_username = 1'b1;  in_a__user_num__if__known_username = 5;  end

    else                                begin  in_a__known_username = 1'b0;  in_a__user_num__if__known_username = EMPTY_USER_NUM; end // used to be NO_USER_NUM
    
    // next_available_user_num
    // 1 and 0 taken by admin and empty
    if      ( ! uv__slot_taken[2] )  next_available_user_num = 2;
    else if ( ! uv__slot_taken[3] )  next_available_user_num = 3;
    else if ( ! uv__slot_taken[4] )  next_available_user_num = 4;
    else if ( ! uv__slot_taken[5] )  next_available_user_num = 5;
    else                             next_available_user_num = NO_USER_NUM;
    
    // in_a__known_item_name and in_a__item_num__if__known_item_name
    if      ( i_a == iv__item_names[0] ) begin  in_a__known_item_name = 1'b1;  in_a__item_num__if__known_item_name = 0;  end
    else if ( i_a == iv__item_names[1] ) begin  in_a__known_item_name = 1'b1;  in_a__item_num__if__known_item_name = 1;  end
    else if ( i_a == iv__item_names[2] ) begin  in_a__known_item_name = 1'b1;  in_a__item_num__if__known_item_name = 2;  end
    else if ( i_a == iv__item_names[3] ) begin  in_a__known_item_name = 1'b1;  in_a__item_num__if__known_item_name = 3;  end

    else                                 begin  in_a__known_item_name = 1'b0;  in_a__item_num__if__known_item_name = EMPTY_USER_NUM; end // used to be NO_USER_NUM
    
    
    // next_available_item_num
    if      ( ! iv__slot_taken[0] )  next_available_item_num = 0;
    else if ( ! iv__slot_taken[1] )  next_available_item_num = 1;
    else if ( ! iv__slot_taken[2] )  next_available_item_num = 2;
    else if ( ! iv__slot_taken[3] )  next_available_item_num = 3;
    else                             next_available_item_num = NO_ITEM_NUM;



    // in_a__item_name__of__cur_user
    if (in_a__known_item_name & iv__usernames[in_a__item_num__if__known_item_name] == cur_user__username)
      in_a__item_name__of__cur_user = 1'b1;
    else
      in_a__item_name__of__cur_user = 1'b0;























  end  

  
endmodule
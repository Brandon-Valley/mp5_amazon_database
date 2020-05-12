library verilog;
use verilog.vl_types.all;
entity shop_v is
    generic(
        I_A_NUM_ASCII_CHARS: integer := 7;
        O_A_NUM_ASCII_CHARS: integer := 9;
        I_A_NUM_BITS    : vl_notype;
        I_U_NUM_BITS    : integer := 4;
        O_A_NUM_BITS    : vl_notype;
        MAX_USERS       : integer := 6;
        NUM_BITS_MAX_USER_NUM: integer := 3;
        MAX_ITEMS       : integer := 4;
        NUM_BITS_MAX_ITEM_NUM: integer := 4;
        ADMIN_USERNAME  : string  := "Adm";
        EMPTY_USERNAME  : string  := "Nnn";
        ADMIN_PASSWORD  : string  := "123";
        EMPTY_PASSWORD  : string  := "nnn";
        ADMIN_USER_NUM  : integer := 1;
        EMPTY_USER_NUM  : integer := 0;
        NO_USER_NUM     : vl_logic_vector(0 to 2) := (HiZ, HiZ, HiZ);
        NO_ITEM_NUM     : vl_logic_vector(0 to 1) := (HiZ, HiZ);
        NO_USERNAME     : vl_notype;
        NO_PASSWORD     : vl_notype;
        NO_PERMS        : vl_notype;
        NO_STOCK        : vl_notype;
        \PERM_KEY__EMPTY\: string  := "EMPTY";
        \PERM_KEY__ADMIN\: string  := "ADMIN";
        \PERM_KEY__SELLER\: string  := "SELLER";
        \PERM_KEY__BUYER\: string  := "BUYER";
        \CMD_KEY__LOGOUT\: string  := "Logout";
        \CMD_KEY__LOGIN\: string  := "Login";
        \CMD_KEY__ADD_USER\: string  := "AddUsr";
        \CMD_KEY__DELETE_USER\: string  := "DelUsr";
        \CMD_KEY__ADD_ITEM\: string  := "AddItem";
        \CMD_KEY__DELETE_ITEM\: string  := "DelItem";
        \CMD_KEY__BUY\  : string  := "Buy";
        \CMD_KEY__NONE\ : string  := "NONE";
        STATE_NUM_ASCII_BITS: integer := 7;
        \STATE__CMD\    : string  := "CMD";
        \STATE__USERNAME\: string  := "USRNAME";
        \STATE__PASSWORD\: string  := "PASSWRD";
        \STATE__PERMS\  : string  := "PERMS";
        \STATE__ITEM_NAME\: string  := "ITMNAME";
        \STATE__STOCK\  : string  := "ITMSTCK";
        \OUT_STR__ASK_CMD\: string  := "Cmd?";
        \OUT_STR__INVALID_CMD\: string  := "InvalCmd";
        \OUT_STR__INVALID_PERMS\: string  := "InvalPerm";
        \OUT_STR__USERS_FULL\: string  := "UsrsFull";
        \OUT_STR__LOGGED_OUT\: string  := "LoggedOut";
        \OUT_STR__ITEMS_FULL\: string  := "ItmsFull";
        \OUT_STR__ASK_USERNAME\: string  := "Username?";
        \OUT_STR__UNKOWN_USERNAME\: string  := "UnkwnUser";
        \OUT_STR__USERNAME_UNKOWN\: string  := "UsrUnknwn";
        \OUT_STR__USERNAME_TAKEN\: string  := "UsrTaken";
        \OUT_STR__CANT_DEL_ADMIN\: string  := "NoDelAdmn";
        \OUT_STR__USER_DELETED\: string  := "UsrDeletd";
        \OUT_STR__ASK_PASSWORD\: string  := "Password?";
        \OUT_STR__PASSWORD_WRONG\: string  := "WrongPass";
        \OUT_STR__LOGGED_IN\: string  := "LoggedIn";
        \OUT_STR__ASK_PERMS\: string  := "Perms?";
        \OUT_STR__PERM_TYPE_INVALID\: string  := "PrmTypInv";
        \OUT_STR__USER_ADDED\: string  := "UsrAdded";
        \OUT_STR__ASK_ITEM_NAME\: string  := "ItmName?";
        \OUT_STR__ITEM_EXISTS\: string  := "ItmExists";
        \OUT_STR__ITEM_UNKNOWN\: string  := "ItmUnknwn";
        \OUT_STR__ITEM_NOT_YOURS\: string  := "NtYourItm";
        \OUT_STR__ITEM_DELETED\: string  := "ItmDeletd";
        \OUT_STR__NO_STOCK\: string  := "NoStock";
        \OUT_STR__ITEM_BOUGHT\: string  := "ItmBought";
        \OUT_STR__ASK_STOCK\: string  := "Stock?";
        \OUT_STR__ITEM_ADDED\: string  := "ItmAdded"
    );
    port(
        i_clk           : in     vl_logic;
        i_reset         : in     vl_logic;
        i_rdy           : in     vl_logic;
        i_u             : in     vl_logic_vector;
        i_a             : in     vl_logic_vector;
        o_a             : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of I_A_NUM_ASCII_CHARS : constant is 1;
    attribute mti_svvh_generic_type of O_A_NUM_ASCII_CHARS : constant is 1;
    attribute mti_svvh_generic_type of I_A_NUM_BITS : constant is 3;
    attribute mti_svvh_generic_type of I_U_NUM_BITS : constant is 1;
    attribute mti_svvh_generic_type of O_A_NUM_BITS : constant is 3;
    attribute mti_svvh_generic_type of MAX_USERS : constant is 1;
    attribute mti_svvh_generic_type of NUM_BITS_MAX_USER_NUM : constant is 1;
    attribute mti_svvh_generic_type of MAX_ITEMS : constant is 1;
    attribute mti_svvh_generic_type of NUM_BITS_MAX_ITEM_NUM : constant is 1;
    attribute mti_svvh_generic_type of ADMIN_USERNAME : constant is 1;
    attribute mti_svvh_generic_type of EMPTY_USERNAME : constant is 1;
    attribute mti_svvh_generic_type of ADMIN_PASSWORD : constant is 1;
    attribute mti_svvh_generic_type of EMPTY_PASSWORD : constant is 1;
    attribute mti_svvh_generic_type of ADMIN_USER_NUM : constant is 1;
    attribute mti_svvh_generic_type of EMPTY_USER_NUM : constant is 1;
    attribute mti_svvh_generic_type of NO_USER_NUM : constant is 1;
    attribute mti_svvh_generic_type of NO_ITEM_NUM : constant is 1;
    attribute mti_svvh_generic_type of NO_USERNAME : constant is 3;
    attribute mti_svvh_generic_type of NO_PASSWORD : constant is 3;
    attribute mti_svvh_generic_type of NO_PERMS : constant is 3;
    attribute mti_svvh_generic_type of NO_STOCK : constant is 3;
    attribute mti_svvh_generic_type of \PERM_KEY__EMPTY\ : constant is 1;
    attribute mti_svvh_generic_type of \PERM_KEY__ADMIN\ : constant is 1;
    attribute mti_svvh_generic_type of \PERM_KEY__SELLER\ : constant is 1;
    attribute mti_svvh_generic_type of \PERM_KEY__BUYER\ : constant is 1;
    attribute mti_svvh_generic_type of \CMD_KEY__LOGOUT\ : constant is 1;
    attribute mti_svvh_generic_type of \CMD_KEY__LOGIN\ : constant is 1;
    attribute mti_svvh_generic_type of \CMD_KEY__ADD_USER\ : constant is 1;
    attribute mti_svvh_generic_type of \CMD_KEY__DELETE_USER\ : constant is 1;
    attribute mti_svvh_generic_type of \CMD_KEY__ADD_ITEM\ : constant is 1;
    attribute mti_svvh_generic_type of \CMD_KEY__DELETE_ITEM\ : constant is 1;
    attribute mti_svvh_generic_type of \CMD_KEY__BUY\ : constant is 1;
    attribute mti_svvh_generic_type of \CMD_KEY__NONE\ : constant is 1;
    attribute mti_svvh_generic_type of STATE_NUM_ASCII_BITS : constant is 1;
    attribute mti_svvh_generic_type of \STATE__CMD\ : constant is 1;
    attribute mti_svvh_generic_type of \STATE__USERNAME\ : constant is 1;
    attribute mti_svvh_generic_type of \STATE__PASSWORD\ : constant is 1;
    attribute mti_svvh_generic_type of \STATE__PERMS\ : constant is 1;
    attribute mti_svvh_generic_type of \STATE__ITEM_NAME\ : constant is 1;
    attribute mti_svvh_generic_type of \STATE__STOCK\ : constant is 1;
    attribute mti_svvh_generic_type of \OUT_STR__ASK_CMD\ : constant is 1;
    attribute mti_svvh_generic_type of \OUT_STR__INVALID_CMD\ : constant is 1;
    attribute mti_svvh_generic_type of \OUT_STR__INVALID_PERMS\ : constant is 1;
    attribute mti_svvh_generic_type of \OUT_STR__USERS_FULL\ : constant is 1;
    attribute mti_svvh_generic_type of \OUT_STR__LOGGED_OUT\ : constant is 1;
    attribute mti_svvh_generic_type of \OUT_STR__ITEMS_FULL\ : constant is 1;
    attribute mti_svvh_generic_type of \OUT_STR__ASK_USERNAME\ : constant is 1;
    attribute mti_svvh_generic_type of \OUT_STR__UNKOWN_USERNAME\ : constant is 1;
    attribute mti_svvh_generic_type of \OUT_STR__USERNAME_UNKOWN\ : constant is 1;
    attribute mti_svvh_generic_type of \OUT_STR__USERNAME_TAKEN\ : constant is 1;
    attribute mti_svvh_generic_type of \OUT_STR__CANT_DEL_ADMIN\ : constant is 1;
    attribute mti_svvh_generic_type of \OUT_STR__USER_DELETED\ : constant is 1;
    attribute mti_svvh_generic_type of \OUT_STR__ASK_PASSWORD\ : constant is 1;
    attribute mti_svvh_generic_type of \OUT_STR__PASSWORD_WRONG\ : constant is 1;
    attribute mti_svvh_generic_type of \OUT_STR__LOGGED_IN\ : constant is 1;
    attribute mti_svvh_generic_type of \OUT_STR__ASK_PERMS\ : constant is 1;
    attribute mti_svvh_generic_type of \OUT_STR__PERM_TYPE_INVALID\ : constant is 1;
    attribute mti_svvh_generic_type of \OUT_STR__USER_ADDED\ : constant is 1;
    attribute mti_svvh_generic_type of \OUT_STR__ASK_ITEM_NAME\ : constant is 1;
    attribute mti_svvh_generic_type of \OUT_STR__ITEM_EXISTS\ : constant is 1;
    attribute mti_svvh_generic_type of \OUT_STR__ITEM_UNKNOWN\ : constant is 1;
    attribute mti_svvh_generic_type of \OUT_STR__ITEM_NOT_YOURS\ : constant is 1;
    attribute mti_svvh_generic_type of \OUT_STR__ITEM_DELETED\ : constant is 1;
    attribute mti_svvh_generic_type of \OUT_STR__NO_STOCK\ : constant is 1;
    attribute mti_svvh_generic_type of \OUT_STR__ITEM_BOUGHT\ : constant is 1;
    attribute mti_svvh_generic_type of \OUT_STR__ASK_STOCK\ : constant is 1;
    attribute mti_svvh_generic_type of \OUT_STR__ITEM_ADDED\ : constant is 1;
end shop_v;

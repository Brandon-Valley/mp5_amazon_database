library verilog;
use verilog.vl_types.all;
entity shop_v is
    generic(
        I_A_NUM_ASCII_CHARS: integer := 7;
        O_A_NUM_ASCII_CHARS: integer := 9;
        I_A_NUM_BITS    : vl_notype;
        I_U_NUM_BITS    : integer := 4;
        O_A_NUM_BITS    : vl_notype;
        MAX_USERS       : integer := 5;
        \CMD_KEY__LOGOUT\: string  := "Logout";
        \CMD_KEY__LOGIN\: string  := "Login";
        \CMD_KEY__ADD_USER\: string  := "AddUsr";
        \CMD_KEY__DELETE_USER\: string  := "DelUsr";
        \CMD_KEY__ADD_ITEM\: string  := "AddItem";
        \CMD_KEY__DELETE_ITEM\: string  := "DelItem";
        \CMD_KEY__BUY\  : string  := "Buy";
        \CMD_KEY__NONE\ : string  := "NONE";
        ADMIN_USERNAME  : string  := "Adm";
        STATE_NUM_ASCII_BITS: integer := 7;
        \STATE__CMD\    : string  := "CMD";
        \STATE__USERNAME\: string  := "USRNAME";
        \STATE__PASSWORD\: string  := "PASSWRD";
        \STATE__PERMS\  : string  := "PERMS";
        \STATE__ITEM_NAME\: string  := "ITMNAME";
        \STATE__ITEM_STOCK\: string  := "ITMSTCK"
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
    attribute mti_svvh_generic_type of \CMD_KEY__LOGOUT\ : constant is 1;
    attribute mti_svvh_generic_type of \CMD_KEY__LOGIN\ : constant is 1;
    attribute mti_svvh_generic_type of \CMD_KEY__ADD_USER\ : constant is 1;
    attribute mti_svvh_generic_type of \CMD_KEY__DELETE_USER\ : constant is 1;
    attribute mti_svvh_generic_type of \CMD_KEY__ADD_ITEM\ : constant is 1;
    attribute mti_svvh_generic_type of \CMD_KEY__DELETE_ITEM\ : constant is 1;
    attribute mti_svvh_generic_type of \CMD_KEY__BUY\ : constant is 1;
    attribute mti_svvh_generic_type of \CMD_KEY__NONE\ : constant is 1;
    attribute mti_svvh_generic_type of ADMIN_USERNAME : constant is 1;
    attribute mti_svvh_generic_type of STATE_NUM_ASCII_BITS : constant is 1;
    attribute mti_svvh_generic_type of \STATE__CMD\ : constant is 1;
    attribute mti_svvh_generic_type of \STATE__USERNAME\ : constant is 1;
    attribute mti_svvh_generic_type of \STATE__PASSWORD\ : constant is 1;
    attribute mti_svvh_generic_type of \STATE__PERMS\ : constant is 1;
    attribute mti_svvh_generic_type of \STATE__ITEM_NAME\ : constant is 1;
    attribute mti_svvh_generic_type of \STATE__ITEM_STOCK\ : constant is 1;
end shop_v;

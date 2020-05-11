library verilog;
use verilog.vl_types.all;
entity shop_tb_v is
    generic(
        I_A_NUM_ASCII_CHARS: integer := 7;
        O_A_NUM_ASCII_CHARS: integer := 9;
        I_A_NUM_BITS    : vl_notype;
        I_U_NUM_BITS    : integer := 4;
        O_A_NUM_BITS    : vl_notype;
        MAX_USERS       : integer := 5;
        ADMIN_USERNAME  : string  := "Adm";
        ADMIN_PASSWORD  : string  := "123";
        \CMD_KEY__LOGOUT\: string  := "Logout";
        \CMD_KEY__LOGIN\: string  := "Login";
        \CMD_KEY__ADD_USER\: string  := "AddUsr";
        \CMD_KEY__DELETE_USER\: string  := "DelUsr";
        \CMD_KEY__ADD_ITEM\: string  := "AddItem";
        \CMD_KEY__DELETE_ITEM\: string  := "DelItem";
        \CMD_KEY__BUY\  : string  := "Buy";
        \CMD_KEY__NONE\ : string  := "NONE";
        \PERM_KEY__EMPTY\: string  := "EMPTY";
        \PERM_KEY__ADMIN\: string  := "ADMIN";
        \PERM_KEY__SELLER\: string  := "SELLER";
        \PERM_KEY__BUYER\: string  := "BUYER";
        tc              : integer := 50;
        time_between_test_inputs: vl_notype
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of I_A_NUM_ASCII_CHARS : constant is 1;
    attribute mti_svvh_generic_type of O_A_NUM_ASCII_CHARS : constant is 1;
    attribute mti_svvh_generic_type of I_A_NUM_BITS : constant is 3;
    attribute mti_svvh_generic_type of I_U_NUM_BITS : constant is 1;
    attribute mti_svvh_generic_type of O_A_NUM_BITS : constant is 3;
    attribute mti_svvh_generic_type of MAX_USERS : constant is 1;
    attribute mti_svvh_generic_type of ADMIN_USERNAME : constant is 1;
    attribute mti_svvh_generic_type of ADMIN_PASSWORD : constant is 1;
    attribute mti_svvh_generic_type of \CMD_KEY__LOGOUT\ : constant is 1;
    attribute mti_svvh_generic_type of \CMD_KEY__LOGIN\ : constant is 1;
    attribute mti_svvh_generic_type of \CMD_KEY__ADD_USER\ : constant is 1;
    attribute mti_svvh_generic_type of \CMD_KEY__DELETE_USER\ : constant is 1;
    attribute mti_svvh_generic_type of \CMD_KEY__ADD_ITEM\ : constant is 1;
    attribute mti_svvh_generic_type of \CMD_KEY__DELETE_ITEM\ : constant is 1;
    attribute mti_svvh_generic_type of \CMD_KEY__BUY\ : constant is 1;
    attribute mti_svvh_generic_type of \CMD_KEY__NONE\ : constant is 1;
    attribute mti_svvh_generic_type of \PERM_KEY__EMPTY\ : constant is 1;
    attribute mti_svvh_generic_type of \PERM_KEY__ADMIN\ : constant is 1;
    attribute mti_svvh_generic_type of \PERM_KEY__SELLER\ : constant is 1;
    attribute mti_svvh_generic_type of \PERM_KEY__BUYER\ : constant is 1;
    attribute mti_svvh_generic_type of tc : constant is 1;
    attribute mti_svvh_generic_type of time_between_test_inputs : constant is 3;
end shop_tb_v;

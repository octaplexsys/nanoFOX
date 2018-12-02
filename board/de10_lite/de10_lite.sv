module de10_lite
(
    //max10 clock input's
    input               adc_clk_10,
    input               max10_clk1_50,
    input               max10_clk2_50,
    //seven segment's
    output  [7  : 0]    hex0,
    output  [7  : 0]    hex1,
    output  [7  : 0]    hex2,
    output  [7  : 0]    hex3,
    output  [7  : 0]    hex4,
    output  [7  : 0]    hex5,
    //button's
    input   [1  : 0]    key,
    //led's
    output  [9  : 0]    ledr,
    //switches
    input   [9  : 0]    sw,
    //gpio
    inout   [35 : 0]    gpio
);

    // wires & inputs

    logic               clk;
    logic               resetn;
    logic   [4  : 0]    reg_addr;
    logic   [31 : 0]    reg_data;
    logic   [25 : 0]    div;
    logic   [6*8-1 : 0] hex;
    
    assign { hex5 , hex4 , hex3 , hex2 , hex1 , hex0 } = hex;
    assign clk      = max10_clk1_50;
    assign resetn   = key[0];
    assign reg_addr = sw[0 +: 5];
    assign div      = { sw[5 +: 5] , { 20 { 1'b1 } } };

    nf_top nf_top_0
    (
        .clk        ( clk       ),
        .resetn     ( resetn    ),
        .div        ( div       ),
        .reg_addr   ( reg_addr  ),
        .reg_data   ( reg_data  )
    );

    nf_seven_seg_static 
    #(
        .hn         ( 6         )
    )
    nf_seven_seg_static_0
    (
        .hex        ( reg_data  ),
        .cc_ca      ( '0        ),
        .seven_seg  ( hex       )
    );

endmodule : de10_lite
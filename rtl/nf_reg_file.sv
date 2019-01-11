/*
*  File            :   nf_reg_file.sv
*  Autor           :   Vlasov D.V.
*  Data            :   2018.11.19
*  Language        :   SystemVerilog
*  Description     :   This is register file
*  Copyright(c)    :   2018 - 2019 Vlasov D.V.
*/
`include "nf_settings.svh"

module nf_reg_file
(
    input   logic               clk,
    input   logic   [4  : 0]    ra1,
    output  logic   [31 : 0]    rd1,
    input   logic   [4  : 0]    ra2,
    output  logic   [31 : 0]    rd2,
    input   logic   [4  : 0]    wa3,
    input   logic   [31 : 0]    wd3,
    input   logic               we3
    `ifdef debug
    ,
    input   logic   [4  : 0]    ra0,
    output  logic   [31 : 0]    rd0
    `endif
);
    logic [31:0] reg_file [`reg_number-1:0];

    `ifdef debug
    assign  rd0 = ( ra0 == '0 ) ? '0 : 
                  ( ( ra0 == wa3) ? wd3 : reg_file[ra0] );
    `endif
    assign  rd1 = ( ra1 == '0 ) ? '0 : 
                  ( ( ra1 == wa3) ? wd3 : reg_file[ra1] );
    assign  rd2 = ( ra2 == '0 ) ? '0 : 
                  ( ( ra2 == wa3) ? wd3 : reg_file[ra2] );
    
    always_ff @(posedge clk)
    begin
        if( we3 )
        begin
            reg_file[wa3] <= wd3;
        end
    end

endmodule : nf_reg_file

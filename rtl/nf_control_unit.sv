/*
*  File            :   nf_control_unit.sv
*  Autor           :   Vlasov D.V.
*  Data            :   2018.11.20
*  Language        :   SystemVerilog
*  Description     :   This is controll unit
*  Copyright(c)    :   2018 Vlasov D.V.
*/

`include "nf_cpu.svh"

module nf_control_unit
(
    input   logic   [6 : 0]     opcode,     // operation code field in instruction code
    input   logic   [2 : 0]     funct3,     // funct 3 field in instruction code
    input   logic   [6 : 0]     funct7,     // funct 7 field in instruction code
    output  logic   [1 : 0]     imm_src,    // for enable immediate data
    output  logic               srcBsel,    // for selecting srcB ALU
    output  logic               branch,     // for executing branch instructions
    output  logic               eq_neq,     // equal and not equal control
    output  logic               we,         // write enable signal for register file
    output  logic   [31 : 0]    ALU_Code    // output code for ALU unit
);

always_comb
begin
    we       = '0;
    ALU_Code = '0;
    srcBsel  = '0;
    imm_src  = '0;
    branch   = '0;
    eq_neq   = '0;
    casex( { opcode , funct3 , funct7 } )
        //  R - type command's
        { `C_ADD  , `F3_ADD  , `F7_ADD } : begin we = '1; ALU_Code = `ALU_ADD;  srcBsel = '1;                                             end
        { `C_SUB  , `F3_SUB  , `F7_SUB } : begin we = '1; ALU_Code = `ALU_SUB;  srcBsel = '1;                                             end
        { `C_OR   , `F3_OR   , `F7_ANY } : begin we = '1; ALU_Code = `ALU_OR;   srcBsel = '1;                                             end
        //  I - type command's
        { `C_SLLI , `F3_SLLI , `F7_ANY } : begin we = '1; ALU_Code = `ALU_SLLI; srcBsel = '0; imm_src = `i_sel;                           end
        { `C_ADDI , `F3_ADDI , `F7_ANY } : begin we = '1; ALU_Code = `ALU_ADD;  srcBsel = '0; imm_src = `i_sel;                           end
        //  U - type command's
        { `C_LUI  , `F3_ANY  , `F7_ANY } : begin we = '1; ALU_Code = `ALU_LUI;  srcBsel = '0; imm_src = `u_sel;                           end
        //  B - type command's
        { `C_BEQ  , `F3_BEQ  , `F7_ANY } : begin we = '0; ALU_Code = `ALU_ADD;  srcBsel = '1; imm_src = `b_sel; branch = '1; eq_neq = '1; end
        //  S - type command's
        //  in the future
        //  J - type command's
        //  in the future
    endcase
end

endmodule : nf_control_unit

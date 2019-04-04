/*
*  File            :   nf_i_exu.sv
*  Autor           :   Vlasov D.V.
*  Data            :   2019.01.10
*  Language        :   SystemVerilog
*  Description     :   This is instruction execution unit
*  Copyright(c)    :   2018 - 2019 Vlasov D.V.
*/

`include "../../inc/nf_settings.svh"
`include "../../inc/nf_cpu.svh"

module nf_i_exu
(
    input   logic   [31 : 0]    rd1,        // read data from reg file (port1)
    input   logic   [31 : 0]    rd2,        // read data from reg file (port2)
    input   logic   [31 : 0]    ext_data,   // sign extended immediate data
    input   logic   [31 : 0]    pc_iexe,    // PC value from execution stage
    input   logic   [0  : 0]    res_sel,    // result select
    input   logic   [0  : 0]    srcB_sel,   // source enable signal for ALU
    input   logic   [4  : 0]    shamt,      // for shift operations
    input   logic   [31 : 0]    ALU_Code,   // code for ALU
    output  logic   [31 : 0]    result      // result of ALU operation
);

    logic   [31 : 0]    result_;
    // wires for ALU inputs
    logic   [31 : 0]    srcA;
    logic   [31 : 0]    srcB;
    // assign's ALU signals
    assign  srcA    = rd1;
    assign  srcB    = srcB_sel == SRCB_RD2 ? rd2     : ext_data;
    assign  result  = res_sel  == RES_ALU  ? result_ : pc_iexe;
    // creating ALU unit
    nf_alu alu_0
    (
        .srcA           ( srcA          ),  // source A for ALU unit
        .srcB           ( srcB          ),  // source B for ALU unit
        .shamt          ( shamt         ),  // for shift operation
        .ALU_Code       ( ALU_Code      ),  // ALU code from control unit
        .result         ( result_       )   // result of ALU operation
    );

endmodule : nf_i_exu
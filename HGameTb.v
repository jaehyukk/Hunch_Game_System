`timescale 1ns/100ps
`include "HGame.v"

module test_bench();
reg Tclk, RST;
reg inA, inB, inC;
wire [2:0] WINNER_DISP;
reg [1:19] Avec, Bvec, Cvec;
parameter Aseq = 19'b00_1_1_11_011_000_0001_11_1,
          Bseq = 19'b01_0_1_01_000_011_0001_01_0,
          Cseq = 19'b01_1_0_00_001_001_0001_01_1;
          // AW -> BW -> CW -> ABW -> ACW -> BCW -> DRAW -> AW -> BW
integer cnt;

Main_FSM two (.CLK(Tclk), .RST(RST), .A(inA), .B(inB), .C(inC), .WINNER_DISP(WINNER_DISP));

always begin // clock signal
    Tclk = 0; #5;
    Tclk = 1; #5;
end

initial begin
    RST = 0;
    Avec = Aseq; Bvec = Bseq; Cvec = Cseq;
    Tclk = 0;
    for(cnt = 1; cnt <= 20; cnt = cnt + 1) begin
        if(WINNER_DISP[2:0] != 3'b000) begin
            RST = 1; end // state reset
        inA = Avec[1]; Avec = Avec << 1;
        inB = Bvec[1]; Bvec = Bvec << 1;
        inC = Cvec[1]; Cvec = Cvec << 1;
        #5; RST = 0; #5;
    end
    $stop(1);
end
endmodule
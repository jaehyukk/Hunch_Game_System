`include "Display.v"

module Main_FSM (CLK, RST, A, B, C, WINNER_DISP, A_DISP, B_DISP, C_DISP);
    input CLK, RST; // clock signal, reset
    input A, B, C; // input
    output reg [2:0] WINNER_DISP; // winner display
    output reg A_DISP, B_DISP, C_DISP; // standing display
    reg [5:0] state, Snext; // current state, next state
    reg A0, A1, A2; // decoder input

    parameter [5:0] S_INIT = 6'b000000,
                    S_AS = 6'b001000,
                    S_BS = 6'b010000,
                    S_CS = 6'b011000,
                    S_AW = 6'b000100,
                    S_BW = 6'b000101,
                    S_CW = 6'b000110,
                    S_ABW = 6'b000111,
                    S_ACW = 6'b001011,
                    S_BCW = 6'b001001,
                    S_DRAW = 6'b001010;

    display one (.CLK(CLK), .RST(RST), .WINNER_DISP(WINNER_DISP), .A_DISP(A_DISP), .B_DISP(B_DISP), .C_DISP(C_DISP));
                    
    always @ (posedge CLK or posedge RST) begin
        if(RST==1'b1) begin
            state <= S_INIT; end
        else begin
            state <= Snext; end
    end

    always @ (A, B, C, state) begin // next-state logic
        case (state)
            S_INIT : if(A == 1'b1 & B == 1'b0 & C == 1'b0) Snext = S_AS;
                    else if(A == 1'b0 & B == 1'b1 & C == 1'b0) Snext = S_BS;
                    else if(A == 1'b0 & B == 1'b0 & C == 1'b1) Snext = S_CS;
                    else if(A == 1'b1 & B == 1'b1 & C == 1'b0) Snext = S_CW;
                    else if(A == 1'b1 & B == 1'b0 & C == 1'b1) Snext = S_BW;
                    else if(A == 1'b0 & B == 1'b1 & C == 1'b1) Snext = S_AW;
                    else if(A == 1'b1 & B == 1'b1 & C == 1'b1) Snext = S_DRAW;
                    else Snext = S_INIT;

            S_AS : if(B == 1'b1 & C == 1'b0) Snext = S_ABW;
                   else if(B == 1'b0 & C == 1'b1) Snext = S_ACW;
                   else if(B == 1'b1 & C == 1'b1) Snext = S_AW;
                   else Snext = S_AS;
                     // standing only A state
            S_BS : if(A == 1'b1 & C == 1'b0) Snext = S_ABW;
                   else if(A == 1'b0 & C == 1'b1) Snext = S_BCW;
                   else if(A == 1'b1 & C == 1'b1) Snext = S_BW;
                   else Snext = S_BS;
                   // standing only B state
            S_CS : if(A == 1'b1 & B == 1'b0) Snext = S_ACW;
                   else if(A == 1'b0 & B == 1'b1) Snext = S_BCW;
                   else if(A == 1'b1 & B == 1'b1) Snext = S_CW;
                   else Snext = S_CS;
                   // standing only C state
            S_AW : Snext = S_INIT; // winner is A
            S_BW : Snext = S_INIT; // winner is B
            S_CW : Snext = S_INIT; // winner is C
            S_ABW : Snext = S_INIT; // winners are A and B
            S_ACW : Snext = S_INIT; // winners are A and C
            S_BCW : Snext = S_INIT; // winners are B anc C
            S_DRAW : Snext = S_INIT; // draw
            default : Snext = S_INIT;
        endcase
        
        assign A_DISP = A; assign B_DISP = B; assign C_DISP = C;
        A2 <= state[2]; A1 <= state[1]; A0 <= state[0];
    end

    //output logic(Decoder) 
    always @ (*) begin
        case({A2, A1, A0})
            3'b100 : WINNER_DISP[2:0] = 3'b100; // S_AW
            3'b101 : WINNER_DISP[2:0] = 3'b010; // S_BW
            3'b111 : WINNER_DISP[2:0] = 3'b110; // S_ABW
            3'b110 : WINNER_DISP[2:0] = 3'b001; // S_CW
            3'b011 : WINNER_DISP[2:0] = 3'b101; // S_ACW
            3'b001 : WINNER_DISP[2:0] = 3'b011; // S_BCW
            3'b010 : WINNER_DISP[2:0] = 3'b111; // S_DRAW
            default : WINNER_DISP[2:0] = 3'b000; // other case
        endcase
    end
endmodule
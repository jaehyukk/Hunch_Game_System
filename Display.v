module display(CLK, RST, WINNER_DISP, A_DISP, B_DISP, C_DISP);
    input CLK, RST;
    input [2:0] WINNER_DISP;
    input A_DISP, B_DISP, C_DISP;
    integer i = 1;

    always @ (posedge CLK or posedge RST) begin
        if(WINNER_DISP[2] == 1'b1 && (WINNER_DISP[1] == 1'b0 && WINNER_DISP[0] == 1'b0)) begin
            $display("[# %d] Result : Winner is A!", i); i = i + 1; end
        else if(WINNER_DISP[2] == 1'b0 && (WINNER_DISP[1] == 1'b1 && WINNER_DISP[0] == 1'b0)) begin
            $display("[# %d] Result : Winner is B!", i);   i = i + 1; end
        else if(WINNER_DISP[2] == 1'b1 && (WINNER_DISP[1] == 1'b1 && WINNER_DISP[0] == 1'b0)) begin
            $display("[# %d] Result : Winner is AB!", i); i = i + 1; end
        else if(WINNER_DISP[2] == 1'b0 && (WINNER_DISP[1] == 1'b0 && WINNER_DISP[0] == 1'b1)) begin
            $display("[# %d] Result : Winner is C!", i); i = i + 1; end
        else if(WINNER_DISP[2] == 1'b1 && (WINNER_DISP[1] == 1'b0 && WINNER_DISP[0] == 1'b1)) begin
            $display("[# %d] Result : Winner is AC!", i); i = i + 1; end
        else if(WINNER_DISP[2] == 1'b0 && (WINNER_DISP[1] == 1'b1 && WINNER_DISP[0] == 1'b1)) begin
            $display("[# %d] Result : Winner is BC!", i); i = i + 1; end
        else if(WINNER_DISP[2] == 1'b1 && (WINNER_DISP[1] == 1'b1 && WINNER_DISP[0] == 1'b1)) begin
            $display("[# %d] Result : DRAW!", i); i = i + 1; end 
        else begin
            $display("[# %d] A: %b B: %b C: %b", i, A_DISP, B_DISP, C_DISP);  i = i + 1; end
    end
endmodule
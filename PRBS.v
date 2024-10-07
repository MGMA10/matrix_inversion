//Pseudo-Random Binary Sequence of length 15

module PRBS #(parameter Type = 15 , parameter BusWidth = 8 , parameter NumWidth = 4 ) (

	input wire [BusWidth -1 : 0] InData,
	input wire [NumWidth -1 : 0] n,
	input wire CLK, 
	input wire RST,

	output reg [BusWidth -1 : 0] OutData,
	output reg PRBSEq
);

reg [NumWidth -1 : 0] Counter ;
reg [5 : 0] Offset ;
reg EquationFlag ;
reg [Type - 1 : 0] LFSRFF ;
reg [31 : 0] mem ; 
reg [NumWidth -1 : 0] CountIn;

 




always @(posedge CLK  or negedge RST)
begin
	if (!RST)
		begin
			mem <= 'd0;
			CountIn <= 'd0;
			OutData <= 'd0;
			Counter <= 'd0;
			Offset  <= 'd0;
			EquationFlag <= 'd0;
		end
	else
		begin
			if (CountIn != 'd4)
				begin
				// Serial To Parallel
					mem [31 : 8] <= mem [23 : 0];
					mem [7 : 0]<= InData ;
					CountIn <= CountIn + 'd1 ;
				end
			else
				begin
				// Serial Output Byte by Byte n Times
					if (!EquationFlag)
						begin
							OutData <= mem [7 : 0];
							mem   <= {mem [7 : 0] , mem [31 : 8]};
							Offset  <= Offset + 'd1;
						end
					if (Offset == 'd3)
						begin
							Offset <=  'd0;
							Counter <= Counter + 'd1;
						end
						
					if ((Counter == n -1) & (Offset == 'd3)) 
						begin
							EquationFlag <= 'd1;
						end
				end
		end
end




always @(posedge CLK or negedge RST)
begin
	if (!RST)
		begin
			LFSRFF <= 'h2ABC;
			PRBSEq <= 1'd0;
		end
	else if (EquationFlag)
		begin
		// PRBS - 15 Custom Equation
			LFSRFF <= {LFSRFF [Type - 2 :0], LFSRFF[13]^LFSRFF[14]};
			PRBSEq <= LFSRFF [Type - 1] ;			
				
		end
end





endmodule 
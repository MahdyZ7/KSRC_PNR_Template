module dividerblock(
	input	reset,
	input	clk,
	output	div4,
	output	div8,
	output	div9,
	output	div12,
	output	div80
);
	
	Div9 d9 (.reset(reset), .clk(clk), .div9(div9));
	Div12 d12 (.reset(reset), .clk(clk), .div12(div12));
	Div80 d80 (.reset(reset), .clk(clk), .div80(div80), .div8(div8), .div4(div4));

endmodule
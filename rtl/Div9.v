module Div9(
	input	reset,
	input	clk,
	output	div9
);

	// order is in kmap AB \ CD
	// order in desgin DCBA
	reg	midA;
	reg	midB;
	reg	midC;
	reg	midD;
	reg t1;
	reg t2;
	wire pt1;
	wire pt2;

	assign pt1 = ~midC & ~midD;
	assign pt2 = midC & midD;
	always @(posedge clk) begin
		if (~reset) begin
			midA <= 0;
			midB <= 0;
			midC <= 0;
			midD <= 0;
			t1 <= 0;
		end else begin
			midD <= ~midC;
			midC <= midA & (~midB | midC);
			midB <= midA ^ midD;
			midA <= midA & ~midB | midB & midD;
			if (~midC & ~midD)
				t1 <= ~t1;
		end
	end
	always @(negedge clk) begin
		if (~reset)
			t2 <= 0;
		else begin
			if(midC & midD)
				t2 <= ~t2;
		end
	end
	assign div9 = t1^t2;

endmodule
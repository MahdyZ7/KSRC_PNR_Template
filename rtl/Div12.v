module Div12(
	input	reset,
	input	clk,
	output	reg div12
);

	reg [2:0] count;

	always @(posedge clk) begin
		if (~reset) begin
			count <= 0;
			div12 <= 0;
		end else begin
			count[0] <= count[1];
			count[1] <= ~count[2];
			count[2] <= count[0];
			if (~count[2] & ~count[1])
				div12 <= ~div12;
		end
	end
endmodule
module Div9(
	input	reset,
	input	clk,
	output	div9
);

	reg	mid1;
	reg	mid2;
	reg	mid3;
	reg	mid4;
	// reg [3:0] cc;

	// assign count[0] = mid1;
	// assign count[1] = mid2;
	// assign count[2] = mid3;
	// assign count[3] = mid4;
	always @(posedge clk) begin
		if (~reset) begin
			mid1 <= 0;
			mid2 <= 0;
			mid3 <= 0;
			mid4 <= 0;
			// cc <= 0;
		end else begin
			mid1 <= (~mid2) & (mid3 | ~mid4);
			mid2 <= (~mid4) & (mid1 | mid2);
			mid3 <= (~mid1) & (mid2 | mid4);
			mid4 <= mid3;
			// cc <= cc +1;
		end
	end
	assign div9 = (~mid4 & (mid1 | mid2)) | (clk & mid2);	

endmodule
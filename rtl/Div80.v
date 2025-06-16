module Div80(
	input	reset,
	input	clk,
	output	reg div80,
	output	reg div4,
	output	reg div8
);

	reg [2:0] count8;
	reg [2:0] count5;

	always @(posedge clk) begin
		if (~reset) begin
			count8 <= 0;
			count5 <= 0;
			div80 <= 0;
			div4 <= 0;
			div8 <= 0;
		end else begin
			count5[2] <= ~count5[1] | count5[0];
			count5[1] <= count5[0];
			count5[0] <= count5[2] & ~count5[1];
			
			count8[2] <= count8[1] & ~count8[0] | count8[2] & count8[0];
			count8[1] <= count8[1] & ~count8[0] | ~count8[2] & count8[0];
			count8[0] <= ~(count8[1] ^ count8[2]);
			if(count5[2] == 0 && count8 == 0)
				div80 <= ~div80;
			div8 <= ~count8[2];
			div4 <= ~(count8[1] ^ count8[2]);
		end
	end

endmodule

/*
count 5 logic
[2][1][0]
000
100
101
111
110

count 8 logic
[2][1][0]
000
001
011
010
110
111
101
100

count 80 logic;

toggle output when count5 and count8 is zero
*/
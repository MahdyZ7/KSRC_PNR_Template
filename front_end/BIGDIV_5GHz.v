/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : S-2021.06-SP5-5
// Date      : Tue Sep  3 23:56:27 2024
/////////////////////////////////////////////////////////////


module CLKDivider_Div9alt_1 ( reset, clk, div9, VDD, VSS );
  input reset, clk;
  output div9;
  inout VDD,  VSS;
  wire   midC, midD, midA, midB, t1, N11, N13, n10, n12, n14, n16, n34, n35,
         n36, n37, n38, n39, n40, n41, n42, n43;

  SC8T_DFFQX4_CSC24SL midD_reg ( .D(N13), .CLK(clk), .Q(midD) );
  SC8T_DFFQX4_CSC24SL midC_reg ( .D(n14), .CLK(clk), .Q(midC) );
  SC8T_DFFQX2_CSC24SL midB_reg ( .D(N11), .CLK(clk), .Q(midB) );
  SC8T_DFFQX4_CSC24SL t1_reg ( .D(n12), .CLK(clk), .Q(t1) );
  SC8T_DFFNX4_CSC24SL t2_reg ( .D(n10), .CLK(clk), .QN(n43) );
  SC8T_DFFQX4_CSC28SL midA_reg ( .D(n16), .CLK(clk), .Q(midA) );
  SC8T_NR2X2_MR_CSC24SL U3 ( .A(n38), .B(n40), .Z(n10) );
  SC8T_ND2X2_CSC28SL U4 ( .A(midA), .B(reset), .Z(n42) );
  SC8T_ND2IAX1_MR_CSC28SL U5 ( .A(midA), .B(reset), .Z(n34) );
  SC8T_NR2X1_MR_CSC24SL U6 ( .A(n36), .B(n40), .Z(n12) );
  SC8T_INVX1_MR_CSC28SL U7 ( .A(midC), .Z(n39) );
  SC8T_NR2X1_MR_CSC24SL U8 ( .A(midC), .B(n40), .Z(N13) );
  SC8T_ND2X1_MR_CSC28SL U9 ( .A(midD), .B(reset), .Z(n41) );
  SC8T_XNR2X1_MR_CSC24SL U10 ( .A(n37), .B(n43), .Z(n38) );
  SC8T_AOI21X1_MR_CSC24SL U11 ( .B1(midB), .B2(n39), .A(n42), .Z(n14) );
  SC8T_XNR2X1_CSC28L U12 ( .A(t1), .B(n43), .Z(div9) );
  SC8T_INVX1_MR_CSC28SL U13 ( .A(reset), .Z(n40) );
  SC8T_ND2X2_CSC24SL U14 ( .A(midC), .B(midD), .Z(n37) );
  SC8T_MUXI2X1_MR_CSC24SL U15 ( .D0(n42), .D1(n34), .S(midD), .Z(N11) );
  SC8T_NR2X3_CSC24SL U16 ( .A(midC), .B(midD), .Z(n35) );
  SC8T_XNR2X1_MR_CSC24SL U17 ( .A(n35), .B(t1), .Z(n36) );
  SC8T_MUXI2X1_MR_CSC24SL U18 ( .D0(n42), .D1(n41), .S(midB), .Z(n16) );
endmodule


module CLKDivider_Div12_1 ( reset, clk, div12, VDD, VSS );
  input reset, clk;
  output div12;
  inout VDD,  VSS;
  wire   N6, N7, N8, n4, n10, n11, n12;
  wire   [2:0] count;

  SC8T_DFFQX4_CSC24SL count_reg_2_ ( .D(N8), .CLK(clk), .Q(count[2]) );
  SC8T_DFFQX4_CSC24SL count_reg_1_ ( .D(N7), .CLK(clk), .Q(count[1]) );
  SC8T_DFFQX4_CSC24SL count_reg_0_ ( .D(N6), .CLK(clk), .Q(count[0]) );
  SC8T_DFFQX4_CSC24SL div12_reg ( .D(n4), .CLK(clk), .Q(div12) );
  SC8T_NR2X2_MR_CSC24SL U3 ( .A(n11), .B(n12), .Z(n4) );
  SC8T_NR2X3_CSC24SL U4 ( .A(count[1]), .B(count[2]), .Z(n10) );
  SC8T_NR2X1_MR_CSC24SL U5 ( .A(count[2]), .B(n12), .Z(N7) );
  SC8T_CKAN2X1_MR_CSC24SL U6 ( .CLK(count[1]), .EN(reset), .Z(N6) );
  SC8T_INVX1_MR_CSC28SL U7 ( .A(reset), .Z(n12) );
  SC8T_XNR2X1_MR_CSC24SL U8 ( .A(n10), .B(div12), .Z(n11) );
  SC8T_CKAN2X1_MR_CSC24SL U9 ( .CLK(count[0]), .EN(reset), .Z(N8) );
endmodule


module CLKDivider_Div80alt_1 ( reset, clk, div80, div4, div8, VDD, VSS );
  input reset, clk;
  output div80, div4, div8;
  inout VDD,  VSS;
  wire   count8_2_, count8_1_, N13, N16, N17, n9, n11, n13, n28, n29, n30, n31,
         n32, n33, n34, n35, n36, n37, n38, n39;
  wire   [2:0] count5;

  SC8T_DFFQX4_CSC24SL count8_reg_0_ ( .D(N13), .CLK(clk), .Q(div4) );
  SC8T_DFFQX4_CSC24SL count8_reg_2_ ( .D(n11), .CLK(clk), .Q(count8_2_) );
  SC8T_DFFQX4_CSC24SL count8_reg_1_ ( .D(n13), .CLK(clk), .Q(count8_1_) );
  SC8T_DFFQX2_CSC24SL count5_reg_0_ ( .D(N16), .CLK(clk), .Q(count5[0]) );
  SC8T_DFFQX4_CSC24SL count5_reg_1_ ( .D(N17), .CLK(clk), .Q(count5[1]) );
  SC8T_DFFQNX4_CSC24SL count5_reg_2_ ( .D(n28), .CLK(clk), .QN(count5[2]) );
  SC8T_DFFX1_CSC24SL div80_reg ( .D(n9), .CLK(clk), .Q(div80) );
  SC8T_DFFQX1_CSC24L div8_reg ( .D(n39), .CLK(clk), .Q(div8) );
  SC8T_AN2X1_MR_CSC28SL U3 ( .A(n33), .B(count5[2]), .Z(N16) );
  SC8T_NR4X6_CSC24SL U4 ( .A(count8_2_), .B(div4), .C(count8_1_), .D(count5[2]), .Z(n29) );
  SC8T_ND2X1_MR_CSC28SL U5 ( .A(count8_2_), .B(reset), .Z(n38) );
  SC8T_INVX1_MR_CSC28SL U6 ( .A(n39), .Z(n35) );
  SC8T_INVX1_MR_CSC28SL U7 ( .A(div4), .Z(n37) );
  SC8T_CKAN2X1_MR_CSC24SL U8 ( .CLK(count5[0]), .EN(reset), .Z(N17) );
  SC8T_ND2X1_MR_CSC24SL U9 ( .A(n32), .B(n34), .Z(n36) );
  SC8T_NR2X2_MR_CSC28SL U10 ( .A(count5[1]), .B(n31), .Z(n33) );
  SC8T_NR2X2_MR_CSC24SL U11 ( .A(count8_2_), .B(n31), .Z(n39) );
  SC8T_INVX2_CSC28SL U12 ( .A(reset), .Z(n31) );
  SC8T_OAI21X1_MR_CSC24SL U13 ( .B1(n38), .B2(n37), .A(n36), .Z(n11) );
  SC8T_NR2X1_MR_CSC24SL U14 ( .A(N17), .B(n33), .Z(n28) );
  SC8T_XNR2X1_MR_CSC24SL U15 ( .A(n29), .B(div80), .Z(n30) );
  SC8T_NR2X1P5_CSC24SL U16 ( .A(n30), .B(n31), .Z(n9) );
  SC8T_NR2X1_MR_CSC24SL U17 ( .A(div4), .B(n31), .Z(n32) );
  SC8T_CKBUFX1_MR_CSC24SL U18 ( .CLK(count8_1_), .Z(n34) );
  SC8T_AO21IAX1_MR_CSC24SL U19 ( .B1(n39), .B2(div4), .A(n36), .Z(n13) );
  SC8T_MUXI2X1_MR_CSC24SL U20 ( .D0(n35), .D1(n38), .S(n34), .Z(N13) );
endmodule


module dividerblock ( reset, clk, VDD, VSS, div4, div8, div9, div12, div80 );
  input reset, clk;
  output div4, div8, div9, div12, div80;
  inout VDD,  VSS;

  tri   VDD;
  tri   VSS;

  CLKDivider_Div9alt_1 d9 ( .reset(reset), .clk(clk), .div9(div9), .VDD(VDD), 
        .VSS(VSS) );
  CLKDivider_Div12_1 d12 ( .reset(reset), .clk(clk), .div12(div12), .VDD(VDD), 
        .VSS(VSS) );
  CLKDivider_Div80alt_1 d80 ( .reset(reset), .clk(clk), .div80(div80), .div4(
        div4), .div8(div8), .VDD(VDD), .VSS(VSS) );
endmodule


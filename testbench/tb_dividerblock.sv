`timescale 1ps/1ps

module tb_dividerblock;
  // Testbench signals
  logic clk;
  logic reset;
  wire div4;
  wire div8;
  wire div9;
  wire div12;
  wire div80;

  
  // Instantiate the Unit Under Test (UUT)
  dividerblock uut (
    .clk(clk),
    .reset(reset),
    .div4(div4),
    .div8(div8),
    .div9(div9),
    .div12(div12),
    .div80(div80)
  );

  int half_period = 125; // Half period for 4GHz clock (125ps)
  int period = 2 * half_period; // Full period for 4GHz clock (250ps)
  int reset_duration = period + 10; // Reset duration (250ps + 10ps = 260ps)
  int test_cycles = 720000; // LCM of all dividers' periods * 1000 (to capture multiple cycles)
  
  // Clock generation - 4GHz reference clock
  initial begin
    clk = 0;
    forever #half_period clk = ~clk; // 125ps period (4GHz clock)
  end
  
  // Counters to verify division ratios
  real clk_count = 0;
  real div4_high_count = 0;
  real div8_high_count = 0;
  real div9_high_count = 0;
  real div12_high_count = 0;
  real div80_high_count = 0;
  
  // Count clock cycles and measure duty cycle
  always @(edge clk) begin
    if (reset) begin
      clk_count+=0.5;
      
      if (div4 == 1'b1) div4_high_count+=0.5;
      if (div8 == 1'b1) div8_high_count+=0.5;
      if (div9 == 1'b1) div9_high_count+=0.5;
      if (div12 == 1'b1) div12_high_count+=0.5;
      if (div80 == 1'b1) div80_high_count+=0.5;
    end
  end

//   always @(negedge clk) begin
// 	if (reset) begin
// 		if (div9 == 1'b1) div9_high_count++;
// 	end
//   end
  // Edge counters for frequency verification
  int div4_edges = 0;
  int div8_edges = 0;
  int div9_edges = 0;
  int div12_edges = 0;
  int div80_edges = 0;
  
  logic div4_prev = 0;
  logic div8_prev = 0;
  logic div9_prev = 0;
  logic div12_prev = 0;
  logic div80_prev = 0;
  
  // Count signal transitions
  always @(posedge clk) begin
    if (reset) begin
      if (div4 != div4_prev) div4_edges++;
      if (div8 != div8_prev) div8_edges++;
      if (div9 != div9_prev) div9_edges++;
      if (div12 != div12_prev) div12_edges++;
      if (div80 != div80_prev) div80_edges++;
      
      div4_prev <= div4;
      div8_prev <= div8;
      div9_prev <= div9;
      div12_prev <= div12;
      div80_prev <= div80;
    end
  end
  
  // Test procedure
  initial begin
    // Initialize signals
    reset = 0;
    
    // Apply reset
    #reset_duration;
    reset = 1;
    
    // Run simulation for enough cycles to capture multiple periods of all dividers
    #test_cycles;

    // Print results
    $display("\n==== Divider Verification Results ====");
    $display("Total clock cycles: %d", clk_count);
    
    // Verify division ratios using edge counts
    $display("\n--- Frequency Verification ---");
    $display("div4 edges: %d (expected: ~%d for %d cycles)", 
             div4_edges, clk_count/2, clk_count);
    $display("div8 edges: %d (expected: ~%d for %d cycles)", 
             div8_edges, clk_count/4, clk_count);
    $display("div9 edges: %d (expected: ~%d for %d cycles)", 
             div9_edges, clk_count/4.5, clk_count);
    $display("div12 edges: %d (expected: ~%d for %d cycles)", 
             div12_edges, clk_count/6, clk_count);
    $display("div80 edges: %d (expected: ~%d for %d cycles)", 
             div80_edges, clk_count/40, clk_count);
    
    // Verify duty cycle
    $display("\n--- Duty Cycle Verification ---");
    $display("div4 duty cycle: %.2f%% (target: 50%%)", 
             (div4_high_count * 100.0) / clk_count);
    $display("div8 duty cycle: %.2f%% (target: 50%%)", 
             (div8_high_count * 100.0) / clk_count);
    $display("div9 duty cycle: %.2f%% (target: 50%%)", 
             (div9_high_count * 100.0) / clk_count);
    $display("div12 duty cycle: %.2f%% (target: 50%%)", 
             (div12_high_count * 100.0) / clk_count);
    $display("div80 duty cycle: %.2f%% (target: 50%%)", 
             (div80_high_count * 100.0) / clk_count);
    
    // Check if division ratios are within acceptable range
    $display("\n--- Pass/Fail Verification ---");
    // div4 should have approximately clk_count/2 edges
    if (div4_edges >= clk_count/2.1 && div4_edges <= clk_count/1.9)
      $display("div4 frequency PASS");
    else
      $display("div4 frequency FAIL - Expected ~%d edges, got %d", clk_count/2, div4_edges);
    
    // div8 should have approximately clk_count/4 edges
    if (div8_edges >= clk_count/4.1 && div8_edges <= clk_count/3.9)
      $display("div8 frequency PASS");
    else
      $display("div8 frequency FAIL - Expected ~%d edges, got %d", clk_count/4, div8_edges);
    
    // div9 should have approximately clk_count/4.5 edges
    if (div9_edges >= clk_count/4.6 && div9_edges <= clk_count/4.4)
      $display("div9 frequency PASS");
    else
      $display("div9 frequency FAIL - Expected ~%d edges, got %d", clk_count/4.5, div9_edges);
    
    // div12 should have approximately clk_count/6 edges
    if (div12_edges >= clk_count/6.1 && div12_edges <= clk_count/5.9)
      $display("div12 frequency PASS");
    else
      $display("div12 frequency FAIL - Expected ~%d edges, got %d", clk_count/6, div12_edges);
    
    // div80 should have approximately clk_count/40 edges
    if (div80_edges >= clk_count/42 && div80_edges <= clk_count/38)
      $display("div80 frequency PASS");
    else
      $display("div80 frequency FAIL - Expected ~%d edges, got %d", clk_count/40, div80_edges);
    
    // Check duty cycles (should be around 50% ±5%)
    if (div4_high_count >= clk_count*0.45 && div4_high_count <= clk_count*0.55)
      $display("div4 duty cycle PASS (%.2f%%)", (div4_high_count * 100.0) / clk_count);
    else
      $display("div4 duty cycle FAIL - Expected ~50%%, got %.2f%%", 
               (div4_high_count * 100.0) / clk_count);
    
    if (div8_high_count >= clk_count*0.45 && div8_high_count <= clk_count*0.55)
      $display("div8 duty cycle PASS (%.2f%%)", (div8_high_count * 100.0) / clk_count);
    else
      $display("div8 duty cycle FAIL - Expected ~50%%, got %.2f%%", 
               (div8_high_count * 100.0) / clk_count);
    
    if (div9_high_count >= clk_count*0.45 && div9_high_count <= clk_count*0.55)
      $display("div9 duty cycle PASS (%.2f%%)", (div9_high_count * 100.0) / clk_count);
    else
      $display("div9 duty cycle FAIL - Expected ~50%%, got %.2f%%", 
               (div9_high_count * 100.0) / clk_count);
    
    if (div12_high_count >= clk_count*0.45 && div12_high_count <= clk_count*0.55)
      $display("div12 duty cycle PASS (%.2f%%)", (div12_high_count * 100.0) / clk_count);
    else
      $display("div12 duty cycle FAIL - Expected ~50%%, got %.2f%%", 
               (div12_high_count * 100.0) / clk_count);
    
    if (div80_high_count >= clk_count*0.45 && div80_high_count <= clk_count*0.55)
      $display("div80 duty cycle PASS (%.2f%%)", (div80_high_count * 100.0) / clk_count);
    else
      $display("div80 duty cycle FAIL - Expected ~50%%, got %.2f%%", 
               (div80_high_count * 100.0) / clk_count);
    
    $finish;
  end
  
  // Waveform generation
  initial begin
    $dumpfile("tb_dividerblock.vcd");
    $dumpvars(0, tb_dividerblock);
  end

endmodule
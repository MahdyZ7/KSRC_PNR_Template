module tb_traffic_light_controller;
  logic clk;
  logic reset;
  logic main_sensor;
  logic side_sensor;
  logic [1:0] light;

  // Instantiate the design
  traffic_light_controller uut (
    .clk(clk),
    .reset(reset),
    .main_sensor(main_sensor),
    .side_sensor(side_sensor),
    .light(light)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Test sequence
  initial begin
    // Initialize signals
    reset = 1;
    main_sensor = 0;
    side_sensor = 0;
    #10;
    reset = 0;

    // Simulate car detection on the side road
    side_sensor = 1;
    repeat (5) @(posedge clk);
    side_sensor = 0;

    // Simulate car detection on the main road
    main_sensor = 1;
    repeat (5) @(posedge clk);
    main_sensor = 0;

    // Run for a few more cycles
    repeat (10) @(posedge clk);

    // End simulation
    $stop;
  end

  // Immediate Assertion: Check if light is within valid states
  always_ff @(posedge clk) begin
    assert (light == 2'b00 || light == 2'b01 || light == 2'b10) else $fatal("Invalid light state: %b", light);
  end

  // Concurrent Assertion: Check reset behavior
  property reset_behavior;
    @(posedge clk) reset |-> (light == 2'b00);
  endproperty
  assert property (reset_behavior);

  // Concurrent Assertion: Check state transitions
//   property state_transitions; 
//     @(posedge clk) (light == 2'b00) |=> (light == 2'b01) ##1 (light == 2'b10) ##1 (light == 2'b00);
//   endproperty
	//fixed	
  property state_transitions;
    @(posedge clk) (light == 2'b00 && side_sensor) |=> (light == 2'b01) ##1 (light == 2'b10);
  endproperty
  assert property (state_transitions);

  property state_transitions_spc;
    @(posedge clk) (light == 2'b10 && main_sensor) |=> (light == 2'b01)
  endproperty
  assert property (state_transitions_spc);

  // Concurrent Assertion: Check side road priority
  property side_road_priority;
    @(posedge clk) (side_sensor && light == 2'b00) |=> (light == 2'b01);
  endproperty
  assert property (side_road_priority);

  // Concurrent Assertion: Check main road priority
  property main_road_priority;
    @(posedge clk) (main_sensor && light == 2'b10) |=> (light == 2'b01);
  endproperty
  assert property (main_road_priority);

endmodule
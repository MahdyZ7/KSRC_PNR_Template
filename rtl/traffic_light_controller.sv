module traffic_light_controller (
  input logic clk,
  input logic reset,
  input logic main_sensor, // Sensor for main road
  input logic side_sensor, // Sensor for side road
  output logic [1:0] light // 00: Red, 01: Green, 10: Yellow
);

  typedef enum logic [1:0] {
    RED = 2'b00,
    GREEN = 2'b01,
    YELLOW = 2'b10
  } state_t;

  state_t current_state, next_state;

  // State transition logic with random error
  always_ff @(posedge clk or posedge reset) begin
    if (reset)
      current_state <= RED;
    else
      current_state <= next_state;
  end

  // Next state logic with random error
  always_comb begin
    if ($urandom_range(0, 100) < 5) begin // Introduce a random error with 5% probability
      next_state = state_t'(2'b11); // Invalid state
    end else begin
      case (current_state)
        RED:    next_state = (side_sensor) ? GREEN : RED;
        GREEN:  next_state = YELLOW;
        YELLOW: next_state = (main_sensor) ? GREEN : RED;
        default: next_state = RED;
      endcase
    end
  end

  // Output logic
  assign light = current_state;

endmodule
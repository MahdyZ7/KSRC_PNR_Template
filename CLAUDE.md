# Build and Test Commands

## Simulation Commands
- `make all` - Compile and run simulation with GUI waveform viewer (Questa/Modelsim)
- `make compile` - Compile only (syntax check)
- `make cli` - Run simulation in command line mode
- `make icarus` - Run simulation using Icarus Verilog
- `make wave` - View waveforms from previous simulation
- `make clean` - Remove simulation artifacts

## Running a Single Test
Set the testbench top module before running:
```bash
TestBenchTopModule=tb_dividerblock make all
```

# Code Style Guidelines

## Verilog/SystemVerilog Conventions
- Use 2-space indentation
- Module declarations: lowercase names with aligned parameters
- Signal naming: snake_case for signal names
- Port declaration: one parameter per line, aligned
- Use active-low reset (~reset)
- Include `timescale 1ns/1ps` in testbenches

## Type Usage
- Use `logic` type for signals that will be driven in testbenches
- Use `reg` for sequential elements in RTL
- Use `wire` for connected/output signals

## Testbench Structure
- Include self-checking functionality with pass/fail messages
- Use `$display` for result reporting and `$dumpvars` for waveform generation
- Create comprehensive verification for both frequency and duty cycle
- All divider outputs should have 50% duty cycle
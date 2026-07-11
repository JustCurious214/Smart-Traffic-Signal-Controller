# Smart Traffic Signal Controller using Verilog

A Verilog-based smart traffic signal controller designed to improve intersection safety by integrating emergency vehicle priority, pedestrian crossing management, and timed traffic light sequencing. The project was developed as a digital systems design exercise and verified through simulation using a comprehensive testbench.

---

## Features

- 🚦 Dual traffic signal control for intersecting roads
- 🚑 Emergency vehicle priority handling
- 🚶 Intelligent pedestrian crossing control
- 🔔 Pedestrian warning buzzer before signal transition
- ⏱️ Time-based traffic light sequencing
- 🧪 Complete simulation testbench with waveform generation

---

## System Overview

The controller manages two independent traffic signals (`T1` and `T2`) operating on predefined timing intervals.

Normal operation follows the sequence:

```
RED → GREEN → YELLOW → RED
```

During emergency conditions:

- Emergency vehicles immediately receive priority.
- Conflicting traffic signals are forced to RED.
- Pedestrian crossings are disabled.
- Normal operation resumes automatically after the emergency duration.

---

## Pedestrian Logic

The controller includes dedicated pedestrian signals for both roads.

- Pedestrian crossing is allowed only when the corresponding traffic signal is RED.
- Crossing is disabled during emergency vehicle operation.
- A buzzer is activated during the final seconds before pedestrian access is revoked, providing a warning before signal transition.

---

## Emergency Vehicle Handling

Two emergency inputs are supported:

- `emergency_right`
- `emergency_left`

When either input is asserted:

- Corresponding traffic direction receives priority.
- Opposite traffic is halted.
- Pedestrian signals are disabled.
- Controller safely returns to the normal timing sequence after emergency completion.

---

## Finite State Behavior

Traffic lights operate through three primary states:

| State | Encoding |
|--------|----------|
| RED | `2'b00` |
| YELLOW | `2'b01` |
| GREEN | `2'b11` |

State transitions are governed using internal timing counters while ensuring safe operation during emergency overrides.

---

## Project Structure

```
.
├── traffic_controller.v      # Verilog design
├── tb_example.v              # Simulation testbench
├── simulation.vcd            # Generated waveform
└── README.md
```

---

## Simulation

The project can be simulated using:

- ModelSim
- Vivado Simulator
- Icarus Verilog
- GTKWave

Example:

```bash
iverilog traffic_controller.v tb_example.v -o traffic
vvp traffic
gtkwave simulation.vcd
```

---

## Test Scenarios

The provided testbench validates:

- Normal traffic signal sequencing
- Emergency vehicle from right lane
- Emergency vehicle from left lane
- Pedestrian signal behavior
- Buzzer activation
- Automatic recovery after emergency events

---

## Concepts Demonstrated

- Verilog HDL
- Sequential and Combinational Logic
- Finite State Machine (FSM)
- Traffic Signal Scheduling
- Digital Timing Control
- Emergency Priority Handling
- Pedestrian Safety Logic
- Simulation and Verification
- Testbench Development

---

## Future Improvements

- Adaptive traffic timing using vehicle density sensors
- Four-way intersection support
- Configurable timing parameters
- FPGA implementation
- Countdown timer display
- Camera-based vehicle detection
- Priority scheduling for multiple emergency vehicles

---

## License

This project is intended for educational and learning purposes.

# UART Implementation Using SystemVerilog and FPGA

## Overview

This project implements a modular Universal Asynchronous Receiver/Transmitter (UART) using SystemVerilog. The design was deployed on a Digilent Nexys A7 FPGA board, and its serial output was observed using Tera Term.

The project demonstrates RTL design, modular hardware development, FPGA implementation, and practical validation of serial communication.

## Objectives

- Develop modular UART RTL using SystemVerilog.
- Integrate the design modules into a top-level module.
- Implement the design on FPGA hardware.
- Validate serial output using a terminal application.
- Organize and document the RTL design for reuse and further development.

## Hardware and Tools

| Component | Details |
|---|---|
| Hardware description language | SystemVerilog |
| FPGA board | Digilent Nexys A7 |
| FPGA development tool | AMD Vivado |
| Serial terminal | Tera Term |
| Communication protocol | UART |

## Project Structure

```text
uart-systemverilog-fpga/
├── rtl/
│   ├── UART_Top.sv
│   ├── Transmitter.sv
│   ├── Receiver.sv
│   └── BaudRate.sv
├── constraints/
│   └── UART.xdc
├── 
├── images/
└── README.md
```



## Design Overview

The project uses a modular RTL structure to separate UART functionality into individual SystemVerilog modules.

- **UART Top Module:** Integrates the UART components.
- **Transmitter Module:** Implements serial transmission using a finite-state machine, including start, data, and stop states.
- **Receiver Module:** Handles the UART receive functionality.
- **Baud Rate Module:** Provides timing control for UART communication.

## FPGA Implementation and Validation

The design was implemented on a Digilent Nexys A7 FPGA board using AMD Vivado. Serial output was observed through Tera Term to validate the hardware's communication behavior.

The validation demonstrates the practical use of an FPGA-based UART design beyond RTL development alone.

## Key Skills Demonstrated

- SystemVerilog RTL design
- Modular digital design
- Finite-state machine implementation
- UART serial communication
- FPGA synthesis and implementation
- Hardware bring-up and debugging
- FPGA-to-PC serial communication




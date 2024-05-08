# CPE487 Final Project
VHDL Keyboard based off Lab 5 -- Base code from Lab 5: https://github.com/byett/dsd/tree/CPE487-Fall2023/Nexys-A7/Lab-5

Master file to access different components of the Nexys A7: https://github.com/byett/dsd/blob/CPE487-Fall2023/Nexys-A7/Nexys-A7-100T-Master.xdc

Base files used from lab 5: dac_if.vhd, siren.vhd, siren.xdc, tone.vhd, wail.vhd 

# Expected Behavior and Attachments Used
Expected Behavior: 
Our team utilized the FPGA on the Nexys A7-100T board for our project, programming it to produce distinct wailing audio tones. These tones, mimicking piano notes could be activated individually using the switches on the A7 board. 

![291752339-ab7b93cd-75ce-4b3e-b3b1-042b9558b3bc](https://github.com/terzoc/Keyboard-Project/assets/144179870/e4f99b41-a2e8-498a-ad05-4dbf23a3c231)

Nexys A7-100T board

Attachments Used: 

We integrated a 24-bit digital-to-analog converter (DAC) known as Pmod I2S2 (Inter-IC Sound) with the top six pins of the Pmod port JA, which produced sounds that were then routed to a speaker through a 3.5mm audio jack connected to the green port.

![291741386-3c5ee11d-ebac-480b-a4a6-51f2f3f2acb0](https://github.com/terzoc/Keyboard-Project/assets/144179870/f9ea8527-ec25-4acf-b3b1-7bb3da248740)

Pmod I2S2

The Pmod I2S2 features a Cirrus CS5343 Multi-Bit Audio A/D Converter and a Cirrus CS4344 Stereo D/A Converter, each connected to 3.5mm Audio Jacks. These circuits allow a system board to transmit and receive stereo audio signals via the I2S protocol. The Pmod I2S2 supports 24-bit resolution per channel at input sample rates up to 108 KHz.

# Vivado Steps
This was taken from the steps in Lab 5 showing the implementation of the project into Vivado and the Nexys Board

## 1. Create a new RTL project siren in Vivado Quick Start
- Create four new source files of file type VHDL called dac_if, tone, wail, and siren

- Create a new constraint file of file type XDC called siren

- Choose Nexys A7-100T board for the project

- Click 'Finish'

- Click design sources and copy the VHDL code from dac_if.vhd, tone.vhd, wail.vhd, siren.vhd

- Click constraints and copy the code from siren.xdc

## 2. Run synthesis
## 3. Run implementation and open implemented design
## 4. Generate bitstream, open hardware manager, and program device
- Click 'Generate Bitstream'

- Click 'Open Hardware Manager' and click 'Open Target' then 'Auto Connect'

- Click 'Program Device' then xc7a100t_0 to download siren.bit to the Nexys A7-100T board

# Code Modifications 

# Conclude

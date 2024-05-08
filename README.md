# CPE487 Final Project
VHDL Keyboard based off Lab 5 -- Base code from Lab 5: https://github.com/byett/dsd/tree/CPE487-Fall2023/Nexys-A7/Lab-5

Master file to access different components of the Nexys A7: https://github.com/byett/dsd/blob/CPE487-Fall2023/Nexys-A7/Nexys-A7-100T-Master.xdc

Base files used from lab 5: dac_if.vhd, siren.vhd, siren.xdc, tone.vhd, wail.vhd 

# Piano
Our group wanted to program the FPGA on the Nexys A7-100T board to generate three different wailing audio sounds that can individually be turned on by using BTNU, BTNC, and BTND buttons to simulate the piano notes: D, E, and F. We used a 24-bit digital-to-analog converter (DAC) called Pmod I2S2 (Inter-IC Sound) to the top six pins of the Pmod port JA to output the sounds to a speaker using a 3.5mm audio jack connected to the green port.

Pmod I2S2 requires a 3.5-mm connector for a headphone or speaker
The Digilent Pmod I2S2 features a Cirrus CS5343 Multi-Bit Audio A/D Converter and a Cirrus CS4344 Stereo D/A Converter, each connected to 3.5mm Audio Jacks. These circuits allow a system board to transmit and receive stereo audio signals via the I2S protocol. The Pmod I2S2 supports 24-bit resolution per channel at input sample rates up to 108 KHz.

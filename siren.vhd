library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY siren IS
	PORT (
		clk_50MHz : IN STD_LOGIC; -- system clock (50 MHz)
		dac_MCLK : OUT STD_LOGIC; -- outputs to PMODI2L DAC
		dac_LRCK : OUT STD_LOGIC;
		dac_SCLK : OUT STD_LOGIC;
		dac_SDIN : OUT STD_LOGIC;
		SW: IN STD_LOGIC_VECTOR(12 DOWNTO 0)
	);
END siren;

ARCHITECTURE Behavioral OF siren IS
	SIGNAL tone : UNSIGNED (13 DOWNTO 0) := to_unsigned (0, 14); -- lower limit of siren = 256 Hz
--	CONSTANT hi_tone : UNSIGNED (13 DOWNTO 0) := to_unsigned (687, 14); -- upper limit of siren = 512 Hz
--	CONSTANT wail_speed : UNSIGNED (7 DOWNTO 0) := to_unsigned (8, 8); -- sets wailing speed
	COMPONENT dac_if IS
		PORT (
			SCLK : IN STD_LOGIC;
			L_start : IN STD_LOGIC;
			R_start : IN STD_LOGIC;
			L_data : IN signed (15 DOWNTO 0);
			R_data : IN signed (15 DOWNTO 0);
			SDATA : OUT STD_LOGIC
		);
	END COMPONENT;
	COMPONENT wail IS
		PORT (
			pitch : IN UNSIGNED (13 DOWNTO 0);
--			hi_pitch : IN UNSIGNED (13 DOWNTO 0);
--			wspeed : IN UNSIGNED (7 DOWNTO 0);
			wclk : IN STD_LOGIC;
			audio_clk : IN STD_LOGIC;
			audio_data : OUT SIGNED (15 DOWNTO 0)
		);
	END COMPONENT;
	SIGNAL tcount : unsigned (19 DOWNTO 0) := (OTHERS => '0'); -- timing counter
	SIGNAL data_L, data_R : SIGNED (15 DOWNTO 0); -- 16-bit signed audio data
	SIGNAL dac_load_L, dac_load_R : STD_LOGIC; -- timing pulses to load DAC shift reg.
	SIGNAL slo_clk, sclk, audio_CLK : STD_LOGIC;
BEGIN
	-- this process sets up a 20 bit binary counter clocked at 50MHz. This is used
	-- to generate all necessary timing signals. dac_load_L and dac_load_R are pulses
	-- sent to dac_if to load parallel data into shift register for serial clocking
	-- out to DAC
	
	set_pitch: PROCESS(SW)
	BEGIN
	      if SW = "1000000000000" THEN -- Low C
	       tone <= to_unsigned (351, 14);
	   elsif SW = "0100000000000" THEN -- C#
	       tone <= to_unsigned (372, 14);
	   elsif SW = "0010000000000" then -- D
	       tone <= to_unsigned (394, 14);
	   elsif SW = "0001000000000" then -- D#
	       tone <= to_unsigned (418, 14);
	   elsif SW = "0000100000000" then -- E
	       tone <= to_unsigned (442, 14);
	   elsif SW = "0000010000000" then -- F
	       tone <= to_unsigned (469, 14);
	   elsif SW = "0000001000000" then -- F#
	       tone <= to_unsigned (497, 14);
	   elsif SW = "0000000100000" then -- G
	       tone <= to_unsigned (526, 14);
	   elsif SW = "0000000010000" then -- G#
	       tone <= to_unsigned (557, 14);
	   elsif SW = "0000000001000" then -- A
	       tone <= to_unsigned (591, 14);
	   elsif SW = "0000000000100" then -- A#
	       tone <= to_unsigned (626, 14);
	   elsif SW = "0000000000010" then -- B
	       tone <= to_unsigned (663, 14);
	   elsif SW = "0000000000001" then -- High C
	       tone <= to_unsigned (702, 14);
	   else
	       tone <= to_unsigned (0, 14);
	   end if;
	     
	END PROCESS;
	tim_pr : PROCESS
	BEGIN
		WAIT UNTIL rising_edge(clk_50MHz);
		IF (tcount(9 DOWNTO 0) >= X"00F") AND (tcount(9 DOWNTO 0) < X"02E") THEN
			dac_load_L <= '1';
		ELSE
			dac_load_L <= '0';
		END IF;
		IF (tcount(9 DOWNTO 0) >= X"20F") AND (tcount(9 DOWNTO 0) < X"22E") THEN
			dac_load_R <= '1';
		ELSE dac_load_R <= '0';
		END IF;
		tcount <= tcount + 1;
	END PROCESS;
	dac_MCLK <= NOT tcount(1); -- DAC master clock (12.5 MHz)
	audio_CLK <= tcount(9); -- audio sampling rate (48.8 kHz)
	dac_LRCK <= audio_CLK; -- also sent to DAC as left/right clock
	sclk <= tcount(4); -- serial data clock (1.56 MHz)
	dac_SCLK <= sclk; -- also sent to DAC as SCLK
	slo_clk <= tcount(19); -- clock to control wailing of tone (47.6 Hz)
	dac : dac_if
	PORT MAP(
		SCLK => sclk, -- instantiate parallel to serial DAC interface
		L_start => dac_load_L, 
		R_start => dac_load_R, 
		L_data => data_L, 
		R_data => data_R, 
		SDATA => dac_SDIN 
		);
		w1 : wail
		PORT MAP(
			pitch => tone, -- instantiate wailing siren
--			hi_pitch => hi_tone, 
--			wspeed => wail_speed, 
			wclk => slo_clk, 
			audio_clk => audio_clk, 
			audio_data => data_L
		);
		data_R <= data_L; -- duplicate data on right channel
END Behavioral;

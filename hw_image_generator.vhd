--------------------------------------------------------------------------------
--
--   FileName:         hw_image_generator.vhd
--   Dependencies:     none
--   Design Software:  Quartus II 64-bit Version 12.1 Build 177 SJ Full Version
--
--   HDL CODE IS PROVIDED "AS IS."  DIGI-KEY EXPRESSLY DISCLAIMS ANY
--   WARRANTY OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING BUT NOT
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
--   PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL DIGI-KEY
--   BE LIABLE FOR ANY INCIDENTAL, SPECIAL, INDIRECT OR CONSEQUENTIAL
--   DAMAGES, LOST PROFITS OR LOST DATA, HARM TO YOUR EQUIPMENT, COST OF
--   PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR SERVICES, ANY CLAIMS
--   BY THIRD PARTIES (INCLUDING BUT NOT LIMITED TO ANY DEFENSE THEREOF),
--   ANY CLAIMS FOR INDEMNITY OR CONTRIBUTION, OR OTHER SIMILAR COSTS.
--
--   Version History
--   Version 1.0 05/10/2013 Scott Larson
--     Initial Public Release
--    
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- 
-- VGA and PS/2 interface code courtesy of eewiki.net
-- Clock divider logic courtesy of fpga4fun.com
-- All other code written by Emory Landreville and Carter Jones
--
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;


ENTITY hw_image_generator IS

	PORT(
		clk			:	IN		STD_LOGIC;
		ps2_code    :	IN 	STD_LOGIC_VECTOR(7 DOWNTO 0);								--8 bit input from ps/2 - gives code of key pressed
		disp_ena		:	IN		STD_LOGIC;														--display enable ('1' = display time, '0' = blanking time)
		row			:	IN		INTEGER;															--row pixel coordinate
		column		:	IN		INTEGER;															--column pixel coordinate
		red			:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');  	--red magnitude output to DAC
		green			:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');  	--green magnitude output to DAC
		blue			:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0'); 	--blue magnitude output to DAC
		note			:	OUT	STD_LOGIC);														--0/1 square wave output to Line Out
END hw_image_generator;

ARCHITECTURE behavior OF hw_image_generator IS

--Low C Note Enable Bit and Counter
signal	Cnote1		:	std_logic; 								--Enable bit - Creates 0/1 Square Wave to Output
signal	Ccounter1	:	std_logic_vector(15 downto 0);	--Counter - Divides 50MHz Clock by a certain dividend to create the frequency of the note

--D Note Enable Bit and Counter
signal	Dnote			:	std_logic; 								--Enable bit - Creates 0/1 Square Wave to Output
signal	Dcounter		:	std_logic_vector(15 downto 0);	--Counter - Divides 50MHz Clock by a certain dividend to create the frequency of the note

--E Note Enable Bit and Counter
signal	Enote			:	std_logic; 								--Enable bit - Creates 0/1 Square Wave to Output
signal	Ecounter		:	std_logic_vector(15 downto 0);	--Counter - Divides 50MHz Clock by a certain dividend to create the frequency of the note

--F Note Enable Bit and Counter
signal	Fnote			:	std_logic; 								--Enable bit - Creates 0/1 Square Wave to Output
signal	Fcounter		:	std_logic_vector(15 downto 0);	--Counter - Divides 50MHz Clock by a certain dividend to create the frequency of the note

--G Note Enable Bit and Counter
signal	Gnote			:	std_logic; 								--Enable bit - Creates 0/1 Square Wave to Output
signal	Gcounter		:	std_logic_vector(15 downto 0);	--Counter - Divides 50MHz Clock by a certain dividend to create the frequency of the note

--A Note Enable Bit and Counter
signal	Anote			:	std_logic; 								--Enable bit - Creates 0/1 Square Wave to Output
signal	Acounter		:	std_logic_vector(15 downto 0);	--Counter - Divides 50MHz Clock by a certain dividend to create the frequency of the note

--B Note Enable Bit and Counter
signal	Bnote			:	std_logic; 								--Enable bit - Creates 0/1 Square Wave to Output
signal	Bcounter		:	std_logic_vector(15 downto 0);	--Counter - Divides 50MHz Clock by a certain dividend to create the frequency of the note

--High C Note Enable Bit and Counter
signal	Cnote2		:	std_logic; 								--Enable bit - Creates 0/1 Square Wave to Output
signal	Ccounter2	:	std_logic_vector(15 downto 0);	--Counter - Divides 50MHz Clock by a certain dividend to create the frequency of the note


BEGIN
	PROCESS(disp_ena, row, column) -- Creates VGA and line output using ps/2 input
	BEGIN
		IF(disp_ena = '1') THEN		--display time
			IF(Column < 250 AND Column > 200) THEN   	--first line of scale
				red <= (OTHERS => '0');						--color = black
				green	<= (OTHERS => '0');
				blue <= (OTHERS => '0');
			ELSE												  	--white background
				red <= (OTHERS => '1');						--color = white
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '1');
			END IF;
			IF (Column < 450 AND Column > 400) THEN  	--second line of scale
				red <= (OTHERS => '0');						--color = black
				green	<= (OTHERS => '0');
				blue <= (OTHERS => '0');
			END IF;
			IF (Column < 650 AND Column > 600) THEN 	--third line of scale
				red <= (OTHERS => '0');							--color = black
				green	<= (OTHERS => '0');
				blue <= (OTHERS => '0');
			END IF;
			IF (Column < 850 AND Column > 800) THEN  	--fourth line of scale 
				red <= (OTHERS => '0');						--color = black
				green	<= (OTHERS => '0');
				blue <= (OTHERS => '0');
			END IF;		
			IF (ps2_code = "00010101" ) THEN							--inputs ps/2 code
				note <= CNote1;											--sets note output to line out
				IF (Row > 20 AND Row < 220
						AND Column < 975 AND Column > 875) THEN 	--creates visual for note to vga
					red <= (OTHERS => '0');								--color = black
					green	<= (OTHERS => '0');
					blue <= (OTHERS => '0');
				END IF;
			END IF;
			IF (ps2_code = "00011101" ) THEN							--inputs ps/2 code
				note <= DNote;												--sets note output to line out
				IF (Row > 260 AND Row < 460
						AND Column < 875 AND Column > 775) THEN  	--creates visual for note to vga
					red <= (OTHERS => '0');								--color = blue
					green	<= (OTHERS => '0');
					blue <= (OTHERS => '1');
				END IF;	
			END IF;	
			IF (ps2_code = "00100100" ) THEN							--inputs ps/2 code
				note <= ENote;												--sets note output to line out
				IF (Row > 500 AND Row < 700
						AND Column < 775 AND Column > 675) THEN  	--creates visual for note to vga
					red <= (OTHERS => '0');								--color = green
					green	<= (OTHERS => '1');
					blue <= (OTHERS => '0');
				END IF;	
			END IF;	
			IF (ps2_code = "00101101" ) THEN							--inputs ps/2 code
				note <= FNote;												--sets note output to line out
				IF (Row > 740 AND Row < 940
						AND Column < 675 AND Column > 575) THEN  	--creates visual for note to vga
					red <= (OTHERS => '0');								--color = aqua
					green	<= (OTHERS => '1');
					blue <= (OTHERS => '1');
				END IF;	
			END IF;	
			IF (ps2_code = "00101100" ) THEN							--inputs ps/2 code
				note <= GNote;												--sets note output to line out
				IF (Row > 980 AND Row < 1180
						AND Column < 575 AND Column > 475) THEN  	--creates visual for note to vga
					red <= (OTHERS => '1');								--color = red
					green	<= (OTHERS => '0');
					blue <= (OTHERS => '0');
				END IF;	
			END IF;	
			IF (ps2_code = "00110101" ) THEN							--inputs ps/2 code
				note <= ANote;												--sets note output to line out
				IF (Row > 1220 AND Row < 1420
						AND Column < 475 AND Column > 375) THEN  	--creates visual for note to vga
					red <= (OTHERS => '1');								--color = fuschia
					green	<= (OTHERS => '0');
					blue <= (OTHERS => '1');
				END IF;	
			END IF;	
			IF (ps2_code = "00111100" ) THEN							--inputs ps/2 code
				note <= BNote;												--sets note output to line out
				IF (Row > 1460 AND Row < 1660
						AND Column < 375 AND Column > 275) THEN  	--creates visual for note to vga
					red <= (OTHERS => '1');								--color = yellow
					green	<= (OTHERS => '1');
					blue <= (OTHERS => '0');
				END IF;	
			END IF;	
			IF (ps2_code = "01000011" ) THEN							--inputs ps/2 code
				note <= CNote2;											--sets note output to line out
				IF (Row > 1700 AND Row < 1900
						AND Column < 275 AND Column > 175) THEN  	--creates visual for note to vga
					red <= (OTHERS => '0');								--color = black
					green	<= (OTHERS => '0');
					blue <= (OTHERS => '0');
				END IF;	
			END IF;	

		ELSE															--blanking time
			red <= (OTHERS => '0');								--color = black
			green <= (OTHERS => '0');
			blue <= (OTHERS => '0');
		END IF;
	END PROCESS;
	
	PROCESS(clk)															--creates notes by dividing clock 
	BEGIN
		IF (clk'EVENT AND clk = '1') THEN							--when clock is on rising edge
			
			IF (CCounter1 = "1011101010100010") THEN				--checks if counter reached its max value (50MHz/counter = frequency of note)
				CCounter1 <= "0000000000000000";						--if yes, back to 0 to restart
				CNote1 <= NOT(CNote1);									--flips the current value of CNote1, making a square wave (0/1)
			ELSE CCounter1 <= CCounter1 + "0000000000000001";	--if no, increases counter by 1
			END IF;
			
			IF (DCounter = "1010011001000110") THEN				--checks if counter reached its max value (50MHz/counter = frequency of note)
				DCounter <= "0000000000000000";						--if yes, back to 0 to restart
				DNote <= NOT(DNote);										--flips the current value of CNote1, making a square wave (0/1)
			ELSE DCounter <= DCounter + "0000000000000001";
			END IF;	
			
			IF (ECounter = "1001010000100010") THEN				--checks if counter reached its max value (50MHz/counter = frequency of note)
				ECounter <= "0000000000000000";						--if yes, back to 0 to restart
				ENote <= NOT(ENote);										--flips the current value of CNote1, making a square wave (0/1)
			ELSE ECounter <= ECounter + "0000000000000001";
			END IF;
			
			IF (FCounter = "1000101111010001") THEN				--checks if counter reached its max value (50MHz/counter = frequency of note)
				FCounter <= "0000000000000000";						--if yes, back to 0 to restart
				FNote <= NOT(FNote);										--flips the current value of CNote1, making a square wave (0/1)
			ELSE FCounter <= FCounter + "0000000000000001";
			END IF;
						
			IF (GCounter = "0111110010010000") THEN				--checks if counter reached its max value (50MHz/counter = frequency of note)
				GCounter <= "0000000000000000";						--if yes, back to 0 to restart
				GNote <= NOT(GNote);										--flips the current value of CNote1, making a square wave (0/1)
			ELSE GCounter <= GCounter + "0000000000000001";
			END IF;
						
			IF (ACounter = "0110111011111001") THEN				--checks if counter reached its max value (50MHz/counter = frequency of note)
				ACounter <= "0000000000000000";						--if yes, back to 0 to restart
				ANote <= NOT(ANote);										--flips the current value of CNote1, making a square wave (0/1)
			ELSE ACounter <= ACounter + "0000000000000001";
			END IF;
						
			IF (BCounter = "0110001011011110") THEN				--checks if counter reached its max value (50MHz/counter = frequency of note)
				BCounter <= "0000000000000000";						--if yes, back to 0 to restart
				BNote <= NOT(BNote);										--flips the current value of CNote1, making a square wave (0/1)
			ELSE BCounter <= BCounter + "0000000000000001";
			END IF;
			
			IF (CCounter2 = "0010111010101001") THEN				--checks if counter reached its max value (50MHz/counter = frequency of note)
				CCounter2 <= "0000000000000000";						--if yes, back to 0 to restart
				CNote2 <= NOT(CNote2); 									--flips the current value of CNote1, making a square wave (0/1)
			ELSE CCounter2 <= CCounter2 + "0000000000000001";
			END IF;
			
			
		END IF;
	END PROCESS;
END behavior;


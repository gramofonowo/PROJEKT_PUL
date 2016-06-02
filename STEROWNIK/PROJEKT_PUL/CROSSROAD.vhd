----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:09:33 05/16/2016 
-- Design Name: 
-- Module Name:    CROSSROAD - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CROSSROAD is
     Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  dioda : out std_logic_vector(7 downto 0);
           dioda1 : out  STD_LOGIC_vector(2 downto 0); --TODO
			  anodes : out STD_LOGIC_VECTOR(3 downto 0); 
           seg : out  STD_LOGIC_VECTOR(6 downto 0)
			  );
end CROSSROAD;

architecture Behavioral of CROSSROAD is
type STANY is (STAN1, STAN2, STAN3, STAN4, STAN5, STAN6, NOC, OFF);
signal STAN, STAN_NAST : STANY;
signal sel : STD_LOGIC_VECTOR (1 downto 0):="00";
signal dzien : std_logic := '1';
signal test : std_logic_vector(7 downto 0);
signal test1 : std_logic_vector(2 downto 0);
signal daylight : std_logic_vector(2 downto 0); --implementacja
signal x : std_logic_vector(15 downto 0);--:="00000000000000"; --kod dla 7seg DLA 1A: 1/0000000 A/0000000
signal cnt1 : std_logic_vector(2 downto 0) := "000";--counters cnt1--implementacja 
signal cnt2 : std_logic_vector(3 downto 0) := "0000";
signal cnt3 : std_logic_vector(1 downto 0) :="00";
signal cnt4 : std_logic :='1';
signal clk_div2s : std_logic_vector(26 downto 0);
signal clk_div30s : std_logic_vector(30 downto 0);
signal clk_div1ms : std_logic_vector(16 downto 0);
signal digit : STD_LOGIC_VECTOR (3 downto 0);
begin


--Sterowanie wyswietlaczem 7-seg--

process (sel, x) is
	begin		
			case sel is 
				when "00" => digit <= x(3 downto 0);
					if sel ="00" then anodes <= "0001"; else null; end if; 
				when "01" => digit <= x(7 downto 4);
					if sel ="01" then anodes <= "0010"; else null; end if; 
				when "10" => digit <= x(11 downto 8);
					if sel ="10" then anodes <= "0100"; else null; end if; 
				when others => digit <= x(15 downto 12);
					if sel ="11" then anodes <= "1000"; else null; end if; 
			end case;
			
	end process;		


process (clk, digit) is
	begin 
		if (clk'event and clk ='1') then
			case digit is
				when X"0" => seg <= "0000000";			--definicja cyfry 0
				when X"1" => seg <= "0110000";			--definicja cyfry 1
				when X"2" => seg <= "1101101";			--definicja cyfry 2
				when X"3" => seg <= "1111001";			--definicja cyfry 3
				when X"4" => seg <= "0110011";			--definicja cyfry 4
				when X"5" => seg <= "1011011";			--definicja cyfry 5
				when X"6" => seg <= "1011111";			--definicja cyfry 6
				when X"7" => seg <= "1110010";			--definicja cyfry 7
				when X"8" => seg <= "1111111";			--definicja cyfry 8
				when X"9" => seg <= "1110110";--N
				when X"A" => seg <= "1110111";
				when X"B" => seg <= "1111110";--0
				when X"C" => seg <= "1001110";
				when X"F" => seg <= "1000111";
				when X"E" => seg <= "1001111";
				when others => seg <= "1000111";
				--definicja litery E
			end case;
		end if; 
	end process;
--end sterowanie wyswietlaczem 7seg--	

REJESTR:process(clk, reset)
		begin
			if(reset='1') then
				STAN<=OFF;	-- zmien na off			
			elsif(clk'Event and clk='1') then
				STAN<=STAN_NAST;
			end if;			
		end process REJESTR;

 		
AUTOMAT:process(STAN, cnt1, cnt2, cnt3)
		begin		
			STAN_NAST<=STAN;
				
			case STAN is					
							
				when STAN1=>				
						if cnt1>="000" then 
						x <= X"101A"; -- sygnalizator 1A
						test<="11000000";--dioda
						test1<="010";
					end if;	
					if cnt1>="001" then
						x <= X"102A"; --sygnalizator 2A
						test<="00000011";--dioda
						test1<="100";
					end if;	
					if cnt1>="010" then
						x <= X"101E"; --sygnalizator 1E
						test<="00000011";--dioda
						test1<="100";	
					end if;	
					if cnt1>="011" then
						x <= X"101C"; --sygnalizator 1C
						test<="11000000";--dioda
						test1<="010";
					end if;	
					if cnt1>="100" then
						x<=X"102C"; --sygnalizator 2C
						test<="00000011";--dioda
						test1<="100";	
					end if;
					if cnt1>="101" then
						x<=X"101F"; --sygnalizator 1F
						test<="00000011";--dioda
						test1<="100";	
					end if;		
					
					if dzien='0' then
						stan_nast<=noc;
					elsif cnt2>="1111" then
						stan_nast<=stan2; 
					end if;
						
				when STAN2=>				
					if cnt1>="000" then 
						x<=X"201A"; -- sygnalizator 1A
						test<="00011000";--dioda
						test1<="111";
					end if;	
					if cnt1>="001" then
						x<=X"202A"; --sygnalizator 2A
						test<="00000011";--dioda
						test1<="111";
					end if;	
					if cnt1>="010" then
						x<=X"201E"; --sygnalizator 1E
						test<="00011011";--dioda
						test1<="111";
					end if;	 
					if cnt1>="011" then
						x<=X"201C"; --sygnalizator 1C
						test<="00011000";--dioda
						test1<="111";
					end if;	
					if cnt1>="100" then
						x<=X"202C"; --sygnalizator 2C
						test<="00000011";--dioda
						test1<="111";
					end if;
					if cnt1>="101" then
						x<=X"201F"; --sygnalizator 1F
						test<="00011011";--dioda	
						test1<="111";						
					end if;
					
					if dzien='0' then
						stan_nast<=noc;
					elsif cnt3>="10" then
						stan_nast<=stan3; 
					end if;
					
				when STAN3=>				
					if cnt1>="000" then 
						x<=X"301A"; -- sygnalizator 1A
						test<="00000011";--dioda
						test1<="100";	
					end if;	
					if cnt1>="001" then
						x<=X"302A"; --sygnalizator 2A
						test<="00000011";--dioda
						test1<="100";	
					end if;	
					if cnt1>="010" then
						x<=X"301E"; --sygnalizator 1E
						test<="11000000";--dioda
						test1<="010";
					end if;	
					if cnt1>="011" then
						x<=X"301C"; --sygnalizator 1C
						test<="00000011";--dioda
						test1<="100";	
					end if;	
					if cnt1>="100" then
						x<=X"302C"; --sygnalizator 2C
						test<="00000011";--dioda
						test1<="100";	
					end if;
					if cnt1>="101" then
						x<=X"301F"; --sygnalizator 1F
						test<="11000000";--dioda	
						test1<="010";
					end if;
					
					if dzien='0' then
						stan_nast<=noc;
					elsif cnt2>="1111" then
						stan_nast<=stan4; 
					end if;
					
				when STAN4=>				
					if cnt1>="000" then 
						x<=X"401A"; -- sygnalizator 1A
						test<="00000011";--dioda
						test1<="111";
					end if;	
					if cnt1>="001" then
						x<=X"402A"; --sygnalizator 2A
						test<="00011011";--dioda
						test1<="111";
					end if;	
					if cnt1>="010" then
						x<=X"401E"; --sygnalizator 1E
						test<="00011000";--dioda
						test1<="111";
					end if;	
					if cnt1>="011" then
						x<=X"401C"; --sygnalizator 1C
						test<="00000011";--dioda
						test1<="111";
					end if;	
					if cnt1>="100" then
						x<=X"402C"; --sygnalizator 2C
						test<="00011011";--dioda
						test1<="111";
					end if;
					if cnt1>="101" then
						x<=X"401F"; --sygnalizator 1F
						test<="00011000";--dioda		
						test1<="111";
					end if;
					
					if dzien='0' then
						stan_nast<=noc;
					elsif cnt3>="10" then
						stan_nast<=stan5; 
					end if;
					
				when STAN5=>				
					if cnt1>="000" then 
						x<=X"501A"; -- sygnalizator 1A
						test<="00000011";--dioda
						test1<="100";	
					end if;	
					if cnt1>="001" then
						x<=X"502A"; --sygnalizator 2A
						test<="11000000";--dioda
						test1<="010";
					end if;	
					if cnt1>="010" then
						x<=X"501E";--sygnalizator 1E
						test<="00000011";--dioda
						test1<="100";	
					end if;	
					if cnt1>="011" then
						x<=X"501C"; --sygnalizator 1C
						test<="00000011";--dioda
						test1<="100";	
					end if;	
					if cnt1>="100" then
						x<=X"502C"; --sygnalizator 2C
						test<="11000000";--dioda
						test1<="010";
					end if;
					if cnt1>="101" then
						x<=X"501F"; --sygnalizator 1F
						test<="00000011";--dioda
						test1<="100";						
					end if;
					
					if dzien='0' then
						stan_nast<=noc;
					elsif cnt2>="1111" then
						stan_nast<=stan6; 
					end if;
					
				when STAN6=>				
					if cnt1>="000" then 
						x<=X"601A"; -- sygnalizator 1A
						test<="00011011";--dioda
						test1<="111";
					end if;	
					if cnt1>="001" then
						x<=X"602A"; --sygnalizator 2A
						test<="00011000";--dioda
						test1<="111";
					end if;	
					if cnt1>="010" then
						x<=X"601E"; --sygnalizator 1E
						test<="00000011";--dioda
						test1<="111";
					end if;	
					if cnt1>="011" then
						x<=X"601C"; --sygnalizator 1C
						test<="00011011";--dioda
						test1<="111";
					end if;	
					if cnt1>="100" then
						x<=X"602C"; --sygnalizator 2C
						test<="00011000";--dioda
						test1<="111";
					end if;
					if cnt1>="101" then
						x<=X"601F"; --sygnalizator 1F
						test<="00011000";--dioda
						test1<="111";						
					end if;
					
					if dzien='0' then
						stan_nast<=noc;
					elsif cnt3>="10" then
						stan_nast<=stan1; 
					end if;
				when NOC=>
					
					test<="00011000";
					test1<="001";	
					if cnt4='1' then						
						x<=X"09BC";
					else
						x<=X"9BC0";
					end if;
					--dioda
					if dzien='1' then
						stan_nast<=stan1;
					elsif cnt3>="10" then
						stan_nast<=off;
					end if;
				when OFF=>
				
					test<="00000000";
					test1<="000";	
					if cnt4='1' then						
						x<=X"9BC0";
					else
						x<=X"09BC";
					end if;	
					
					--dioda
					if dzien='1' then
						stan_nast<=stan1;
					elsif cnt3>="10" then
						stan_nast<=noc;
					end if;					
			end case;
			--end if;
		end process AUTOMAT;		
		
		dioda(0)<=test(0);
		dioda(1)<=test(1);
		dioda(2)<=test(2);
		dioda(3)<=test(3);
		dioda(4)<=test(4);
		dioda(5)<=test(5);
		dioda(6)<=test(6);
		dioda(7)<=test(7);
		
		dioda1(0)<=test1(0);
		dioda1(1)<=test1(1);
		dioda1(2)<=test1(2);

	
--IMPLEMENTATION CLOCK DIVIDER + COUNTERS--		
		-------------30 sec divider /sterowanie dayligh/---------
		process(clk, reset)
			begin
				if reset='1' then
				clk_div30s<=(others=>'0');
				elsif(clk'event and clk='1') then
					if clk_div30s>="1011001011010000010111100000000" then
						clk_div30s<=(others=>'0');
						if daylight>="110" and dzien='1' then
							daylight<="000";
							dzien<= not dzien;
						elsif daylight>="010" and dzien='0' then
							daylight<="000";
							dzien<= not dzien;
						else
							daylight<=daylight+"01";
						end if;
					else
						clk_div30s<=clk_div30s+"01";
					end if;
				end if; 
			end process;
			
		-------------2 sec divider /sterowanie zmiana stanow/-----------		
		process(clk, reset)
			begin
				if reset='1' then
				clk_div2s<=(others=>'0');
				elsif(clk'event and clk='1') then
					if clk_div2s>="101111101011110000100000000" then
						clk_div2s<=(others=>'0');
						cnt4 <= not cnt4;
						if (stan=stan2 or stan=stan4 or stan=stan6 or stan=noc or stan=off) then
							cnt2<="0000";
							
						else
							cnt2<=cnt2+"01"; --30s
						end if;
						
						if (stan=stan1 or stan=stan3 or stan=stan5 or cnt3>="10") then
							cnt3<="00";
						else
							cnt3<=cnt3+"01";--4s			
						end if;								
						
						if cnt1>="101" or dzien='0' then
							cnt1<="000";
						else
							cnt1<=cnt1+"01";							
						end if;					
						
					else
						clk_div2s<=clk_div2s+"01";
					end if;
				end if;
			end process;
			
		-------------1 milisec divider /sterowanie anodami wyswietlacza 7seg/-----------		
		process(clk, reset)
			begin
				if reset='1' then
				clk_div1ms<=(others=>'0');
				elsif(clk'event and clk='1') then
					if clk_div1ms(16)='1' then
						clk_div1ms<=(others=>'0');
						sel<= sel + "01";
					else
						clk_div1ms<=clk_div1ms+"01";
					end if;
				end if;
			end process;
end Behavioral;


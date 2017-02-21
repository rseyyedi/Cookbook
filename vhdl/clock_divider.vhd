-- TODO: Different architectures are not tested.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;


Library UNISIM;
use UNISIM.vcomponents.all;
use IEEE.NUMERIC_STD.ALL;

entity clocking is
    Port ( i_clk        : in STD_LOGIC;
           i_rst        : in STD_LOGIC;
           sel          : in STD_LOGIC;
           i_clk_divider: in std_logic_vector (3 downto 0);
           o_clk        : out STD_LOGIC;
           o_rst        : out STD_LOGIC
          );
end clocking;

-- ARCHITECTURE 1
-- Duty cycle for odd numbers is not 50%
architecture arch1 of clocking is
    signal r_clk_counter        : unsigned(3 downto 0);
    signal r_clk_divider        : unsigned(3 downto 0);
    signal r_clk_divider_half   : unsigned(3 downto 0);
begin

p_clk_divider: process(i_rst,i_clk)
begin
  if(i_rst='1') then
    r_clk_counter       <= (others=>'0');
    r_clk_divider       <= (others=>'0');
    r_clk_divider_half  <= (others=>'0');
    o_clk               <= '0';
  elsif(rising_edge(i_clk)) then
    r_clk_divider       <= unsigned(i_clk_divider)-1;
    r_clk_divider_half  <= unsigned('0'&i_clk_divider(3 downto 1)); -- half
    if(r_clk_counter < r_clk_divider_half) then 
      r_clk_counter   <= r_clk_counter + 1;
      o_clk           <= '0';
    elsif(r_clk_counter = r_clk_divider) then
      r_clk_counter   <= (others=>'0');
      o_clk           <= '1';
    else
      r_clk_counter   <= r_clk_counter + 1;
      o_clk           <= '1';
    end if;
  end if;
end process p_clk_divider;
end arch1;

-- ARCHITECTURE 2

architecture arch2 of clocking is
    signal count        : integer := 0;
    signal sel_prev     : std_logic := '0';
    signal temp         : std_logic := '0';
    signal clk_out_buf  : unsigned (4 downto 0) := (others => '0');
begin

rst_out <= rst_in;

DIVIDER:
    process (clk_in, rst_in, sel)
    begin
        if rst_in = '1' then
            count <= 0;
            temp <= '0';
        elsif sel = '1' then
                count <= 0;
                temp <= '0';
                clk_out <= '0';            
        elsif rising_edge (clk_in) then
            if count = (div_in-1) then
                count <= 0;
                temp <= not temp;
            else
                    count <= count + 1;
            end if;
        elsif falling_edge (clk_in) then
            if count = (div_in-1) then
                count <= 0;
                temp <= not temp;
            else
                count <= count + 1;
            end if;       
        end if;        
        clk_out <= temp;
    end process;

 
end arch2;

-- ARCHITECTURE 3

architecture  test1 of clocking is
    signal COUNTER : integer; --unsigned (1 downto 0);
    signal count        : unsigned (2 downto 0);
    signal div_1   : STD_LOGIC;
    signal div_2   : STD_LOGIC;
    signal temp    : std_logic;
    signal clk_low_cnt   : STD_LOGIC;
    signal clk_high_cnt   : STD_LOGIC;
begin

rst_out <= rst_in;

DIVIDER:
    process (clk_in, rst_in)
    begin
        if rst_in = '1' then
            count <= (others => '0');
        elsif rising_edge (clk_in) then
                count <= count + 1;
        end if;
        clk_out <= count(div_in-1);
    end process;

COUNTING:
process (clk_in,rst_in)
    begin
    IF (rst_in = '1') THEN
      COUNTER <= 0; --div_in; --3; -- "11";
      temp <= '0';
    ELSIF RISING_EDGE(clk_in) THEN
      IF COUNTER = (div_in -1 ) then --2 then -- "10" THEN
        COUNTER <= 0; -- "00";
        temp <= not temp;
      ELSE
        COUNTER <=  COUNTER + 1;
      END IF;
    END IF;
    clk_out <= temp;
END PROCESS;        

-- clk_r generation
PROCESS(clk_in,rst_in)
BEGIN
    IF (rst_in = '1') THEN
      clk_low_cnt  <= '0';
      clk_high_cnt <= '0';
    ELSIF RISING_EDGE(clk_in) THEN
      IF COUNTER = 0 then --"00" THEN
        clk_low_cnt <= '1';
      ELSE
        clk_low_cnt <= '0';
      END IF;
      IF COUNTER = (div_in -1 ) then --2 then --"10" THEN
        clk_high_cnt <= '1';
      ELSE
        clk_high_cnt <= '0';
      END IF;
    END IF;
END PROCESS;

-- div_1 generation
PROCESS(clk_in,rst_in)
BEGIN
    IF (rst_in = '1') THEN
      div_1 <= '0';
    ELSIF RISING_EDGE(clk_in) THEN
      IF clk_low_cnt = '1' THEN
        div_1 <= NOT div_1;
      END IF;
    END IF;
  END PROCESS;

-- clk_f generation
PROCESS(clk_in,rst_in)
  BEGIN
    IF (rst_in = '1') THEN
      div_2 <= '0';
    ELSIF FALLING_EDGE(clk_in) THEN
      IF clk_high_cnt = '1' THEN
        div_2 <= NOT div_2;
      END IF;
    END IF;
  END PROCESS;

clk_out <=  div_1 XOR div_2 when (div_in mod 2 = 1) else 


--END arch3;

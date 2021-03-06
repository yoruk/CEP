library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SRG is
   generic(N: natural := 8);
   port( CLK: in STD_LOGIC;                            -- clock signal
         NLOAD: in STD_LOGIC;                          -- low aktiver load, 1 = shiften, 0 = laden
         RESET: in STD_LOGIC;                          -- synchroner reset
         INPUT: in STD_LOGIC;                          -- 1STD_LOGIC input
         OUTPUT: out STD_LOGIC_VECTOR(N-1 downto 0));  -- N STD_LOGIC Output
end SRG;

architecture BEHAVIOUR of SRG is
   signal INTREG: STD_LOGIC_VECTOR(N-1 downto 0);

begin

   p1: process(CLK)
   begin
      if(CLK = '1' and CLK'event) then
         if(RESET = '1') then
            INTREG <= (others => '1') after 10 ns;
         elsif(NLOAD = '1') then
            for I in N-2 downto 0 loop
               INTREG(I) <= INTREG(I+1) after 10 ns;
            end loop;

            INTREG(N-1) <= INPUT after 10 ns;
         end if;
         
         OUTPUT <= INTREG after 10 ns;
      end if;
   end process p1;

   --p2: process(NLOAD, INTREG)
   --begin
   --  if NLOAD = '1' then
   --   OUTPUT <= (others => '1') after 10 ns;
   -- else
   --OUTPUT <= INTREG after 10 ns;
   -- end if;
   -- end process p2;

end BEHAVIOUR;


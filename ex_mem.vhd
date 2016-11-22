----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:23:08 11/22/2016 
-- Design Name: 
-- Module Name:    if_id - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ex_mem is
	port(
		rst : in STD_LOGIC;
		clk : in STD_LOGIC;
		-- EXE
		ex_mem_to_reg : in STD_LOGIC; --Ö±½ÓÐ´Èë¼Ä´æÆ÷(0)/¶ÁÈ¡RAM(1)
		ex_reg_write : in STD_LOGIC; --ÊÇ·ñÐ´Èë¼Ä´æÆ÷
		ex_reg_dst : in STD_LOGIC_VECTOR(3 downto 0); -- Ä¿µÄ¼Ä´æÆ÷µØÖ·£¨À©Õ¹Îª4Î»£©
		ex_result : in STD_LOGIC_VECTOR(15 downto 0);
		-- MEM
		mem_mem_to_reg : out STD_LOGIC; --Ö±½ÓÐ´Èë¼Ä´æÆ÷(0)/¶ÁÈ¡RAM(1)
		mem_reg_write : out STD_LOGIC; --ÊÇ·ñÐ´Èë¼Ä´æÆ÷
		mem_reg_dst : out STD_LOGIC_VECTOR(3 downto 0); -- Ä¿µÄ¼Ä´æÆ÷µØÖ·£¨À©Õ¹Îª4Î»£©
		mem_result : out STD_LOGIC_VECTOR(15 downto 0)
);
end ex_mem;

architecture Behavioral of ex_mem is
begin
	process(clk, rst)
	begin
		if clk'event and clk = '1' then
			ex_mem_to_reg <= mem_mem_to_reg;
			ex_reg_write <= mem_reg_write;
			ex_reg_dst <= mem_reg_dst;
			ex_result <= mem_result;
		end if;
		if rst = '0' then
			ex_mem_to_reg <= x"0000";
			ex_reg_write <= x"0000";
			ex_reg_dst <= x"0000";
			ex_result <= x"0000";
		end if;
	end process;
end Behavioral;


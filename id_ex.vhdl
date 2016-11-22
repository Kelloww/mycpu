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

entity id_ex is
	port(
		rst : in STD_LOGIC;
			clk : in STD_LOGIC;
			-- ID
			id_rx : in STD_LOGIC_VECTOR(15 downto 0);
			id_ry : in STD_LOGIC_VECTOR(15 downto 0);
			id_mem_to_reg : in STD_LOGIC; --Ö±½ÓÐ´Èë¼Ä´æÆ÷(0)/¶ÁÈ¡RAM(1)
			id_reg_write : in STD_LOGIC; --ÊÇ·ñÐ´Èë¼Ä´æÆ÷
			id_reg_dst : in STD_LOGIC_VECTOR(3 downto 0); -- Ä¿µÄ¼Ä´æÆ÷µØÖ·£¨À©Õ¹Îª4Î»£©
			id_alu_op : in STD_LOGIC_VECTOR(3 downto 0);
			-- EX
			ex_rx : out STD_LOGIC_VECTOR(15 downto 0);
			ex_ry : out STD_LOGIC_VECTOR(15 downto 0);
			ex_mem_to_reg : out STD_LOGIC; --Ö±½ÓÐ´Èë¼Ä´æÆ÷(0)/¶ÁÈ¡RAM(1)
			ex_reg_write : out STD_LOGIC; --ÊÇ·ñÐ´Èë¼Ä´æÆ÷
			ex_reg_dst : out STD_LOGIC_VECTOR(3 downto 0); -- Ä¿µÄ¼Ä´æÆ÷µØÖ·£¨À©Õ¹Îª4Î»£©
			ex_alu_op : out STD_LOGIC_VECTOR(3 downto 0)	
	);
end id_ex;

architecture Behavioral of id_ex is
begin
	process(clk, rst)
	begin
		if rst = '0' then
			ex_rx <= x"0000";
			ex_ry <= x"0000";
			ex_mem_to_reg <= x"0000";
			ex_reg_write <= x"0000";
			ex_reg_dst <= x"0000";
			ex_alu_op <= x"0000";
		else if clk'event and clk = '1' then
			ex_rx <= id_rx;
			ex_ry <= id_ry;
			ex_mem_to_reg <= id _mem_to_reg;
			ex_reg_write <= id_reg_write;
			ex_reg_dst <= id_reg_dst;
			ex_alu_op <=id_alu_op;
		end if;		
	end process;
end Behavioral;


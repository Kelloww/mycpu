----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:23:58 11/21/2016 
-- Design Name: 
-- Module Name:    cpu - Behavioral 
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

entity cpu is
    Port ( rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
			  
			  -- ram2
			  ram2_en : out STD_LOGIC;
			  ram2_we : out STD_LOGIC;
			  ram2_oe : out STD_LOGIC;
			  ram2_addr : out STD_LOGIC_VECTOR(15 downto 0);
			  ram2_data : inout STD_LOGIC_VECTOR(15 downto 0)
			  );
end cpu;

architecture Behavioral of cpu is

	--PC�Ĵ���
	component pc_reg
		port(
			rst : in STD_LOGIC;
			clk : in STD_LOGIC;
			pc_i : in STD_LOGIC_VECTOR(15 downto 0);
			pc_o : out STD_LOGIC_VECTOR(15 downto 0)
		);
	end component;

	--PC��1
	component pc_adder
		port(
			pc_i : in STD_LOGIC_VECTOR(15 downto 0);
			pc_o : out STD_LOGIC_VECTOR(15 downto 0)
		);
	end component;

	--ָ��MEM������
	component inst_mem
		port(
			inst_addr_i : in STD_LOGIC_VECTOR(15 downto 0);
			inst_i : in STD_LOGIC_VECTOR(15 downto 0);
			inst_o : out STD_LOGIC_VECTOR(15 downto 0);
			ram2_en : out STD_LOGIC;
			ram2_we : out STD_LOGIC;
			ram2_oe : out STD_LOGIC;
			ram2_addr : out STD_LOGIC_VECTOR(15 downto 0)
		);
	end component;
	
	--IF/ID�μĴ���
	component if_id
		port(
			rst : in STD_LOGIC;
			clk : in STD_LOGIC;
			if_pc : in STD_LOGIC_VECTOR(15 downto 0);
			if_inst : in STD_LOGIC_VECTOR(15 downto 0);
			id_pc : out STD_LOGIC_VECTOR(15 downto 0);
			id_inst : out STD_LOGIC_VECTOR(15 downto 0)
		);
	end component;

	--�Ĵ�����
	component registers
		port(
			-- ��ַ��չΪ4λ��������ʾ����Ĵ���
			-- ���Ĵ���
			r1_addr : in STD_LOGIC_VECTOR(3 downto 0);
			r2_addr : in STD_LOGIC_VECTOR(3 downto 0);
			r1_data : out STD_LOGIC_VECTOR(15 downto 0);
			r2_data : out STD_LOGIC_VECTOR(15 downto 0);
			-- д�Ĵ���
			rst : in STD_LOGIC;
			clk : in STD_LOGIC;
			we : in STD_LOGIC;
			waddr : in STD_LOGIC_VECTOR(3 downto 0);
			wdata : in STD_LOGIC_VECTOR(15 downto 0)
		);
	end component;
	
	--������Ԫ������
	component controller
		port(
			rst : in STD_LOGIC;
			pc_i : in STD_LOGIC_VECTOR(15 downto 0);
			inst_i : in STD_LOGIC_VECTOR(15 downto 0);
			-- registers data
			reg1_data_i : in STD_LOGIC_VECTOR(15 downto 0);
			reg2_data_i : in STD_LOGIC_VECTOR(15 downto 0);
			rx_o : out STD_LOGIC_VECTOR(15 downto 0);
			ry_o : out STD_LOGIC_VECTOR(15 downto 0);
			-- registers addr
			reg1_addr_o : out STD_LOGIC_VECTOR(15 downto 0);
			reg2_addr_o : out STD_LOGIC_VECTOR(15 downto 0);
			-- controll signals
			mem_to_reg : out STD_LOGIC; --ֱ��д��Ĵ���(0)/��ȡRAM(1)
			reg_write : out STD_LOGIC; --�Ƿ�д��Ĵ���
			reg_dst : out STD_LOGIC_VECTOR(3 downto 0); -- Ŀ�ļĴ�����ַ����չΪ4λ��
			alu_op : out STD_LOGIC_VECTOR(3 downto 0)
			-- TODO: other controll signals
		);
	end component;
	
	-- ID/EX�μĴ���Ԫ������
	component id_ex
		port(
			rst : in STD_LOGIC;
			clk : in STD_LOGIC;
			-- ID
			id_rx : in STD_LOGIC_VECTOR(15 downto 0);
			id_ry : in STD_LOGIC_VECTOR(15 downto 0);
			id_mem_to_reg : in STD_LOGIC; --ֱ��д��Ĵ���(0)/��ȡRAM(1)
			id_reg_write : in STD_LOGIC; --�Ƿ�д��Ĵ���
			id_reg_dst : in STD_LOGIC_VECTOR(3 downto 0); -- Ŀ�ļĴ�����ַ����չΪ4λ��
			id_alu_op : in STD_LOGIC_VECTOR(3 downto 0);
			-- EX
			ex_rx : out STD_LOGIC_VECTOR(15 downto 0);
			ex_ry : out STD_LOGIC_VECTOR(15 downto 0);
			ex_mem_to_reg : out STD_LOGIC; --ֱ��д��Ĵ���(0)/��ȡRAM(1)
			ex_reg_write : out STD_LOGIC; --�Ƿ�д��Ĵ���
			ex_reg_dst : out STD_LOGIC_VECTOR(3 downto 0); -- Ŀ�ļĴ�����ַ����չΪ4λ��
			ex_alu_op : out STD_LOGIC_VECTOR(3 downto 0)	
		);
	end component;
	
	component alu
		port(
			rst : in STD_LOGIC;
			rx_i : in STD_LOGIC_VECTOR(15 downto 0);
			ry_i : in STD_LOGIC_VECTOR(15 downto 0);
			alu_op : in STD_LOGIC_VECTOR(3 downto 0);
			result_o : out STD_LOGIC_VECTOR(15 downto 0)
		);
	end component;
	
	component ex_mem
		port(
			rst : in STD_LOGIC;
			clk : in STD_LOGIC;
			-- EXE
			ex_mem_to_reg : in STD_LOGIC; --ֱ��д��Ĵ���(0)/��ȡRAM(1)
			ex_reg_write : in STD_LOGIC; --�Ƿ�д��Ĵ���
			ex_reg_dst : in STD_LOGIC_VECTOR(3 downto 0); -- Ŀ�ļĴ�����ַ����չΪ4λ��
			ex_result : in STD_LOGIC_VECTOR(15 downto 0);
			-- MEM
			mem_mem_to_reg : out STD_LOGIC; --ֱ��д��Ĵ���(0)/��ȡRAM(1)
			mem_reg_write : out STD_LOGIC; --�Ƿ�д��Ĵ���
			mem_reg_dst : out STD_LOGIC_VECTOR(3 downto 0); -- Ŀ�ļĴ�����ַ����չΪ4λ��
			mem_result : out STD_LOGIC_VECTOR(15 downto 0)
		);
	end component;
	
	component data_mem
		port(
		
			rst : in STD_LOGIC;
			
			mem_to_reg : in STD_LOGIC;
			
			addr_i : in STD_LOGIC_VECTOR(15 downto 0);
			data_i : in STD_LOGIC_VECTOR(15 downto 0);
			data_o : out STD_LOGIC_VECTOR(15 downto 0);
			
			ram1_en : out STD_LOGIC;
			ram1_we : out STD_LOGIC;
			ram1_oe : out STD_LOGIC;
			ram1_addr : out STD_LOGIC_VECTOR(15 downto 0)
		);
	end component;
	
	component mem_wb
		port(
			rst : in STD_LOGIC;
			mem_wdata : in STD_LOGIC_VECTOR(15 downto 0);
			mem_reg_dst : in STD_LOGIC_VECTOR(3 downto 0);
			mem_reg_write : in STD_LOGIC; --�Ƿ�д��Ĵ���

			wb_wdata : out STD_LOGIC_VECTOR(15 downto 0);
			wb_reg_dst : out STD_LOGIC_VECTOR(3 downto 0);
			wb_reg_write : out STD_LOGIC --�Ƿ�д��Ĵ���
		);
	end component;
	
	-- pc_reg
	signal pc_out : STD_LOGIC_VECTOR(15 downto 0);
	-- pc_adder
	signal pc_plus_1 : STD_LOGIC_VECTOR(15 downto 0);
begin
	
	u1 : pc_reg
	port map(	
		rst => rst,
		clk => clk,
		pc_i => pc_4,
		pc_o => pc_out
	);

	u2 : pc_adder
	port map(
		pc_i => pc_out,
		pc_o => pc_4
	);

end Behavioral;


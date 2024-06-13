
library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use ieee.std_logic_misc.all;
	
package UQDAS_PKG is							 
	constant N_CC_MAX 					: integer := 32;	
	constant N_DU		 					: integer := 3;					
	constant N_BRANCH 					: integer := 8;					
	constant N_GROUP						: integer := 2;	
	constant N_VID_PER_GROUP 			: integer := 4;

	--	axi4 stream 63bit 
	type AXI4_STREAM_64 is record
		tdata 								: STD_LOGIC_VECTOR ( 63 downto 0 );
		tkeep 								: STD_LOGIC_VECTOR ( 7 downto 0 );
		tlast 								: STD_LOGIC;
	--	tready 								: STD_LOGIC;
		tuser 								: STD_LOGIC;
		tvalid 								: STD_LOGIC;
	end record AXI4_STREAM_64;

	--	axi4 stream 128bit 
	type AXI4_STREAM_128 is record
		tdata 								: STD_LOGIC_VECTOR ( 127 downto 0 );
		tkeep 								: STD_LOGIC_VECTOR ( 15 downto 0 );
		tlast 								: STD_LOGIC;
	--	tready 								: STD_LOGIC;
		tuser 								: STD_LOGIC;
		tvalid 								: STD_LOGIC;
	end record AXI4_STREAM_128;					  
	
	-- branch mac
	type BRANCH_MAC is record
		des									: std_logic_vector(47 downto 0);
		src									: std_logic_vector(47 downto 0);
	end record BRANCH_MAC;
		
	
	type AXI4_STREAM_ARRAY_BR is array (0 to N_BRANCH-1) of AXI4_STREAM_128;
	type AXI4_STREAM_ARRAY_DU is array (0 to N_DU-1) of AXI4_STREAM_128;		
	type BRANCH_MAC_BR        is array (0 to N_BRANCH-1) of BRANCH_MAC;		

	type AXI4_STREAM_ARRAY_BR_1 is array (0 to N_BRANCH-1) of AXI4_STREAM_64;
	type AXI4_STREAM_ARRAY_DU_1 is array (0 to N_DU-1) of AXI4_STREAM_64;		
	
	
	type ARRAY_CC_4bit		  is array (0 to N_CC_MAX-1) 			of std_logic_vector(03 downto 0);
	type ARRAY_CC_16bit       is array (0 to N_CC_MAX-1) 			of std_logic_vector(15 downto 0);
	type VID_ARRAY            is array (0 to N_VID_PER_GROUP-1) of std_logic_vector(15 downto 0);	  
	
	type ARRAY_16x32bit		  is array (0 to 15) of std_logic_vector(31 downto 0);
	type ARRAY_14x32bit		  is array (0 to 13) of std_logic_vector(31 downto 0);
	type ARRAY_7x32bit		  is array (0 to 06) of std_logic_vector(31 downto 0);  
	type ARRAY_4x9bit			  is array (0 to 03) of std_logic_vector(09 downto 0);  
	type ARRAY_4x16bit		  is array (0 to 03) of std_logic_vector(15 downto 0);  
	type ARRAY_4x18bit		  is array (0 to 03) of std_logic_vector(17 downto 0);  
	type ARRAY_4x32bit		  is array (0 to 03) of std_logic_vector(31 downto 0);  
	type ARRAY_4x34bit		  is array (0 to 03) of std_logic_vector(33 downto 0);  
	
	type ARRAY_8x11bit		  is array (0 to 07) of std_logic_vector(10 downto 0);  
	type ARRAY_8x16bit		  is array (0 to 07) of std_logic_vector(15 downto 0);  
	type ARRAY_8x17bit		  is array (0 to 07) of std_logic_vector(16 downto 0);  
	type ARRAY_8x22bit		  is array (0 to 07) of std_logic_vector(21 downto 0);  
	type ARRAY_8x32bit		  is array (0 to 07) of std_logic_vector(31 downto 0);  
	type ARRAY_8x34bit		  is array (0 to 07) of std_logic_vector(33 downto 0);  
	
	type ARRAY_16x64bit		  is array (0 to 15) of std_logic_vector(63 downto 0);
	type ARRAY_16x16bit		  is array (0 to 15) of std_logic_vector(15 downto 0);
	type ARRAY_16x15bit		  is array (0 to 15) of std_logic_vector(14 downto 0);
	type ARRAY_16x14bit		  is array (0 to 15) of std_logic_vector(13 downto 0);
	type ARRAY_16x13bit		  is array (0 to 15) of std_logic_vector(12 downto 0);
	type ARRAY_16x12bit		  is array (0 to 15) of std_logic_vector(11 downto 0);
	type ARRAY_16x11bit		  is array (0 to 15) of std_logic_vector(10 downto 0);
	type ARRAY_16x10bit		  is array (0 to 15) of std_logic_vector(09 downto 0);
	type ARRAY_16x9bit		  is array (0 to 15) of std_logic_vector(08 downto 0);
	type ARRAY_16x8bit		  is array (0 to 15) of std_logic_vector(07 downto 0);
	type ARRAY_16x7bit		  is array (0 to 15) of std_logic_vector(06 downto 0);
	type ARRAY_16x6bit		  is array (0 to 15) of std_logic_vector(05 downto 0);
	type ARRAY_16x5bit		  is array (0 to 15) of std_logic_vector(04 downto 0);
	type ARRAY_16x4bit		  is array (0 to 15) of std_logic_vector(03 downto 0);
	type ARRAY_16x3bit		  is array (0 to 15) of std_logic_vector(02 downto 0);
	type ARRAY_16x2bit		  is array (0 to 15) of std_logic_vector(01 downto 0);
	type ARRAY_16x1bit		  is array (0 to 15) of std_logic_vector(00 downto 0);
	
	type GROUP_INFOR is record
		-- common field 
		branch_assign 						: std_logic_vector(N_BRANCH-1 downto 0);
		ud_CompMeth							: std_logic_vector(03 downto 0);
		ud_IqWidth							: std_logic_vector(03 downto 0);		  
		enable_CompHdr						: std_logic;	 		
		vid									: VID_ARRAY;	
		ether_type							: std_logic_vector(15 downto 0);	
		des_mac								: std_logic_vector(47 downto 0);
		src_mac								: std_logic_vector(47 downto 0);
	end record GROUP_INFOR;			

	type CC_ID is record
	-- CC field
		cc_active 							: std_logic;		  
		filterIndex							: std_logic_vector(03 downto 0);
		pcid									: std_logic_vector(15 downto 0);			  
		scs									: std_logic_vector(03 downto 0);
	end record CC_ID;			

	type GROUP_ID is record
	-- CC field
		cc_active 							: std_logic_vector(N_CC_MAX-1 downto 0);		  
		filterIndex							: ARRAY_CC_4bit;
		pcid									: ARRAY_CC_16bit;			  
		scs									: ARRAY_CC_4bit;
	end record GROUP_ID;			

	type GROUP_INFOR_GR is array (0 to N_GROUP-1)  of GROUP_INFOR;
	type GROUP_ID_GR    is array (0 to N_GROUP-1)  of GROUP_ID;
	type CC_ID_MAX      is array (0 to N_CC_MAX-1) of CC_ID;

	constant	null_AXI_stream			: AXI4_STREAM_128 := ((others=>'0'),(others=>'0'),'0','0','0');	 
	constant	null_AXI_stream_64		: AXI4_STREAM_64 	:= ((others=>'0'),(others=>'0'),'0','0','0');	 
	constant	null_group_infor			: GROUP_INFOR 		:= ((others=>'0'),(others=>'0'),(others=>'0'),'0',(others => (others =>'0')),(others =>'0'),(others =>'0'),(others =>'0'));	 
	constant	null_mac_infor				: BRANCH_MAC 		:= ((others=>'0'),(others=>'0'));	 
	
	constant	null_group_infor_gr		: GROUP_INFOR_GR 	:= (others => null_group_infor);	 
	constant	null_mac_infor_br			: BRANCH_MAC_BR  	:= (others => null_mac_infor);	 	
	constant null_cc_id					: CC_ID := ('0',(others=>'0'),(others=>'0'),(others=>'0'));	  
	constant null_group_id				: GROUP_ID := ((others => '0'), (others => (others =>'0')),(others => (others =>'0')),(others => (others => '0'))); 
	constant null_group_id_gr			: GROUP_ID_GR := (others=> null_group_id);	
	
	-- constant hex
	constant x00						  : integer := 0   ;
	constant x04						  : integer := 4   ;
	constant x08						  : integer := 8   ;
	constant x0C						  : integer := 12  ;
	constant x10						  : integer := 16  ;
	constant x14						  : integer := 20  ;
	constant x18						  : integer := 24  ;
	constant x1C						  : integer := 28  ;
	constant x20						  : integer := 32  ;
	constant x24						  : integer := 36  ;
	constant x28						  : integer := 40  ;
	constant x2C						  : integer := 44  ;
	constant x30						  : integer := 48  ;
	constant x34						  : integer := 52  ;
	constant x38						  : integer := 56  ;
	constant x3C						  : integer := 60  ;
	constant x40						  : integer := 64  ;
	constant x44						  : integer := 68  ;
	constant x48						  : integer := 72  ;
	constant x4C						  : integer := 76  ;
	constant x50						  : integer := 80  ;
	constant x54						  : integer := 84  ;
	constant x58						  : integer := 88  ;
	constant x5C						  : integer := 92  ;
	constant x60						  : integer := 96  ;
	constant x64						  : integer := 100 ;
	constant x68						  : integer := 104 ;
	constant x6C						  : integer := 108 ;
	constant x70						  : integer := 112 ;
	constant x74						  : integer := 116 ;
	constant x78						  : integer := 120 ;
	constant x7C						  : integer := 124 ;
	constant x80						  : integer := 128 ;
	constant x84						  : integer := 132 ;
	constant x88						  : integer := 136 ;
	constant x8C						  : integer := 140 ;
	constant x90						  : integer := 144 ;
	constant x94						  : integer := 148 ;
	constant x98						  : integer := 152 ;
	constant x9C						  : integer := 156 ;
	constant xA0						  : integer := 160 ;
	constant xA4						  : integer := 164 ;
	constant xA8						  : integer := 168 ;
	constant xAC						  : integer := 172 ;
	constant xB0						  : integer := 176 ;
	constant xB4						  : integer := 180 ;
	constant xB8						  : integer := 184 ;
	constant xBC						  : integer := 188 ;
	constant xC0						  : integer := 192 ;
	constant xC4						  : integer := 196 ;
	constant xC8						  : integer := 200 ;
	constant xCC						  : integer := 204 ;
	constant xD0						  : integer := 208 ;
	constant xD4						  : integer := 212 ;
	constant xD8						  : integer := 216 ;
	constant xDC						  : integer := 220 ;
	constant xE0						  : integer := 224 ;
	constant xE4						  : integer := 228 ;
	constant xE8						  : integer := 232 ;
	constant xEC						  : integer := 236 ;
	constant xF0						  : integer := 240 ;
	constant xF4						  : integer := 244 ;
	constant xF8						  : integer := 248 ;
	constant xFC						  : integer := 252 ;
	

	
end package UQDAS_PKG;


package body UQDAS_PKG is
	---________________________	function &procedure
end package body UQDAS_PKG;

----------------------------------------------------------------------------------
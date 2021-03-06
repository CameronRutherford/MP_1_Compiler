library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;

-- List Control Unit
-- Wait 20s for ready on LL SL

entity ListProc is
    port (
        CLOCK : in STD_LOGIC;
        reset : in STD_LOGIC;
        opcode : in STD_LOGIC_VECTOR(7 downto 0);
        opA : in STD_LOGIC_VECTOR(4 downto 0);      -- operand register
        opB : in STD_LOGIC_VECTOR(4 downto 0);      -- operand register or memory location
        mem_bus_in : STD_LOGIC_VECTOR(127 downto 0);    -- data bus for reading from memory
        mem_bus_out : out STD_LOGIC_VECTOR(127 downto 0);   -- data bus for writing to memory
        mem_address : out STD_LOGIC_VECTOR(4 downto 0);
        memWrite : out STD_LOGIC
    );
end ListProc;

architecture ListProc of ListProc is

type regArray is array (0 to 1) of std_logic_vector(127 downto 0);


component  cntrl_unit is
  Port (CLOCK : in std_logic;
        reset: in std_logic;
        opcode_collection : std_logic_vector(7 downto 0);
        ready : out std_logic;
        reg_name : in std_logic_vector(4 downto 0);
        address_to_mem : in std_logic_vector(18 downto 0)
    
  );
  end component;

component bit128_reg is
    generic(N:integer := 128);
    Port ( load: in std_logic;
        clk: in std_logic;
        clr : in std_logic;
        data_in : in std_logic_vector(N-1 downto 0);
        data_out : out std_logic_vector(N-1 downto 0)
    );
end component;

component alu_block is
    Port(
        opcode : in std_logic_vector(3 downto 0);
        opA : in std_logic_vector(127 downto 0);
        opB : in std_logic_vector(127 downto 0);
        chinchilla: out signed(127 downto 0)
    );
end component;

--register signals
signal dataout : std_logic_vector(127 downto 0);
signal intOpA : integer;
signal A, B : std_logic_vector(127 downto 0);
signal regOutArray : regArray;
signal regWrite : std_logic_vector(2 downto 0);
signal chinchilla : std_logic_vector(127 downto 0);
signal decoded_opcode : std_logic_vector (3 downto 0);
signal resultRegNdx : integer := 2;
signal writeResult : std_logic;
signal internalMemWrite : std_logic;

begin
-- may need a process to synchronize the alu outputs into chinchilla before passing it to the result register    
    process(opA,  opB)
    begin
        intOpA <= to_integer(signed( opA ));
        A <= regOutArray(to_integer(signed( opA )))(127 downto 0);
        B <= regOutArray(to_integer(signed( opB )))(127 downto 0);           
    end process;

    process (opcode)
    variable v_regWrite : std_logic_vector(2 downto 0) := "000";
    begin
        
        mem_bus_out <= B;
        case opcode is 
            when  "00001001" => 
                decoded_opcode <= "0000";               --list add
                v_regWrite := (others => '0');
                v_regWrite(resultRegNdx) := '1';          -- turn on write to result register
                internalMemWrite <= '0';
            --TODO: implement the following in parser and hardware(?)
            when "00010100" => 
                decoded_opcode <= "0010";               --list and
                v_regWrite := (others => '0');
                v_regWrite(resultRegNdx) := '1';          -- turn on write to result register
                internalMemWrite <= '0';
            when "00010101" => 
                decoded_opcode <= "0011";               --list or
                v_regWrite := (others => '0');
                v_regWrite(resultRegNdx) := '1';          -- turn on write to result register
                internalMemWrite <= '0';
            when "00010110" => 
                decoded_opcode <=  "0100";              --list xor
                v_regWrite := (others => '0');
                v_regWrite(resultRegNdx) := '1';          -- turn on write to result register
                internalMemWrite <= '0';
            when "00010111" => 
                decoded_opcode <=  "0101";              --list not B
                v_regWrite := (others => '0');
                v_regWrite(resultRegNdx) := '1';          -- turn on write to result register
                internalMemWrite <= '0';
            --TODO : implement subtract and assign it an opcode
            when "10010011" =>
                decoded_opcode <= "XXXX"; 
                internalMemWrite <= '1';                --list store
                --v_regWrite := (others => '0');
            when "10010010" => 
                decoded_opcode <= "XXXX"; 
                v_regWrite := (others => '0');
                v_regWrite(intOpA) := '1';                --list load
                internalMemWrite <= '0';
            when others => decoded_opcode <= "XXXX";    -- if we get a bad opcode, undefined output
         end case;
         regWrite <= v_regWrite;
         writeResult <= regWrite(resultRegNdx);
    end process;

    results : bit128_reg
        port map(
            load => writeResult,
            clk => CLOCK,
            clr => reset, 
            data_in => chinchilla,
            data_out => mem_bus_out
        );
        
    regA : bit128_reg
        port map(
            load => regWrite(0),
            clk => CLOCK,
            clr => reset, 
            data_in => mem_bus_in,
            data_out => regOutArray(0)
        );
            
    regB : bit128_reg
        port map(
            load => regWrite(1),
            clk => CLOCK,
            clr => reset, 
            data_in => mem_bus_in,
            data_out => regOutArray(1)
        );
        
    alus : alu_block
        port map(
            opcode => decoded_opcode,
            opA => A,
            opB => B,
            std_logic_vector(chinchilla) => chinchilla
        );   
        memWrite <= internalMemWrite;
        mem_address <= opB;
end ListProc;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.math_real.all;

entity controller is -- single cycle control decoder
  port(op:                 in  STD_LOGIC_VECTOR(7 downto 0);
       funct:              in  STD_LOGIC_VECTOR(5 downto 0);
       zero:               in  STD_LOGIC;
       memtoreg, memwrite: out STD_LOGIC;
       mov_enable:         out STD_LOGIC;
       pcsrc, alusrc:      out STD_LOGIC;
       regdst, regwrite:   out STD_LOGIC;
       jump:               out STD_LOGIC;
       alucontrol:         out STD_LOGIC_VECTOR(2 downto 0));
end;

architecture struct of controller is
  component maindec
    port(op:                 in  STD_LOGIC_VECTOR(7 downto 0);
         memtoreg, memwrite: out STD_LOGIC;
         mov_enable:         out STD_LOGIC;
         branch, alusrc:     out STD_LOGIC;
         regwrite:           out STD_LOGIC;
         jump:               out STD_LOGIC;
         aluop:              out  STD_LOGIC_VECTOR(1 downto 0));
  end component;
  component aludec
    port(funct:      in  STD_LOGIC_VECTOR(5 downto 0);
         aluop:      in  STD_LOGIC_VECTOR(1 downto 0);
         alucontrol: out STD_LOGIC_VECTOR(2 downto 0));
  end component;
  signal aluop: STD_LOGIC_VECTOR(1 downto 0);
  signal branch, mov: STD_LOGIC;
begin
  md: maindec port map( op => op, memtoreg => memtoreg, memwrite => memwrite, branch => branch, mov_enable => mov,
                       alusrc => alusrc, regwrite => regwrite, jump => jump, aluop => aluop);
  ad: aludec port map(funct => funct, aluop => aluop, alucontrol => alucontrol);

  pcsrc <= branch and zero;
  mov_enable <= mov;
end;



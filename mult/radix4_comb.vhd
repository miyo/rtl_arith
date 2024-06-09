library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity radix4_comb is
  generic (
    WIDTH : integer := 32
    );
  port (
    a     : in  std_logic_vector(WIDTH-1 downto 0);
    b     : in  std_logic_vector(WIDTH-1 downto 0);
    q     : out std_logic_vector(2*WIDTH-1 downto 0)
    );
end entity radix4_comb;

architecture RTL of radix4_comb is

  constant REPETITION : integer := WIDTH/2 + 1;

begin

  process(a,b)
    variable m   : signed(WIDTH downto 0);
    variable m2  : signed(WIDTH downto 0);
    variable k   : signed(WIDTH-1+3 downto 0);

    variable acc : signed(2*WIDTH downto 0);
    
    variable tmp  : signed(WIDTH downto 0);
    variable kk : signed(2 downto 0);
  begin

    m := a(WIDTH-1) & signed(a);
    m2 := signed(a & "0");
    k := signed("00" & b & "0");
    acc := to_signed(0, 2*WIDTH+1);

    for i in 0 to REPETITION-2 loop
      tmp  := acc(2*WIDTH downto WIDTH);
      kk   := k(2 downto 0);
          
      case kk is
        when "000"  => null;
        when "001"  => tmp := tmp + m;
        when "010"  => tmp := tmp + m;
        when "011"  => tmp := tmp + m2;
        when "100"  => tmp := tmp - m2;
        when "101"  => tmp := tmp - m;
        when "110"  => tmp := tmp - m;
        when "111"  => null;
        when others => null;
      end case;
          
      acc(2*WIDTH downto WIDTH) := tmp(WIDTH downto 0); -- update
      acc := acc(2*WIDTH) & acc(2*WIDTH) & acc(2*WIDTH downto 2); -- signed shift
          
      k := "00" & k(WIDTH-1+3 downto 2);
          
    end loop;
    
    q <= std_logic_vector(acc(2*WIDTH-1 downto 0));
    
  end process;

end RTL;

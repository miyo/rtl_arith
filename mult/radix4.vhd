library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity radix4 is
  generic (
    WIDTH : integer := 32
    );
  port (
    clk   : in  std_logic;
    nd    : in  std_logic;
    a     : in  std_logic_vector(WIDTH-1 downto 0);
    b     : in  std_logic_vector(WIDTH-1 downto 0);
    q     : out std_logic_vector(2*WIDTH-1 downto 0);
    valid : out std_logic
    );
end entity radix4;

architecture RTL of radix4 is

  signal m   : signed(WIDTH downto 0);
  signal m2  : signed(WIDTH downto 0);
  signal k   : signed(WIDTH-1+3 downto 0);

  signal acc : signed(2*WIDTH-1 downto 0);
  signal cnt : unsigned(31 downto 0);

  constant REPETITION : integer := WIDTH/2 + 1;
  
begin

  process(clk)
    variable tmp  : signed(WIDTH downto 0);
    variable tmp2 : signed(2*WIDTH downto 0);
    variable kk : signed(2 downto 0);
  begin
    if rising_edge(clk) then
      if nd = '1' then
        m     <= a(WIDTH-1) & signed(a);
        m2    <= signed(a & "0");
        k     <= signed("00" & b & "0");
        cnt   <= to_unsigned(0, cnt'length);
        acc   <= to_signed(0, acc'length);
        valid <= '0';
      else
        if cnt = REPETITION - 1 then
          valid <= '1';
          q     <= std_logic_vector(acc);
        else
          
          tmp2 := acc(2*WIDTH-1) & acc; -- signed extended
          tmp  := acc(2*WIDTH-1) & tmp2(WIDTH*2-1 downto WIDTH); -- signed extended
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
          
          tmp2(2*WIDTH downto WIDTH) := tmp(WIDTH downto 0); -- update
          tmp2 := tmp2(2*WIDTH) & tmp2(2*WIDTH) & tmp2(2*WIDTH downto 2); -- signed shift
          
          cnt <= cnt + 1;
          acc <= tmp2(2*WIDTH-1 downto 0);
          k   <= "00" & k(k'high downto 2);
          
        end if;
      end if;
    end if;
  end process;

end RTL;

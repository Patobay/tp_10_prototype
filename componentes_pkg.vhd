library IEEE;
use IEEE.std_logic_1164.all;

package componentes_pkg is
    component ffd is
        generic(
            constant N : natural := 1);
        port(
            rst : in std_logic;
            D   : in std_logic_vector (N-1 downto 0);
            hab : in std_logic;
            clk : in std_logic;
            Q   : out std_logic_vector (N-1 downto 0));
    end component;
    component det_tiempo is
        generic (
             constant N : natural := 4);
        port(
            rst : in std_logic;
            pulso : in std_logic;
            hab : in std_logic;
            clk : in std_logic;
            med : out std_logic;
            tiempo : out std_logic_vector (N-1 downto 0));
    end component;
    component sipo is
        generic(
            N : natural := 4);
        port(
            rst     : in std_logic;
            entrada : in std_logic;
            hab     : in std_logic;
            clk     : in std_logic;
            Q       : out std_logic_vector (N-1 downto 0));
    end component;
end package;

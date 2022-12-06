library IEEE;
use IEEE.std_logic_1164.all;
use work.ffd_pkg.all;
use work.det_tiempo_pkg.all;
use work.sipo_pkg.all;


entity receptor_control is
port(
    rst        : in std_logic;    
    infrarrojo : in std_logic;    
    hab        : in std_logic;    
    clk        : in std_logic;                     
    valido     : out std_logic;  
    dir        : out std_logic_vector(7 downto 0);
    cmd        : out std_logic_vector(7 downto 0)
    );
    
end entity;

architecture solucion of receptor_control is
begin


end architecture;

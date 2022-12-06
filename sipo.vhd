library IEEE;
use IEEE.std_logic_1164.all;

package sipo_pkg is
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

library IEEE;
use IEEE.std_logic_1164.all;
use work.ffd_pkg.all;

entity sipo is
    generic(
        N : natural := 4);
    port(
        rst     : in std_logic;
        entrada : in std_logic;
        hab     : in std_logic;
        clk     : in std_logic;
        Q       : out std_logic_vector (N-1 downto 0));
end sipo;

architecture solucion of sipo is
    subtype tipo_estado is std_logic_vector(N-1 downto 0);
    signal Q_sig, Q_act: tipo_estado;
begin
    -- completar

    --Memoria de estado: 
    U1: ffd generic map(N=>N) port map (rst=>rst,hab=>hab,D=>Q_sig,clk=>clk,Q=>Q_act);
    
    --Logica de Estado Siguiente:
    Q_sig<= entrada & Q_act(N-1 downto 1);

    --Logica de Salida:
    Q<=Q_act;
    
end architecture;
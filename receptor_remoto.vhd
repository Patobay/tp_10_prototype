library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.componentes_pkg.all;


entity receptor_remoto is
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

architecture solucion of receptor_remoto is
    subtype tipo_estado is std_logic_vector (1 downto 0);
    
    constant espera: tipo_estado:="00";
    constant recepcion: tipo_estado:="01";
    constant guardando: tipo_estado:="10";
    constant C_32: std_logic_vector(31 downto 0):=(others=>'1');
    

    signal T_BAJO,T_ALTO:std_logic_vector(5 downto 0);
    signal E_sig,E_act:std_logic_vector(1 downto 0);
    signal rd_act:std_logic_vector(31 downto 0);
    signal rd_sig:std_logic;
    signal c_sig,c_act:std_logic_vector(31 downto 0);
    signal med_BAJO,med_ALTO:std_logic;
    signal cmd_neg_neg,dir_neg_neg:std_logic_vector(7 downto 0);
    
    

begin
    Tiempo_en_bajo: det_tiempo 
        generic map ( N=>6)
        port map(
                rst   => rst ,
                pulso => infrarrojo,
                hab   => hab ,
                clk   => clk,
                med   => med_BAJO,
                tiempo=> T_BAJO
                );

    Tiempo_en_alto: det_tiempo 
        generic map ( N=>6 )
        port map(
                rst   => rst ,
                pulso => not infrarrojo,
                hab   => hab ,
                clk   => clk,
                med   => med_ALTO,
                tiempo=> T_ALTO
                );

    FlipFlop: ffd
        generic map( N=>2 )
        port map(
                rst => rst,
                D   => E_sig,
                hab => hab,
                clk => clk,
                Q   => E_act
                );
   
                
    Registro: sipo 
        generic map(N =>32)
        port map(
                rst     => rst,
                entrada => rd_sig ,
                hab     => hab,
                clk     => clk,
                Q       => rd_act);

    Cuenta: ffd
    generic map( N=>32 )
    port map(
            rst => rst,
            D   => c_sig,
            hab => hab,
            clk => clk,
            Q   => c_act
            );
              
   
end architecture;

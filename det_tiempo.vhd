library IEEE;
use IEEE.std_logic_1164.all;

package det_tiempo_pkg is
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
end package;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.ffd_pkg.all;
entity det_tiempo is
    generic (
        constant N : natural := 4);
    port(
        rst : in std_logic;
        pulso : in std_logic;
        hab : in std_logic;
        clk : in std_logic;
        med : out std_logic;
        tiempo : out std_logic_vector (N-1 downto 0));
end det_tiempo;

architecture solucion of det_tiempo is
   
  subtype tipo_estado is std_logic_vector (N-1 downto 0);
  subtype e_cuenta is std_logic_vector(0 downto 0);
 
  signal C_act,C_sig, T_act,T_sig : tipo_estado;
  signal E_act,E_sig,med_act,med_sig : std_logic_vector(0 downto 0);
  constant cuenta:e_cuenta:="1";
  constant nocuenta:e_cuenta:="0";
  constant C1: tipo_estado:=((N-1 downto 1=>'0')&'1');
  constant C_max:tipo_estado:=(others=>'1');
  constant C0: tipo_estado:=(others=>'0');
  
    
begin
    -- Completar

     --Memoria de estado: 
     T1: ffd generic map(N=>N) port map (rst=>rst,hab=>hab,D=>T_sig,clk=>clk,Q=>T_act);
     C2: ffd generic map(N=>N) port map (rst=>rst,hab=>hab,D=>C_sig,clk=>clk,Q=>C_act);
     E1: ffd generic map(N=>1) port map (rst=>rst,hab=>hab,D=>E_sig,clk=>clk,Q=>E_act);
     M1: ffd generic map(N=>1) port map (rst=>rst,hab=>hab,D=>med_sig,clk=>clk,Q=>med_act);
    
    
     estado: process(pulso)
     begin
      E_sig<= cuenta when (pulso='0') else nocuenta;
        
    end process;

    contador:process(C_act,E_act,pulso)
    begin
        if(E_act=nocuenta) then
            if(pulso='1') then
                C_sig<=C_act;
            else
                C_sig<=C1;
            end if;
        else
            if(pulso='0' and not(C_act=C0)) then
                C_sig<= std_logic_vector(unsigned(C_act)+1);
            else
                C_sig<=C_act;
            end if;
        end if;
    end process;

     Tiempo_sal:process(pulso,T_act,med_act,C_act,E_act)
     begin
        if E_act=nocuenta then
            if (pulso='1') then
                med_sig<=med_act;
                T_sig<=T_act; 
            else
                med_sig<="0";
                T_sig<=T_act;
            end if ;
        else
            if(pulso='0') then
                med_sig<=med_act;
                T_sig<=T_act;
            else
                med_sig<="1";
                T_sig<=C_act;
            end if;
        end if;
    end process;

     tiempo<=T_act;
     med<=med_act(0);
     
end solucion;
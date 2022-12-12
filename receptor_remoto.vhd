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
    subtype tipo_estado is std_logic_vector(1 downto 0);
    
    constant espera: tipo_estado:="00";
    constant recepcion: tipo_estado:="01";
    constant guardado: tipo_estado:="10";
    constant C_32: std_logic_vector(5 downto 0):="100000";

    signal T_BAJO,T_ALTO:std_logic_vector(5 downto 0);
    signal E_sig,E_act:std_logic_vector(1 downto 0);
    signal rd_act,rd_sig:std_logic_vector(31 downto 0);
    signal c_sig,c_act:std_logic_vector(5 downto 0);
    signal med_BAJO,med_ALTO:std_logic;
    signal val_act, val_sig: std_logic_vector(0 downto 0);
    signal dir_act, dir_sig: std_logic_vector(7 downto 0);
    signal cmd_act, cmd_sig: std_logic_vector(7 downto 0);
    signal med_ALTO_act, med_ALTO_sig: std_logic_vector(0 downto 0);

    

begin

    Tiempo_en_bajo: det_tiempo 
        generic map ( N=>6)
        port map(
                rst   => rst        ,
                pulso => infrarrojo ,
                hab   => hab        ,
                clk   => clk        ,
                med   => med_BAJO   ,
                tiempo=> T_BAJO
                );

    Tiempo_en_alto: det_tiempo 
        generic map ( N=>6 )
        port map(
                rst   => rst            ,
                pulso => not infrarrojo ,
                hab   => hab            ,
                clk   => clk            ,
                med   => med_ALTO       ,
                tiempo=> T_ALTO
                );

    ESTADO_FFD: ffd
        generic map( N=>2)
        port map(
                rst => rst   ,
                D   => E_sig ,
                hab => hab   ,
                clk => clk   ,
                Q   => E_act
                );
   
                
    Registro: ffd
    generic map( N=>32 )
    port map(
            rst => rst    ,
            D   => rd_sig ,
            hab => hab    ,
            clk => clk    ,
            Q   => rd_act
            );
    

    Cuenta: ffd
    generic map( N=>6 )
    port map(
            rst => rst   ,
            D   => c_sig ,
            hab => hab   ,
            clk => clk   ,
            Q   => c_act
            );
            
    Valido_FF: ffd
    generic map( N=>1 )
    port map(
            rst => rst     ,
            D   => val_sig ,
            hab => hab     ,
            clk => clk     ,
            Q   => val_act
            );

    Dir_FF: ffd
    generic map( N=>8 )
    port map(
            rst => rst     ,
            D   => dir_sig ,
            hab => hab     ,
            clk => clk     ,
            Q   => dir_act
            );

    Cmd_FF: ffd
    generic map( N=>8 )
    port map(
            rst => rst     ,
            D   => cmd_sig ,
            hab => hab     ,
            clk => clk     ,
            Q   => cmd_act
            );
    medalto_FF: ffd
    generic map( N=>1 )
    port map(
            rst => rst     ,
            D   => med_ALTO_sig ,
            hab => hab     ,
            clk => clk     ,
            Q   => med_ALTO_act
            );

Det_estado: process(rst,med_ALTO,c_act,E_act)
    
begin

    E_sig   <= E_act   ;
    c_sig   <= c_act   ;
    rd_sig  <= rd_act  ;
    val_sig <= val_act ;
    dir_sig <= dir_act ;
    cmd_sig <= cmd_act ;
    med_ALTO_sig(0) <= med_ALTO;

    if(rst='1') then
        E_sig   <= espera  ;
    elsif(E_act=espera) then
        if(med_ALTO='1' and med_ALTO_act(0)='0' and ((unsigned(T_BAJO)<=52) and (unsigned(T_BAJO)>=42)) and ((unsigned(T_ALTO)<=26) and (unsigned(T_ALTO)>=20))) then
            E_sig   <= recepcion       ;
            c_sig   <= (others => '0') ;
            val_sig <= "0"             ;
            dir_sig <= (others => '0') ;
            cmd_sig <= (others => '0') ;
        end if;

    elsif(E_act = recepcion) then
        if(med_ALTO='1' and med_ALTO_act(0)='0') then
            if (((unsigned(T_BAJO)<=52) and (unsigned(T_BAJO)>=42)) and ((unsigned(T_ALTO)<=26) and (unsigned(T_ALTO)>=20))) then
                E_sig   <= recepcion     ;
                c_sig   <= (others=>'0') ;
                val_sig <= "0"           ;
            elsif (((unsigned(T_BAJO)<=4) and (unsigned(T_BAJO)>=1)) and ((unsigned(T_ALTO)<=4) and (unsigned(T_ALTO)>=1))) then
                E_sig   <= guardado                            ;
                c_sig   <= std_logic_vector(unsigned(c_act)+1) ;
                rd_sig  <= '0'&rd_act(31 downto 1)             ;                                     
            elsif (((unsigned(T_BAJO)<=4) and (unsigned(T_BAJO)>=1)) and ((unsigned(T_ALTO)<=10) and (unsigned(T_ALTO)>=7))) then
                E_sig   <= guardado                            ;
                c_sig   <= std_logic_vector(unsigned(c_act)+1) ;
                rd_sig  <= '1'&rd_act(31 downto 1)             ;
            else                             
                E_sig   <= espera  ;
            end if;
        end if;           
    else
        if(unsigned(c_act)<32) then
            E_sig   <= recepcion ;
        else
            E_sig <= espera;
            if(C_act=C_32 and ((rd_act(31 downto 24)=not rd_act(23 downto 16)) and (rd_act(15 downto 8)=not rd_act(7 downto 0)) )) then
                val_sig <= "1"                  ;
                dir_sig <= rd_act(7 downto 0)   ;
                cmd_sig <= rd_act(23 downto 16) ;
            else
                val_sig <= "0"           ;            
                dir_sig <= (others=>'0') ;
                cmd_sig <= (others=>'0') ;
            end if;
        end if;
    end if;
end process;

--salida
valido <= val_act(0) ;
dir    <= dir_act    ;
cmd    <= cmd_act    ;
   
end architecture;

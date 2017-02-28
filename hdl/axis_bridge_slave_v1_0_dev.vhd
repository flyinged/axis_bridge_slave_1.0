--------------------------------------------------------------------------------
--                       Paul Scherrer Institute (PSI)
--------------------------------------------------------------------------------
-- Unit    : axi_bridge_slave_v1_0.vhd
-- Author  : Goran Marinkovic, Section Diagnostic
-- Version : $Revision: 1.11 $
--------------------------------------------------------------------------------
-- Copyright© PSI, Section Diagnostic
--------------------------------------------------------------------------------
-- Comment : This is the top file for the AXI bridge.
--------------------------------------------------------------------------------
-- Std. library (platform) -----------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library axis_bridge_v1_0_lib;
use axis_bridge_v1_0_lib.all;

entity axis_bridge_slave_v1_0 is
   generic
   (
      --------------------------------------------------------------------------
      -- Stream
      --------------------------------------------------------------------------
      K_SOF                       : std_logic_vector( 7 downto  0) := X"FB"; -- K27.7
      K_EOF                       : std_logic_vector( 7 downto  0) := X"FD"; -- K29.7
      K_INT                       : std_logic_vector( 7 downto  0) := X"DC"; -- K28.6
      --------------------------------------------------------------------------
      -- AXI Slave
      --------------------------------------------------------------------------
      TIMEOUT_CYCLES              : integer := 1000; --timeout in AXI_CLK cycles. Value 0 disables timeout
      POSTED_WRITES               : std_logic := '1'; --ML84 posted writes
      IGNORE_MGT_BACKPRESSURE     : std_logic := '1'; --ML84 when 1, FSM does not wait if MGT FIFO becomes full
      RX_ADDR_MASK                : std_logic_vector(31 downto  0) := X"FFFF_FFFF"; --this value is ANDed with the RX address
      -- Parameters of Axi Slave Bus Interface
      C_S00_AXI_ID_WIDTH          : integer := 1;                             -- Width of ID for for write address, write data, read address and read data
      C_S00_AXI_DATA_WIDTH        : integer := 32;                            -- Width of S_AXI data bus
      C_S00_AXI_ADDR_WIDTH        : integer := 8;                             -- Width of S_AXI address bus
      C_S00_AXI_ARUSER_WIDTH      : integer := 0;                             -- Width of optional user defined signal in read address channel
      C_S00_AXI_RUSER_WIDTH       : integer := 0;                             -- Width of optional user defined signal in read data channel
      C_S00_AXI_AWUSER_WIDTH      : integer := 0;                             -- Width of optional user defined signal in write address channel
      C_S00_AXI_WUSER_WIDTH       : integer := 0;                             -- Width of optional user defined signal in write data channel
      C_S00_AXI_BUSER_WIDTH       : integer := 0                              -- Width of optional user defined signal in write response channel
   );
   port
   (
      --------------------------------------------------------------------------
      -- Debug
      --------------------------------------------------------------------------
      debug_clk                   : out    std_logic;
      debug                       : out    std_logic_vector(127 downto  0);
      --------------------------------------------------------------------------
      -- System
      --------------------------------------------------------------------------
      MGT_LINK_UP                 : in    std_logic := '1';
      AXI_ACLK                    : in    std_logic;
      AXI_ARESETN                 : in    std_logic;
      AXI_INT                     : out   std_logic;
      --------------------------------------------------------------------------
      -- MGT Stream Interface
      --------------------------------------------------------------------------
      --AXI Stream Master (TX)
      M00_AXIS_TREADY             : in    std_logic;
      M00_AXIS_TVALID             : out   std_logic;
      M00_AXIS_TUSER              : out   std_logic_vector( 3 downto  0);
      M00_AXIS_TDATA              : out   std_logic_vector(31 downto  0);
      --AXI Stream Slave (RX)
      S00_AXIS_TREADY             : out   std_logic;
      S00_AXIS_TVALID             : in    std_logic;
      S00_AXIS_TUSER              : in    std_logic_vector( 3 downto  0);
      S00_AXIS_TDATA              : in    std_logic_vector(31 downto  0);
      --------------------------------------------------------------------------
      -- AXI Slave
      --------------------------------------------------------------------------
      -- Write Address
      S00_AXI_AWID                : in    std_logic_vector(C_S00_AXI_ID_WIDTH-1   downto 0); --required
      S00_AXI_AWADDR              : in    std_logic_vector(31 downto  0);
      S00_AXI_AWVALID             : in    std_logic;
      S00_AXI_AWREADY             : out   std_logic;
      S00_AXI_AWLEN               : in    std_logic_vector( 7 downto  0); -- NBEATS-1 (0=1 beat)
      S00_AXI_AWSIZE              : in    std_logic_vector( 2 downto  0); -- NBYTES=2^AWSIZE
      S00_AXI_AWBURST             : in    std_logic_vector( 1 downto  0); -- "00" fixed, "01" increment
      -- Write Data
      S00_AXI_WDATA               : in    std_logic_vector(31 downto  0);
      S00_AXI_WLAST               : in    std_logic; --optional for slaves
      S00_AXI_WVALID              : in    std_logic;
      S00_AXI_WREADY              : out   std_logic;
      S00_AXI_WSTRB               : in    std_logic_vector( 3 downto  0);
      -- Write response.
      S00_AXI_BID                 : out   std_logic_vector(C_S00_AXI_ID_WIDTH-1 downto 0); --required
      S00_AXI_BRESP               : out   std_logic_vector( 1 downto  0);
      S00_AXI_BVALID              : out   std_logic;
      S00_AXI_BREADY              : in    std_logic;
      -- Read address.
      S00_AXI_ARID                : in    std_logic_vector(C_S00_AXI_ID_WIDTH-1   downto 0); --required
      S00_AXI_ARADDR              : in    std_logic_vector(31 downto  0);
      S00_AXI_ARVALID             : in    std_logic;
      S00_AXI_ARREADY             : out   std_logic;
      S00_AXI_ARLEN               : in    std_logic_vector( 7 downto  0);
      S00_AXI_ARSIZE              : in    std_logic_vector( 2 downto  0);
      S00_AXI_ARBURST             : in    std_logic_vector( 1 downto  0);
      -- Read Data
      S00_AXI_RID                 : out   std_logic_vector(C_S00_AXI_ID_WIDTH-1 downto 0);
      S00_AXI_RDATA               : out   std_logic_vector(31 downto  0);
      S00_AXI_RLAST               : out   std_logic;
      S00_AXI_RVALID              : out   std_logic;
      S00_AXI_RREADY              : in    std_logic;
      S00_AXI_RRESP               : out   std_logic_vector( 1 downto  0)
);
end entity axis_bridge_slave_v1_0;

architecture structural of axis_bridge_slave_v1_0 is

   -----------------------------------------------------------------------------
   -- Signals
   -----------------------------------------------------------------------------

   -- RX MGT
   signal   rx_tready             : std_logic := '0';
   -- RX frame
   signal   rx_frame_re           : std_logic := '0';
   signal   rx_frame_int          : std_logic := '0';
   signal   rx_frame_sof          : std_logic := '0';
   signal   rx_frame_eof          : std_logic := '0';
   signal   rx_frame_active       : std_logic := '0';

   signal   rx_frame_id_next      : unsigned( 3 downto  0) := (others => '0');
   signal   rx_frame_id           : std_logic_vector( 3 downto  0) := X"0";
   signal   rx_frame_id_eq        : std_logic := '0';

   signal   rx_frame_opcode       : std_logic_vector( 3 downto  0) := X"0";
   -- RX Interrupt
   signal   rx_int_pulse          : std_logic_vector( 5 downto  0) := (others => '0');
   -- RX FIFO
   signal   rx_fifo_rst           : std_logic := '0';

   signal   rx_fifo_d_we          : std_logic := '0';
   signal   rx_fifo_d_din         : std_logic_vector(35 downto  0) := (others => '0');
   signal   rx_fifo_d_af          : std_logic := '0';
   signal   rx_fifo_d_f           : std_logic := '0';

   signal   rx_fifo_d_re          : std_logic := '0';
   signal   rx_fifo_d_dout        : std_logic_vector(35 downto  0) := (others => '0');
   signal   rx_fifo_d_e           : std_logic := '0';
   signal   rx_fifo_d_ae          : std_logic := '0';

   signal   rx_fifo_i_we          : std_logic := '0';
   signal   rx_fifo_i_din         : std_logic_vector( 7 downto  0) := (others => '0');
   signal   rx_fifo_i_f           : std_logic := '0';

   signal   rx_fifo_i_re          : std_logic := '0';
   signal   rx_fifo_i_dout        : std_logic_vector( 7 downto  0) := (others => '0');
   signal   rx_fifo_i_e           : std_logic := '0';
   -- RX CRC32
   constant CRC_RESIDUAL          : std_logic_vector(31 downto 0) := X"1CDF4421";
   signal   rx_crc_rst            : std_logic := '0';
   signal   rx_crc_valid          : std_logic := '0';
   signal   rx_crc                : std_logic_vector(31 downto  0) := (others => '0');
   signal   rx_crc_err            : std_logic := '0';
   -- RX FSM
   --ML84 TODO: TIMEOUT as generic
   --constant TIMEOUT_CYCLES            : integer := 700;  --ML84 CHANGED: max transaction length 256 beats. Add some margin for response
   signal   gen_timeout_cnt           : integer;-- range 0 to TIMEOUT_CYCLES := TIMEOUT_CYCLES;
   signal   resp_timeout_cnt          : integer;-- range 0 to TIMEOUT_CYCLES := TIMEOUT_CYCLES;
   signal   gen_timeout, resp_timeout : std_logic;

   type state_type is
   (
      IDLE,
      DISCARD_FRAME,
      WR_MGT_SOF,
      WR_MGT_CMD,
      WR_MGT_ADDR,
      WR_MGT_DATA,
      WR_MGT_CRC,
      WR_MGT_EOF,
      WR_AXI_ACK_WAIT,
      WR_AXI_ACK,
      WR_AXI_ERROR,
      RD_MGT_SOF,
      RD_MGT_CMD,
      RD_MGT_ADDR,
      RD_MGT_CRC,
      RD_MGT_EOF,
      RD_AXI_DATA_WAIT,
      RD_AXI_DATA,
      RD_AXI_ERROR
   );
   signal   state                 : state_type;
   signal   state_write           : std_logic := '0';

   -- TX frame
   constant K_IDL                 : std_logic_vector(15 downto  0) := X"003C";
   signal   tx_cmd                : std_logic_vector(31 downto  0) := (others => '0');
   -- TX CRC32
   signal   tx_crc_rst            : std_logic := '0';
   signal   tx_crc_valid          : std_logic := '0';
   signal   tx_crc                : std_logic_vector(31 downto  0) := (others => '0');
   -- TX MGT
   signal   tx_tvalid             : std_logic := '0';
   signal   tx_tuser              : std_logic_vector( 3 downto  0) := (others => '0');
   signal   tx_tdata              : std_logic_vector(31 downto  0) := (others => '0');
   -- AXI
   signal   s_arid                : std_logic_vector(C_S00_AXI_ID_WIDTH - 1 downto 0) := (others => '0');
   signal   s_araddr              : std_logic_vector(31 downto  0) := (others => '0');
   signal   s_arlen               : std_logic_vector( 7 downto  0) := (others => '0');
   signal   s_arlen_cnt           : unsigned( 7 downto  0) := (others => '0');

   signal   s_rdata               : std_logic_vector(31 downto  0) := (others => '0');
   signal   s_rvalid              : std_logic := '0';

   signal   s_awid                : std_logic_vector(C_S00_AXI_ID_WIDTH - 1 downto 0) := (others => '0');
   signal   s_awaddr              : std_logic_vector(31 downto  0) := (others => '0');

   signal arsize_valid, awsize_valid : std_logic;

   signal ififo_cnt : natural range 0 to 4095;
   signal ififo_alarm : std_logic;
   signal gen_tout_r, resp_tout_r : std_logic;
   signal stat_gen_tout, stat_resp_tout, stat_dfifo_flush : unsigned(31 downto 0);
   signal s_bresp : std_logic_vector(1 downto 0); --ML84 posted writes

   -----------------------------------------------------------------------------
   -- Components
   -----------------------------------------------------------------------------
   component crc32_rtl is
   port
   (
      crcclk                      : in    std_logic;
      crcreset                    : in    std_logic;
      crcdatavalid                : in    std_logic;
      crcin                       : in    std_logic_vector(31 downto  0);
      crcout                      : out   std_logic_vector(31 downto  0)
   );
   end component crc32_rtl;

   component rx_data_fifo IS
   port
   (
      clk                         : in    std_logic;
      rst                         : in    std_logic;
      din                         : in    std_logic_vector(35 downto  0);
      wr_en                       : in    std_logic;
      rd_en                       : in    std_logic;
      dout                        : out   std_logic_vector(35 downto  0);
      prog_empty                  : out   std_logic;
      prog_full                   : out   std_logic;
      full                        : out   std_logic;
      empty                       : out   std_logic
   );
   end component rx_data_fifo;

   component rx_info_fifo IS
   port
   (
      clk                         : in    std_logic;
      rst                         : in    std_logic;
      din                         : in    std_logic_vector( 7 downto  0);
      wr_en                       : in    std_logic;
      rd_en                       : in    std_logic;
      dout                        : out   std_logic_vector( 7 downto  0);
      full                        : out   std_logic;
      empty                       : out   std_logic
   );
   end component rx_info_fifo;

   signal s_awready, s_arready, s_bvalid, s_wready : std_logic;
   signal tx_tready : std_logic;
   signal state_encode : std_logic_vector(4 downto 0);
   signal last_states : std_logic_Vector(31 downto 0);

begin

   -----------------------------------------------------------------------------
   -- Debug
   -----------------------------------------------------------------------------
   -- Common
   debug_clk                      <= AXI_ACLK;
   -- State machine
   state_encode                   <= "00001" when (state = IDLE            ) else
                                     "00010" when (state = DISCARD_FRAME   ) else
                                     "00011" when (state = WR_MGT_SOF      ) else
                                     "00100" when (state = WR_MGT_CMD      ) else
                                     "00101" when (state = WR_MGT_ADDR     ) else
                                     "00110" when (state = WR_MGT_DATA     ) else
                                     "00111" when (state = WR_MGT_CRC      ) else
                                     "01000" when (state = WR_MGT_EOF      ) else
                                     "01001" when (state = WR_AXI_ACK_WAIT ) else
                                     "01010" when (state = WR_AXI_ERROR    ) else
                                     "01011" when (state = WR_AXI_ACK      ) else
                                     "01100" when (state = RD_MGT_SOF      ) else
                                     "01101" when (state = RD_MGT_CMD      ) else
                                     "01110" when (state = RD_MGT_ADDR     ) else
                                     "01111" when (state = RD_MGT_CRC      ) else
                                     "10000" when (state = RD_MGT_EOF      ) else
                                     "10001" when (state = RD_AXI_DATA_WAIT) else
                                     "10011" when (state = RD_AXI_DATA     ) else
                                     "10100" when (state = RD_AXI_ERROR    ) else "00000";

   
   debug(4 downto 0) <= state_encode;
   debug(5)  <= s_arready; 
   debug(6)  <= S00_AXI_ARVALID; 
   debug(7)  <= S00_AXI_RREADY; 
   debug(8)  <= s_rvalid; 
   debug(9)  <= s_awready; 
   debug(10) <= S00_AXI_AWVALID; 
   debug(11) <= S00_AXI_BREADY; 
   debug(12) <= s_bvalid; 
   debug(13) <= s_wready; 
   debug(14) <= S00_AXI_WVALID; 

   debug(15) <= gen_timeout;
   debug(16) <= resp_timeout;

   RADDR_REG_P : process(AXI_ACLK)
   begin
       if rising_edge(AXI_ACLK) then
           if (S00_AXI_ARVALID = '1') then
               debug(63 downto 32) <= S00_AXI_ARADDR;
           end if;
       end if;
   end process;
   debug(95 downto 64) <= last_states;

   --store last 4 states (debug(63:32) = S(t-3) & S(t-2) & S(t-1) & S(t)
   DEBUG_P : process(AXI_ACLK)
   begin
       if rising_edge(AXI_ACLK) then
           if last_states(4 downto 0) /= state_encode then
               last_states(07 downto 00) <= "000" & state_encode;
               last_states(15 downto 08) <= last_states(07 downto 00);
               last_states(23 downto 16) <= last_states(15 downto 08);
               last_states(31 downto 24) <= last_states(23 downto 16);
           end if;
       end if;
   end process;




   -----------------------------------------------------------------------------
   -- STATISTICS
   -----------------------------------------------------------------------------
   STATS_P : process(AXI_ACLK)
   begin
       if rising_edge(AXI_ACLK) then
           if (AXI_ARESETN = '0') then
               stat_gen_tout    <= (others => '0');
               stat_resp_tout   <= (others => '0');
               stat_dfifo_flush <= (others => '0');
           else
               gen_tout_r  <= gen_timeout;
               resp_tout_r <= resp_timeout;

               if gen_tout_r = '0' and gen_timeout = '1' then
                   stat_gen_tout <= stat_gen_tout+1;
               end if;

               if resp_tout_r = '0' and resp_timeout = '1' then
                   stat_resp_tout <= stat_resp_tout+1;
               end if;
               
               if rx_fifo_d_f = '1' and rx_fifo_i_e = '1' then
                   stat_dfifo_flush <= stat_dfifo_flush+1;
               end if;
           end if;
       end if;
   end process;

   -----------------------------------------------------------------------------
   -- RX MGT interface
   -----------------------------------------------------------------------------
   rx_tready                      <= AXI_ARESETN and not rx_fifo_d_f and not rx_fifo_i_f and MGT_LINK_UP; -- receive data when not under reset, and fifo not full
   S00_AXIS_TREADY                <= rx_tready;

   -----------------------------------------------------------------------------
   -- RX frame new word
   -----------------------------------------------------------------------------
   rx_frame_re                    <= rx_tready and S00_AXIS_TVALID;           -- rx_frame_re marks valid RX data

   -----------------------------------------------------------------------------
   -- RX frame detect interrupt (INT) and start (SOF) and end (EOF)
   -----------------------------------------------------------------------------
   rx_frame_int                   <= '1' when ((rx_frame_re = '1') and (S00_AXIS_TUSER( 1 downto  0) = "01") and (S00_AXIS_TDATA(15 downto  0) = (X"00" & K_INT))) else '0';
   rx_frame_sof                   <= '1' when ((rx_frame_re = '1') and (S00_AXIS_TUSER( 3 downto  2) = "01") and (S00_AXIS_TDATA(31 downto 16) = (X"00" & K_SOF))) else '0';
   rx_frame_eof                   <= '1' when ((rx_frame_re = '1') and (S00_AXIS_TUSER( 1 downto  0) = "01") and (S00_AXIS_TDATA(15 downto  0) = (X"00" & K_EOF))) else '0';

   -----------------------------------------------------------------------------
   -- Interrupt interface
   -----------------------------------------------------------------------------
   process(AXI_ACLK)
   begin
      if rising_edge(AXI_ACLK) then
         rx_int_pulse             <= rx_int_pulse(rx_int_pulse'left - 1 downto 0) & '0';
         if (rx_frame_int = '1') then 
            rx_int_pulse          <= (others => '1');
         end if;
      end if;
   end process;

   AXI_INT                        <= rx_int_pulse(rx_int_pulse'left);

   -----------------------------------------------------------------------------
   -- RX frame active and id
   -----------------------------------------------------------------------------
   process(AXI_ACLK)
   begin
      if rising_edge(AXI_ACLK) then
         if (AXI_ARESETN = '0') then
            rx_frame_active       <= '0';
         else
            if    (rx_frame_sof = '1') then
               rx_frame_active    <= '1';
            elsif (rx_frame_eof = '1') then
               rx_frame_active    <= '0';
            end if;
         end if;
      end if;
   end process;

   process(AXI_ACLK)
   begin
      if rising_edge(AXI_ACLK) then
         if (AXI_ARESETN = '0') then
            rx_frame_id_next      <= X"0";
         else
            if (rx_frame_eof = '1') then
               rx_frame_id_next   <= rx_frame_id_next + 1;
            end if;
         end if;
      end if;
   end process;

   -----------------------------------------------------------------------------
   -- RX frame CRC
   -----------------------------------------------------------------------------
   rx_crc_rst                     <= rx_frame_sof; -- clear crc calculation if rx_frame_sof is detected
   rx_crc_valid                   <= rx_frame_re and rx_frame_active and not rx_frame_eof;

   CRC_RX: entity axis_bridge_v1_0_lib.crc32_rtl
   port map
   (
      CRCCLK                      => AXI_ACLK,
      CRCRESET                    => rx_crc_rst,
      CRCDATAVALID                => rx_crc_valid,
      CRCIN                       => S00_AXIS_TDATA,
      CRCOUT                      => rx_crc
   );

   rx_crc_err                     <= '0' when (rx_crc = CRC_RESIDUAL) else '1';

   -----------------------------------------------------------------------------
   -- RX frame info FIFO
   -----------------------------------------------------------------------------
   rx_fifo_rst                    <= not AXI_ARESETN;

   rx_fifo_i_we                   <= rx_frame_eof;
   rx_fifo_i_din                  <= std_logic_vector(rx_frame_id_next) & "000" & rx_crc_err; --bit0 := CRC error must be '0' for packet to be accepted

   rx_info_fifo_inst: rx_info_fifo
   port map
   (
      clk                         => AXI_ACLK,
      rst                         => rx_fifo_rst,

      wr_en                       => rx_fifo_i_we,
      din                         => rx_fifo_i_din,
      full                        => rx_fifo_i_f,

      rd_en                       => rx_fifo_i_re,
      dout                        => rx_fifo_i_dout,
      empty                       => rx_fifo_i_e
   );

   rx_fifo_i_re                   <= '1' when (((state = WR_AXI_ACK_WAIT ) and (rx_fifo_i_e = '0')) or
                                               ((state = RD_AXI_DATA_WAIT) and (rx_fifo_i_e = '0'))) else '0';

   IFIFO_ALARM_P : process(AXI_ACLK)
   begin
       if rising_edge(AXI_ACLK) then
           if (rx_fifo_rst = '1') then
               ififo_cnt <= 0;
           else
               if rx_fifo_i_we = '1' and rx_fifo_i_re = '0' then
                   ififo_cnt <= ififo_cnt+1;
               elsif rx_fifo_i_we = '0' and rx_fifo_i_re = '1' and ififo_cnt > 0 then
                   ififo_cnt <= ififo_cnt-1;
               end if;
           end if;
       end if;
   end process;
   ififo_alarm <= '1' when ififo_cnt > 15 else '0';

   -----------------------------------------------------------------------------
   -- RX frame ID
   -----------------------------------------------------------------------------
   process(AXI_ACLK)
   begin
      if rising_edge(AXI_ACLK) then
         if ((state = WR_AXI_ACK_WAIT) or (state = RD_AXI_DATA_WAIT)) then
            if (rx_fifo_i_e = '0') then -- new frame in fifo
               rx_frame_id        <= rx_fifo_i_dout( 7 downto  4); -- get new frame ID
            end if;
         end if;
      end if;
   end process;

   -----------------------------------------------------------------------------
   -- RX data FIFO
   -----------------------------------------------------------------------------
   --ML84 CHANGE: changed logic for data FIFO write (removed dependance to rx_frame_active)
   --rx_fifo_d_we                   <= rx_frame_re and rx_frame_active and not rx_frame_eof;
   rx_fifo_d_we                   <= rx_frame_re and (not rx_frame_sof) and (not rx_frame_eof);
   rx_fifo_d_din                  <= std_logic_vector(rx_frame_id_next) & S00_AXIS_TDATA; -- store also packet ID

   rx_data_fifo_inst: rx_data_fifo
   port map
   (
      clk                         => AXI_ACLK,
      rst                         => rx_fifo_rst,

      wr_en                       => rx_fifo_d_we,
      din                         => rx_fifo_d_din,
      prog_full                   => rx_fifo_d_af,
      full                        => rx_fifo_d_f,

      rd_en                       => rx_fifo_d_re,
      dout                        => rx_fifo_d_dout,
      prog_empty                  => rx_fifo_d_ae,
      empty                       => rx_fifo_d_e
   );

   rx_fifo_d_re                   <= '1' when ( (rx_fifo_d_e = '0') and
                                                (
                                                 ((state = DISCARD_FRAME   ) and (rx_frame_id_eq = '0' )) or --ML84 CHANGE: fixed check on rx_frame_id_eq (shall discard when ID does NOT match)
                                                 ((state = RD_AXI_DATA_WAIT) and (rx_fifo_i_e = '0'    ) and (rx_fifo_i_dout(0) = '0') and (rx_frame_opcode = "0101")) or --pull command from DATA FIFO
                                                 ((state = RD_AXI_DATA     ) and (S00_AXI_RREADY  = '1')) or
                                                 ((state = RD_AXI_DATA_WAIT) and (rx_frame_id_eq = '0') and (rx_fifo_i_e = '0')) or --ML84 CHANGE2: added condition to remove garbage 
                                                 ((state = WR_AXI_ACK_WAIT ) and (rx_frame_id_eq = '0') and (rx_fifo_i_e = '0')) --ML84 CHANGE: added condition to remove garbage 
                                                )
                                              ) else '0';

   --ML84 CHANGE: added dependency to RX_FIFO_I_E
   rx_frame_id_eq                 <= '1' when (rx_fifo_d_dout(35 downto 32) = rx_frame_id) and (rx_fifo_i_e = '0') else '0';

   -----------------------------------------------------------------------------
   -- RX data opcode
   -----------------------------------------------------------------------------
   -- supported RX opcodes
   --  0001 -- AXI write response
   --  0101 -- AXI read  response
   --
   -- unsupported RX opcodes
   --  codes 0x0, 0x2, 0x3, 0x4, 0x6 0x7, 0x8, 0x9 , 0xA, 0xB, 0xC, 0xD, 0xE and 0xF are not supported
   rx_frame_opcode                <= '0'      &
                                     rx_fifo_d_dout(31) & -- READ/WRITE_n
                                     --rx_fifo_d_dout(28) & -- BURST/SINGLE_n
                                     '0' & --ML84 CHANGE: no difference between SINGLE and BURST responses
                                     rx_fifo_d_dout( 8);  -- RESP (only if AXI MODE)

   --ML84 NEW: added check on AWSIZE and ARSIZE (only value 2 supported, corresponding to 32 bits)
   awsize_valid <= '1' when S00_AXI_AWSIZE = "010" else '0';
   arsize_valid <= '1' when S00_AXI_ARSIZE = "010" else '0';
   -----------------------------------------------------------------------------
   -- FSM
   -----------------------------------------------------------------------------
   tx_tready <= '1' when IGNORE_MGT_BACKPRESSURE = '1' else M00_AXIS_TREADY;

   process(AXI_ACLK)
   begin
      if rising_edge(AXI_ACLK) then
         if (AXI_ARESETN = '0') then
            state                 <= IDLE;
         else
            --ML84 CHANGE: always generate a response
            if (gen_timeout = '1') then
               state <= IDLE;
            elsif (resp_timeout = '1') then
               if (state_write = '1') then
                  state           <= WR_AXI_ERROR;
               else
                  state           <= RD_AXI_ERROR;
               end if;
            --ML84 NEW: if RX DATA FIFO gets full and INFO FIFO is empty, then flush DATA FIFO.
            --elsif rx_fifo_d_f = '1' and rx_fifo_i_e = '1' then
            --    --flush FIFO
            --    state <= DISCARD_FRAME;
            else
               case state is
               when IDLE =>
                  --Always sample address
                  if    (S00_AXI_AWVALID = '1') then 
                     state        <= WR_MGT_SOF;
                  elsif (S00_AXI_ARVALID = '1') then
                     state        <= RD_MGT_SOF;
                  end if;
               --------------------------------------------------------------------
               when DISCARD_FRAME =>
                  --ML84 CHANGE: fixed check on rx_frame_id_eq (stop discarding when ID matches)
                  if ((rx_frame_id_eq = '1') or (rx_fifo_d_e = '1')) then
                     state        <= IDLE;
                  end if;
               --------------------------------------------------------------------
               when WR_MGT_SOF =>
                  if (tx_tready = '1') then
                     state        <= WR_MGT_CMD;
                  end if;
               when WR_MGT_CMD =>
                  if (tx_tready = '1') then
                     state        <= WR_MGT_ADDR;
                  end if;
               when WR_MGT_ADDR =>
                  if (tx_tready = '1') then
                     state        <= WR_MGT_DATA;
                  end if;
               when WR_MGT_DATA =>
                  if (tx_tready = '1') then
                      if (S00_AXI_WLAST = '1') then 
                        state     <= WR_MGT_CRC;
                     end if;
                  end if;
               when WR_MGT_CRC =>
                  if (tx_tready = '1') then
                     state        <= WR_MGT_EOF;
                  end if;
               when WR_MGT_EOF =>
                  if (tx_tready = '1') then
                     --ML84 posted writes
                     if (POSTED_WRITES = '1') then
                        state <= WR_AXI_ACK;
                     else
                        state <= WR_AXI_ACK_WAIT;
                     end if;
                  end if;
               when WR_AXI_ACK_WAIT => 
                  --Wait for GOOD packet in RX_FIFO with expected RESPONSE opcode. Missing response handled by timeout.
                  --ML84 WARNING: legacy support has been removed. If the on the other side of the MGT there's a PLB component, this is not going to work!!
                  if ((rx_fifo_i_e = '0') and (rx_fifo_i_dout(0) = '0') and (rx_frame_opcode = "0001")) then
                     state        <= WR_AXI_ACK;
                  end if;
               when WR_AXI_ACK =>
                  if (S00_AXI_BREADY = '1') then
                     state     <= DISCARD_FRAME;
                  end if;
               when WR_AXI_ERROR =>
                  if (S00_AXI_BREADY = '1') then
                     state     <= DISCARD_FRAME;
                  end if;
               --------------------------------------------------------------------
               when RD_MGT_SOF =>
                  if (tx_tready = '1') then --SOF sent, go on and send CMD
                    state         <= RD_MGT_CMD;
                  end if;
               when RD_MGT_CMD =>
                  if (tx_tready = '1') then --CMD sent, go on and send address
                     state        <= RD_MGT_ADDR;
                  end if;
               when RD_MGT_ADDR =>
                  if (tx_tready = '1') then --address sent, send CRC
                     state        <= RD_MGT_CRC;
                  end if;
               when RD_MGT_CRC =>
                  if (tx_tready = '1') then --crc sent, place eof
                     state        <= RD_MGT_EOF;
                  end if;
               when RD_MGT_EOF =>
                  if (tx_tready = '1') then --eof sent
                     state        <= RD_AXI_DATA_WAIT;
                  end if;
               when RD_AXI_DATA_WAIT =>
                  --ML84 WARNING: legacy support has been removed. If the on the other side of the MGT there's a PLB component, this is not going to work!!
                  if ((rx_fifo_i_e = '0') and (rx_fifo_i_dout(0) = '0') and (rx_frame_opcode = "0101")) then
                     state        <= RD_AXI_DATA;
                  end if;
               when RD_AXI_DATA =>
                  if (rx_fifo_d_re = '1') then
                     if (s_arlen_cnt = unsigned(s_arlen)) then
                        state     <= DISCARD_FRAME;
                     end if;
                  end if;
               when RD_AXI_ERROR =>
                  if (S00_AXI_RREADY = '1') then
                     if (s_arlen_cnt = unsigned(s_arlen)) then
                        state     <= DISCARD_FRAME;
                     end if;
                  end if;
               --------------------------------------------------------------------
               when others =>
                  state           <= IDLE;
               end case;
            end if;
         end if;
      end if;
   end process;

   -----------------------------------------------------------------------------
   -- Read or write request
   -----------------------------------------------------------------------------
   process(AXI_ACLK)
   begin
      if rising_edge(AXI_ACLK) then
         if (state = IDLE) then
            if (S00_AXI_AWVALID = '1') then -- Write request
               state_write        <= '1';
            else                            -- Read request
               state_write        <= '0';
            end if;
         end if;
      end if;
   end process;

   -----------------------------------------------------------------------------
   -- ML84 NEW: Time out to account for AXIS interface hanging
   -----------------------------------------------------------------------------
   process(AXI_ACLK)
   begin
      if rising_edge(AXI_ACLK) then
         --ML84 CHANGE: account for AXI master not acknowledging responses (BREADY/RREADY)
         if ((state = WR_AXI_ACK) or (state = RD_AXI_DATA)) and
            (gen_timeout_cnt /= 0) then
            gen_timeout_cnt           <= gen_timeout_cnt - 1;
         else
            gen_timeout_cnt           <= TIMEOUT_CYCLES;
         end if;
      end if;
   end process;
   gen_timeout <= '0'; --'1' when (gen_timeout_cnt = 0) and (TIMEOUT_CYCLES /= 0) else '0';

   -----------------------------------------------------------------------------
   -- ML84 NEW: Time out to account for missing response
   -----------------------------------------------------------------------------
   process(AXI_ACLK)
   begin
      if rising_edge(AXI_ACLK) then
         --ML84 CHANGE: always generate response on timeout
         --if ((state = WR_AXI_ACK_WAIT) or (state = RD_AXI_DATA_WAIT)) and (resp_timeout_cnt > 0) then
         if ((state = IDLE)        or
             (state = WR_AXI_ACK)  or 
             (state = RD_AXI_DATA) or 
             (state = DISCARD_FRAME) or
             (resp_timeout_cnt = 0) ) then
            resp_timeout_cnt <= TIMEOUT_CYCLES;
         else
            resp_timeout_cnt <= resp_timeout_cnt - 1;
         end if;
      end if;
   end process;
   resp_timeout <= '1' when (resp_timeout_cnt = 0) and (TIMEOUT_CYCLES /= 0) else '0';

   -----------------------------------------------------------------------------
   -- TX command
   -----------------------------------------------------------------------------
   process(AXI_ACLK)
   begin
      if rising_edge(AXI_ACLK) then
         if (state = IDLE) then
            tx_cmd                  <= (others => '0');
            if    (S00_AXI_AWVALID = '1') then
               tx_cmd(31)           <= '0'; -- write
               tx_cmd(28)           <= S00_AXI_AWBURST( 0); -- '0' for single, '1' for burst
               tx_cmd(26 downto 23) <= S00_AXI_WSTRB;
               tx_cmd( 7 downto  0) <= S00_AXI_AWLEN;
            elsif (S00_AXI_ARVALID = '1') then
               tx_cmd(31)           <= '1'; -- read
               tx_cmd(28)           <= S00_AXI_ARBURST( 0); -- '0' for single, '1' for burst
               tx_cmd( 7 downto  0) <= S00_AXI_ARLEN;
            end if;
         end if;
      end if;
   end process;

   -----------------------------------------------------------------------------
   -- TX CRC
   -----------------------------------------------------------------------------
   tx_crc_rst                     <= '1' when ((state = RD_MGT_SOF) or (state = WR_MGT_SOF)) else '0';
   tx_crc_valid                   <= '1' when ((tx_tready = '1') and ((state = WR_MGT_CMD) or (state = WR_MGT_ADDR) or ((state = WR_MGT_DATA) and (S00_AXI_WVALID = '1')) or (state = RD_MGT_CMD) or (state = RD_MGT_ADDR))) else '0';

   CRC_TX : crc32_rtl
   port map
   (
      CRCCLK                      => AXI_ACLK,
      CRCRESET                    => tx_crc_rst,
      CRCDATAVALID                => tx_crc_valid,
      CRCIN                       => tx_tdata,
      CRCOUT                      => tx_crc
   );

   -----------------------------------------------------------------------------
   -- TX data
   -----------------------------------------------------------------------------
   tx_tvalid                      <= '1' when ((state = WR_MGT_SOF ) or
                                               (state = WR_MGT_CMD ) or
                                               (state = WR_MGT_ADDR) or
                                               ((state = WR_MGT_DATA) and (S00_AXI_WVALID = '1')) or
                                               (state = WR_MGT_CRC ) or
                                               (state = WR_MGT_EOF ) or
                                               --
                                               (state = RD_MGT_SOF ) or
                                               (state = RD_MGT_CMD ) or
                                               (state = RD_MGT_ADDR) or
                                               (state = RD_MGT_CRC ) or
                                               (state = RD_MGT_EOF )) else '0';

   tx_tuser                       <= "0101" when ((state = WR_MGT_SOF) or
                                                  (state = RD_MGT_SOF) or
                                                  (state = WR_MGT_EOF) or
                                                  (state = RD_MGT_EOF)) else "0000";

   tx_tdata                       <= (X"00" & K_SOF & K_IDL) when (state = WR_MGT_SOF ) or (state = RD_MGT_SOF ) else
                                     tx_cmd                  when (state = WR_MGT_CMD ) or (state = RD_MGT_CMD ) else
                                     s_awaddr                when (state = WR_MGT_ADDR) else
                                     s_araddr                when (state = RD_MGT_ADDR) else
                                     S00_AXI_WDATA           when (state = WR_MGT_DATA) else
                                     tx_crc                  when (state = WR_MGT_CRC ) or (state = RD_MGT_CRC ) else
                                     (K_IDL & X"00" & K_EOF) when (state = WR_MGT_EOF ) or (state = RD_MGT_EOF ) else X"0000_0000";

   -----------------------------------------------------------------------------
   -- TX MGT Stream
   -----------------------------------------------------------------------------
   M00_AXIS_TVALID                <= tx_tvalid;
   M00_AXIS_TUSER                 <= tx_tuser;
   M00_AXIS_TDATA                 <= tx_tdata;

   -----------------------------------------------------------------------------
   -- AXI Read
   -----------------------------------------------------------------------------
   process (AXI_ACLK)
   begin
      if rising_edge(AXI_ACLK) then
         if (state = IDLE) then
            if (S00_AXI_ARVALID = '1') then -- Read request
               s_arid             <= S00_AXI_ARID;
            --else
            --   s_arid             <= (others => '0');
            end if;
         end if;
      end if;
   end process;

   S00_AXI_RID                    <= s_arid;

   process(AXI_ACLK)
   begin
      if rising_edge(AXI_ACLK) then
         if (state = IDLE) then
            if (S00_AXI_ARVALID = '1') then
               s_araddr           <= S00_AXI_ARADDR and RX_ADDR_MASK;
            end if;
         end if;
      end if;
   end process;

   --S00_AXI_ARREADY                <= '1' when ((state = RD_MGT_SOF) and (tx_tready = '1')) else '0';
   --ML84 CHANGE: always acknowledge addresses
   s_arready       <= '1' when (state = IDLE and S00_AXI_ARVALID = '1') else '0';
   S00_AXI_ARREADY <= s_arready;

   process(AXI_ACLK)
   begin
      if rising_edge(AXI_ACLK) then
         if (state = IDLE) then
            if (S00_AXI_ARVALID = '1') then
               s_arlen            <= S00_AXI_ARLEN;
            end if;
         end if;
      end if;
   end process;

   process(AXI_ACLK)
   begin
      if rising_edge(AXI_ACLK) then
         case state is
         when RD_AXI_DATA =>
            --Increase counter when forwarding received data
            --ML84 NOTE: check on S00_AXI_RREADY is already taken into account by rx_fifo_d_re
            if ((S00_AXI_RREADY = '1') and (rx_fifo_d_re = '1') and (s_arlen_cnt < unsigned(s_arlen))) then
               s_arlen_cnt        <= s_arlen_cnt + 1;
            end if;
         when RD_AXI_ERROR =>
            --Increase counter when discarding data
            if ((S00_AXI_RREADY = '1') and (s_arlen_cnt < unsigned(s_arlen))) then
               s_arlen_cnt        <= s_arlen_cnt + 1;
            end if;
         when others =>
            s_arlen_cnt           <= (others => '0');
         end case;
      end if;
   end process;

   s_rdata   <= rx_fifo_d_dout(31 downto 0);
   s_rvalid  <= '1' when (((state = RD_AXI_DATA) and (rx_fifo_d_e = '0'))  or (state = RD_AXI_ERROR)) else '0';

   S00_AXI_RDATA                  <= s_rdata;
   S00_AXI_RRESP                  <= "10" when (state = RD_AXI_ERROR) else "00"; -- SLERROR
   S00_AXI_RLAST                  <= '1' when (((state = RD_AXI_DATA) or (state = RD_AXI_ERROR)) and (s_arlen_cnt = unsigned(s_arlen))) else '0';
   S00_AXI_RVALID                 <= s_rvalid;

   -----------------------------------------------------------------------------
   -- AXI Write
   -----------------------------------------------------------------------------
   process (AXI_ACLK)
   begin
      if rising_edge(AXI_ACLK) then
         if (state = IDLE) then
            if (S00_AXI_AWVALID = '1') then -- Write request
               s_awid             <= S00_AXI_AWID;
            --else --changed
            --   s_awid             <= (others => '0');
            end if;
         end if;
      end if;
   end process;

   S00_AXI_BID                    <= s_awid;   -- Address phase

   process(AXI_ACLK)
   begin
      if rising_edge(AXI_ACLK) then
         if (state = IDLE) then
            if (S00_AXI_AWVALID = '1') then
               s_awaddr            <= S00_AXI_AWADDR and RX_ADDR_MASK;
            end if;
         end if;
      end if;
   end process;

   --ML84 CHANGE: always assert addresses
   --S00_AXI_AWREADY                <= '1' when ((state = IDLE) and (S00_AXI_AWVALID = '1') and (tx_tready = '1')) else '0';
   s_awready       <= '1' when ((state = IDLE) and (S00_AXI_AWVALID = '1')) else '0';
   S00_AXI_AWREADY <= s_awready;

   s_wready       <= '1' when ((state = WR_MGT_DATA) and (tx_tready = '1')) or
                              (state = WR_AXI_ERROR) --ML84 NEW: allow write after a timeout (data will be lost)
                         else '0';
   S00_AXI_WREADY <= s_wready;

   --ML84 posted writes
   s_bresp <= "00" when POSTED_WRITES = '1' else    
              rx_fifo_d_dout(1 downto 0);

   S00_AXI_BRESP                  <= s_bresp when (state = WR_AXI_ACK  ) else --Value from remote slave
                                     "10"    when (state = WR_AXI_ERROR) else --SLAVE ERROR    
                                     "00"; -- GOOD

   s_bvalid       <= '1' when ((state = WR_AXI_ACK) or (state = WR_AXI_ERROR)) else '0';
   S00_AXI_BVALID <= s_bvalid;

end structural;

--------------------------------------------------------------------------------
-- End of file
--------------------------------------------------------------------------------

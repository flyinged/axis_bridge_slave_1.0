--------------------------------------------------------------------------------
--                       Paul Scherrer Institute (PSI)
--------------------------------------------------------------------------------
-- Unit    : axi_bridge_tb.vhd
-- Author  : Goran Marinkovic, Section Diagnostic
-- Version : $Revision: 1.1 $
--------------------------------------------------------------------------------
-- Copyright© PSI, Section Diagnostic
--------------------------------------------------------------------------------
-- Comment : This is the test bench for the axi bridge.
--------------------------------------------------------------------------------
-- Std. library (platform) -----------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_textio.all;
use ieee.std_logic_1164.all;

library std;
use std.textio.all;

-- Work library (application) --------------------------------------------------
use work.cdn_axi4_package.all;

entity axi_bridge_tb is
end entity;

architecture testbench of axi_bridge_tb is

   ---------------------------------------------------------------------------
   -- Signals
   ---------------------------------------------------------------------------
   -- System
   constant C_AXI_ACLK_CYCLE      : time:= 8 ns;
   -----------------------------------------------------------------------------
   -- MGT stream interface
   -----------------------------------------------------------------------------
   constant K_SOF                 : std_logic_vector( 7 downto  0) := X"FB"; -- K27.7
   constant K_SOF_DATA            : std_logic_vector(31 downto  0) := X"00" & K_SOF & X"0000";
   constant K_EOF                 : std_logic_vector( 7 downto  0) := X"FD"; -- K29.7
   constant K_EOF_DATA            : std_logic_vector(31 downto  0) := X"0000" & X"00" & K_EOF;
   signal   LEGACY_MODE           : std_logic := '0';
   -- AXI stream master (TX)
   signal   M00_AXIS_TREADY       : std_logic := '0';
   signal   M00_AXIS_TVALID       : std_logic := '0';
   signal   M00_AXIS_TUSER        : std_logic_vector( 3 downto  0) := (others => '0');
   signal   M00_AXIS_TDATA        : std_logic_vector(31 downto  0) := (others => '0');
   -- AXI stream slave (RX)
   signal   S00_AXIS_TREADY       : std_logic := '0';
   signal   S00_AXIS_TVALID       : std_logic := '0';
   signal   S00_AXIS_TUSER        : std_logic_vector( 3 downto  0) := (others => '0');
   signal   S00_AXIS_TDATA        : std_logic_vector(31 downto  0) := (others => '0');
   -----------------------------------------------------------------------------
   -- Signals AXI bus
   -----------------------------------------------------------------------------
   -- System
   signal   ACLK                  : std_logic := '0';
   signal   ARESETN               : std_logic := '0';
   -----------------------------------------------------------------------------
   -- Signals AXI0 bus
   -----------------------------------------------------------------------------
   -- Write address channel
   signal   AXI0_AWID             : std_logic_vector(C_AXI_ID_BUS_WIDTH-1 downto 0) := (others => '0');
   signal   AXI0_AWADDR           : std_logic_vector(C_AXI_ADDRESS_BUS_WIDTH-1 downto 0) := (others => '0');
   signal   AXI0_AWVALID          : std_logic := '0';
   signal   AXI0_AWREADY          : std_logic := '0';
   signal   AXI0_AWLEN            : std_logic_vector(7 downto 0) := (others => '0');
   signal   AXI0_AWSIZE           : std_logic_vector(2 downto 0) := (others => '0');
   signal   AXI0_AWBURST          : std_logic_vector(1 downto 0) := (others => '0');
   signal   AXI0_AWLOCK           : std_logic := '0';
   signal   AXI0_AWCACHE          : std_logic_vector(3 downto 0) := (others => '0');
   signal   AXI0_AWPROT           : std_logic_vector(2 downto 0) := (others => '0');
   signal   AXI0_AWREGION         : std_logic_vector(3 downto 0) := (others => '0');
   signal   AXI0_AWQOS            : std_logic_vector(3 downto 0) := (others => '0');
   signal   AXI0_AWUSER           : std_logic_vector(C_AXI_AWUSER_BUS_WIDTH-1 downto 0) := (others => '0');
   --  Write data channel
   signal   AXI0_WDATA            : std_logic_vector(C_AXI_DATA_BUS_WIDTH-1 downto 0) := (others => '0');
   signal   AXI0_WLAST            : std_logic := '0';
   signal   AXI0_WVALID           : std_logic := '0';
   signal   AXI0_WREADY           : std_logic := '0';
   signal   AXI0_WSTRB            : std_logic_vector(3 downto 0);
   signal   AXI0_WUSER            : std_logic_vector(C_AXI_WUSER_BUS_WIDTH-1 downto 0) := (others => '0');
   -- Write response channel
   signal   AXI0_BID              : std_logic_vector(C_AXI_ID_BUS_WIDTH-1 downto 0) := (others => '0');
   signal   AXI0_BRESP            : std_logic_vector(1 downto 0) := (others => '0');
   signal   AXI0_BVALID           : std_logic := '0';
   signal   AXI0_BREADY           : std_logic := '0';
   signal   AXI0_BUSER            : std_logic_vector(C_AXI_BUSER_BUS_WIDTH-1 downto 0) := (others => '0');
   -- Read address channel
   signal   AXI0_ARID             : std_logic_vector(C_AXI_ID_BUS_WIDTH-1 downto 0) := (others => '0');
   signal   AXI0_ARADDR           : std_logic_vector(C_AXI_ADDRESS_BUS_WIDTH-1 downto 0) := (others => '0');
   signal   AXI0_ARVALID          : std_logic := '0';
   signal   AXI0_ARREADY          : std_logic := '0';
   signal   AXI0_ARLEN            : std_logic_vector(7 downto 0) := (others => '0');
   signal   AXI0_ARSIZE           : std_logic_vector(2 downto 0) := (others => '0');
   signal   AXI0_ARBURST          : std_logic_vector(1 downto 0) := (others => '0');
   signal   AXI0_ARLOCK           : std_logic := '0';
   signal   AXI0_ARCACHE          : std_logic_vector(3 downto 0) := (others => '0');
   signal   AXI0_ARPROT           : std_logic_vector(2 downto 0) := (others => '0');
   signal   AXI0_ARREGION         : std_logic_vector(3 downto 0) := (others => '0');
   signal   AXI0_ARQOS            : std_logic_vector(3 downto 0) := (others => '0');
   signal   AXI0_ARUSER           : std_logic_vector(C_AXI_ARUSER_BUS_WIDTH-1 downto 0) := (others => '0');
   -- Read data channel
   signal   AXI0_RID              : std_logic_vector(C_AXI_ID_BUS_WIDTH-1 downto 0) := (others => '0');
   signal   AXI0_RDATA            : std_logic_vector(C_AXI_DATA_BUS_WIDTH-1 downto 0) := (others=>'0');
   signal   AXI0_RLAST            : std_logic := '0';
   signal   AXI0_RVALID           : std_logic := '0';
   signal   AXI0_RREADY           : std_logic := '0';
   signal   AXI0_RRESP            : std_logic_vector(1 downto 0);
   signal   AXI0_RUSER            : std_logic_vector(C_AXI_RUSER_BUS_WIDTH-1 downto 0) := (others => '0');
   -----------------------------------------------------------------------------
   -- Signals AXI1 bus
   -----------------------------------------------------------------------------
   -- Write address channel
   signal   AXI1_AWID             : std_logic_vector(C_AXI_ID_BUS_WIDTH-1 downto 0) := (others => '0');
   signal   AXI1_AWADDR           : std_logic_vector(C_AXI_ADDRESS_BUS_WIDTH-1 downto 0) := (others => '0');
   signal   AXI1_AWVALID          : std_logic := '0';
   signal   AXI1_AWREADY          : std_logic := '0';
   signal   AXI1_AWLEN            : std_logic_vector(7 downto 0) := (others => '0');
   signal   AXI1_AWSIZE           : std_logic_vector(2 downto 0) := (others => '0');
   signal   AXI1_AWBURST          : std_logic_vector(1 downto 0) := (others => '0');
   signal   AXI1_AWLOCK           : std_logic := '0';
   signal   AXI1_AWCACHE          : std_logic_vector(3 downto 0) := (others => '0');
   signal   AXI1_AWPROT           : std_logic_vector(2 downto 0) := (others => '0');
   signal   AXI1_AWREGION         : std_logic_vector(3 downto 0) := (others => '0');
   signal   AXI1_AWQOS            : std_logic_vector(3 downto 0) := (others => '0');
   signal   AXI1_AWUSER           : std_logic_vector(C_AXI_AWUSER_BUS_WIDTH-1 downto 0) := (others => '0');
   --  Write data channel
   signal   AXI1_WDATA            : std_logic_vector(C_AXI_DATA_BUS_WIDTH-1 downto 0) := (others => '0');
   signal   AXI1_WLAST            : std_logic := '0';
   signal   AXI1_WVALID           : std_logic := '0';
   signal   AXI1_WREADY           : std_logic := '0';
   signal   AXI1_WSTRB            : std_logic_vector(3 downto 0);
   signal   AXI1_WUSER            : std_logic_vector(C_AXI_WUSER_BUS_WIDTH-1 downto 0) := (others => '0');
   -- Write response channel
   signal   AXI1_BID              : std_logic_vector(C_AXI_ID_BUS_WIDTH-1 downto 0) := (others => '0');
   signal   AXI1_BRESP            : std_logic_vector(1 downto 0) := (others => '0');
   signal   AXI1_BVALID           : std_logic := '0';
   signal   AXI1_BREADY           : std_logic := '0';
   signal   AXI1_BUSER            : std_logic_vector(C_AXI_BUSER_BUS_WIDTH-1 downto 0) := (others => '0');
   -- Read address channel
   signal   AXI1_ARID             : std_logic_vector(C_AXI_ID_BUS_WIDTH-1 downto 0) := (others => '0');
   signal   AXI1_ARADDR           : std_logic_vector(C_AXI_ADDRESS_BUS_WIDTH-1 downto 0) := (others => '0');
   signal   AXI1_ARVALID          : std_logic := '0';
   signal   AXI1_ARREADY          : std_logic := '0';
   signal   AXI1_ARLEN            : std_logic_vector(7 downto 0) := (others => '0');
   signal   AXI1_ARSIZE           : std_logic_vector(2 downto 0) := (others => '0');
   signal   AXI1_ARBURST          : std_logic_vector(1 downto 0) := (others => '0');
   signal   AXI1_ARLOCK           : std_logic := '0';
   signal   AXI1_ARCACHE          : std_logic_vector(3 downto 0) := (others => '0');
   signal   AXI1_ARPROT           : std_logic_vector(2 downto 0) := (others => '0');
   signal   AXI1_ARREGION         : std_logic_vector(3 downto 0) := (others => '0');
   signal   AXI1_ARQOS            : std_logic_vector(3 downto 0) := (others => '0');
   signal   AXI1_ARUSER           : std_logic_vector(C_AXI_ARUSER_BUS_WIDTH-1 downto 0) := (others => '0');
   -- Read data channel
   signal   AXI1_RID              : std_logic_vector(C_AXI_ID_BUS_WIDTH-1 downto 0) := (others => '0');
   signal   AXI1_RDATA            : std_logic_vector(C_AXI_DATA_BUS_WIDTH-1 downto 0) := (others=>'0');
   signal   AXI1_RLAST            : std_logic := '0';
   signal   AXI1_RVALID           : std_logic := '0';
   signal   AXI1_RREADY           : std_logic := '0';
   signal   AXI1_RRESP            : std_logic_vector(1 downto 0);
   signal   AXI1_RUSER            : std_logic_vector(C_AXI_RUSER_BUS_WIDTH-1 downto 0) := (others => '0');
   
   component axis_bridge_slave_v1_0 is
   generic
   (
      --------------------------------------------------------------------------
      -- Stream
      --------------------------------------------------------------------------
      K_SOF                       : std_logic_vector( 7 downto  0) := X"FB"; -- K27.7
      K_EOF                       : std_logic_vector( 7 downto  0) := X"FD"; -- K29.7
      K_INT                       : std_logic_vector( 7 downto  0) := X"DC"  -- K28.6
   );
   port
   (
      --------------------------------------------------------------------------
      -- System
      --------------------------------------------------------------------------
      AXI_ACLK                    : in    std_logic;
      AXI_ARESETN                 : in    std_logic;
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
      S00_AXI_AWADDR              : in    std_logic_vector(31 downto  0);
      S00_AXI_AWVALID             : in    std_logic;
      S00_AXI_AWREADY             : out   std_logic;
      S00_AXI_AWLEN               : in    std_logic_vector( 7 downto  0); --NBEATS-1 (0=1 beat)
      S00_AXI_AWSIZE              : in    std_logic_vector( 2 downto  0); --NBYTES=2^AWSIZE
      S00_AXI_AWBURST             : in    std_logic_vector( 1 downto  0); --00 fixed, 01 increment, 10 wrap
      -- Write Data
      S00_AXI_WDATA               : in    std_logic_vector(31 downto  0);
      S00_AXI_WLAST               : in    std_logic;
      S00_AXI_WVALID              : in    std_logic;
      S00_AXI_WREADY              : out   std_logic;
      S00_AXI_WSTRB               : in    std_logic_vector( 3 downto  0);
      -- Write response.
      S00_AXI_BRESP               : out   std_logic_vector( 1 downto  0);
      S00_AXI_BVALID              : out   std_logic;
      S00_AXI_BREADY              : in    std_logic;
      -- Read address.
      S00_AXI_ARADDR              : in    std_logic_vector(31 downto  0);
      S00_AXI_ARVALID             : in    std_logic;
      S00_AXI_ARREADY             : out   std_logic;
      S00_AXI_ARLEN               : in    std_logic_vector( 7 downto  0);
      S00_AXI_ARSIZE              : in    std_logic_vector( 2 downto  0);
      S00_AXI_ARBURST             : in    std_logic_vector( 1 downto  0);
      -- Read Data
      S00_AXI_RDATA               : out   std_logic_vector(31 downto  0);
      S00_AXI_RLAST               : out   std_logic;
      S00_AXI_RVALID              : out   std_logic;
      S00_AXI_RREADY              : in    std_logic;
      S00_AXI_RRESP               : out   std_logic_vector( 1 downto  0)
   );
   end component axis_bridge_slave_v1_0;

   component axis_bridge_master_v1_0 is
   generic
   (
      --------------------------------------------------------------------------
      -- Stream
      --------------------------------------------------------------------------
      K_NOD                       : std_logic_vector( 7 downto  0) := X"7C"; -- K28.4
      K_SOF                       : std_logic_vector( 7 downto  0) := X"FB"; -- K27.7
      K_EOF                       : std_logic_vector( 7 downto  0) := X"FD"; -- K29.7
      K_ERR                       : std_logic_vector( 7 downto  0) := X"FE"; -- K30.7
      K_INT                       : std_logic_vector( 7 downto  0) := X"DC"; -- K28.6
      --------------------------------------------------------------------------
      -- AXI Master
      --------------------------------------------------------------------------
      RX_ADDR_MASK                : std_logic_vector(31 downto  0) := X"FFFF_FFFF" --this value is ANDed with the RX address
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
      AXI_ACLK                    : in    std_logic;
      AXI_ARESETN                 : in    std_logic;
      --------------------------------------------------------------------------
      -- MGT Stream Interface
      --------------------------------------------------------------------------
      LEGACY_MODE                 : in    std_logic;
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
      -- AXI Master
      --------------------------------------------------------------------------
      -- Write Address
      M00_AXI_AWADDR              : out   std_logic_vector(31 downto  0);
      M00_AXI_AWVALID             : out   std_logic;
      M00_AXI_AWREADY             : in    std_logic;
      M00_AXI_AWLEN               : out   std_logic_vector( 7 downto  0); -- NBEATS-1 (0=1 beat)
      M00_AXI_AWSIZE              : out   std_logic_vector( 2 downto  0); -- NBYTES=2^AWSIZE
      M00_AXI_AWBURST             : out   std_logic_vector( 1 downto  0); -- 00 fixed, 01 increment, 10 wrap
      -- Write Data
      M00_AXI_WDATA               : out   std_logic_vector(31 downto  0);
      M00_AXI_WSTRB               : out   std_logic_vector( 3 downto  0);
      M00_AXI_WLAST               : out   std_logic;
      M00_AXI_WVALID              : out   std_logic;
      M00_AXI_WREADY              : in    std_logic;
      -- Write response.
      M00_AXI_BRESP               : in    std_logic_vector( 1 downto  0);
      M00_AXI_BVALID              : in    std_logic;
      M00_AXI_BREADY              : out   std_logic;
      -- Read address.
      M00_AXI_ARADDR              : out   std_logic_vector(31 downto  0);
      M00_AXI_ARVALID             : out   std_logic;
      M00_AXI_ARREADY             : in    std_logic;
      M00_AXI_ARLEN               : out   std_logic_vector( 7 downto  0);
      M00_AXI_ARSIZE              : out   std_logic_vector( 2 downto  0);
      M00_AXI_ARBURST             : out   std_logic_vector( 1 downto  0);
      -- Read Data
      M00_AXI_RDATA               : in    std_logic_vector(31 downto  0);
      M00_AXI_RRESP               : in    std_logic_vector( 1 downto  0);
      M00_AXI_RLAST               : in    std_logic;
      M00_AXI_RVALID              : in    std_logic;
      M00_AXI_RREADY              : out   std_logic
   );
   end component axis_bridge_master_v1_0;

begin

   -----------------------------------------------------------------------------
   -- Stimulus master
   -----------------------------------------------------------------------------
   axi_master_inst: cdn_axi4_bfm_master_wrap
   generic map
   (
      C_AXI_NAME                  => "MASTER_test"
   )
   port map
   (
      --------------------------------------------------------------------------
      -- AXI
      --------------------------------------------------------------------------
      -- System
      ACLK                        => ACLK,
      ARESETN                     => ARESETN,
      -- Write address channel
      AWID                        => AXI0_AWID,
      AWADDR                      => AXI0_AWADDR,
      AWVALID                     => AXI0_AWVALID,
      AWREADY                     => AXI0_AWREADY,
      AWLEN                       => AXI0_AWLEN,
      AWSIZE                      => AXI0_AWSIZE,
      AWBURST                     => AXI0_AWBURST,
      AWLOCK                      => AXI0_AWLOCK,
      AWCACHE                     => AXI0_AWCACHE,
      AWPROT                      => AXI0_AWPROT,
      AWREGION                    => AXI0_AWREGION,
      AWQOS                       => AXI0_AWQOS,
      AWUSER                      => AXI0_AWUSER,
      --  Write data channel
      WDATA                       => AXI0_WDATA,
      WLAST                       => AXI0_WLAST,
      WVALID                      => AXI0_WVALID,
      WREADY                      => AXI0_WREADY,
      WSTRB                       => AXI0_WSTRB,
      WUSER                       => AXI0_WUSER,
      -- Write response channel
      BID                         => AXI0_BID,
      BRESP                       => AXI0_BRESP,
      BVALID                      => AXI0_BVALID,
      BREADY                      => AXI0_BREADY,
      BUSER                       => AXI0_BUSER,
      -- Read address channel
      ARID                        => AXI0_ARID,
      ARADDR                      => AXI0_ARADDR,
      ARVALID                     => AXI0_ARVALID,
      ARREADY                     => AXI0_ARREADY,
      ARLEN                       => AXI0_ARLEN,
      ARSIZE                      => AXI0_ARSIZE,
      ARBURST                     => AXI0_ARBURST,
      ARLOCK                      => AXI0_ARLOCK,
      ARCACHE                     => AXI0_ARCACHE,
      ARPROT                      => AXI0_ARPROT,
      ARREGION                    => AXI0_ARREGION,
      ARQOS                       => AXI0_ARQOS,
      ARUSER                      => AXI0_ARUSER,
      -- Read data channel
      RID                         => AXI0_RID,
      RDATA                       => AXI0_RDATA,
      RLAST                       => AXI0_RLAST,
      RVALID                      => AXI0_RVALID,
      RREADY                      => AXI0_RREADY,
      RRESP                       => AXI0_RRESP,
      RUSER                       => AXI0_RUSER,
      --------------------------------------------------------------------------
      -- Test
      --------------------------------------------------------------------------
      -- Write
      S_TST_WRITE_BURST           => S_TST_WRITE_BURST,
      S_TST_WRITE_BURST_DONE      => S_TST_WRITE_BURST_DONE,
      S_TST_AWID                  => S_TST_AWID,
      S_TST_AWADDR                => S_TST_AWADDR,
      S_TST_AWLEN                 => S_TST_AWLEN,
      S_TST_AWBURST               => S_TST_AWBURST,
      S_TST_WDATA                 => S_TST_WDATA,
      S_TST_WDATA_SIZE            => S_TST_WDATA_SIZE,
      -- Read
      S_TST_READ_BURST            => S_TST_READ_BURST,
      S_TST_READ_BURST_DONE       => S_TST_READ_BURST_DONE,
      S_TST_ARID                  => S_TST_ARID,
      S_TST_ARADDR                => S_TST_ARADDR,
      S_TST_ARLEN                 => S_TST_ARLEN,
      S_TST_ARBURST               => S_TST_ARBURST,
      S_TST_RDATA                 => S_TST_RDATA
   );

   -----------------------------------------------------------------------------
   -- DUT bridge
   -----------------------------------------------------------------------------
   axis_bridge_slave_v1_0_inst: axis_bridge_slave_v1_0
   port map
   (
      --------------------------------------------------------------------------
      -- System
      --------------------------------------------------------------------------
      AXI_ACLK                    => ACLK,
      AXI_ARESETN                 => ARESETN,
      --------------------------------------------------------------------------
      -- MGT Stream Interface
      --------------------------------------------------------------------------
      M00_AXIS_TREADY             => M00_AXIS_TREADY,
      M00_AXIS_TVALID             => M00_AXIS_TVALID,
      M00_AXIS_TUSER              => M00_AXIS_TUSER,
      M00_AXIS_TDATA              => M00_AXIS_TDATA,
      --AXI Stream Slave (RX)
      S00_AXIS_TREADY             => S00_AXIS_TREADY,
      S00_AXIS_TVALID             => S00_AXIS_TVALID,
      S00_AXIS_TUSER              => S00_AXIS_TUSER,
      S00_AXIS_TDATA              => S00_AXIS_TDATA,
      --------------------------------------------------------------------------
      -- AXI Slave
      --------------------------------------------------------------------------
      -- Write Address
      S00_AXI_AWADDR              => AXI0_AWADDR,
      S00_AXI_AWVALID             => AXI0_AWVALID,
      S00_AXI_AWREADY             => AXI0_AWREADY,
      S00_AXI_AWLEN               => AXI0_AWLEN,
      S00_AXI_AWSIZE              => AXI0_AWSIZE,
      S00_AXI_AWBURST             => AXI0_AWBURST,
      -- Write Data
      S00_AXI_WDATA               => AXI0_WDATA,
      S00_AXI_WSTRB               => AXI0_WSTRB,
      S00_AXI_WLAST               => AXI0_WLAST,
      S00_AXI_WVALID              => AXI0_WVALID,
      S00_AXI_WREADY              => AXI0_WREADY,
      -- Write response.
      S00_AXI_BRESP               => AXI0_BRESP,
      S00_AXI_BVALID              => AXI0_BVALID,
      S00_AXI_BREADY              => AXI0_BREADY,
      -- Read address.
      S00_AXI_ARADDR              => AXI0_ARADDR,
      S00_AXI_ARVALID             => AXI0_ARVALID,
      S00_AXI_ARREADY             => AXI0_ARREADY,
      S00_AXI_ARLEN               => AXI0_ARLEN,
      S00_AXI_ARSIZE              => AXI0_ARSIZE,
      S00_AXI_ARBURST             => AXI0_ARBURST,
      -- Read Data
      S00_AXI_RDATA               => AXI0_RDATA,
      S00_AXI_RLAST               => AXI0_RLAST,
      S00_AXI_RVALID              => AXI0_RVALID,
      S00_AXI_RREADY              => AXI0_RREADY,
      S00_AXI_RRESP               => AXI0_RRESP
   );

   axis_bridge_master_v1_0_inst: axis_bridge_master_v1_0
   port map
   (
      --------------------------------------------------------------------------
      -- System
      --------------------------------------------------------------------------
      AXI_ACLK                    => ACLK,
      AXI_ARESETN                 => ARESETN,
      --------------------------------------------------------------------------
      -- MGT Stream Interface
      --------------------------------------------------------------------------
      LEGACY_MODE                 => LEGACY_MODE,
      --AXI Stream Master (TX)
      M00_AXIS_TREADY             => S00_AXIS_TREADY,
      M00_AXIS_TVALID             => S00_AXIS_TVALID,
      M00_AXIS_TUSER              => S00_AXIS_TUSER,
      M00_AXIS_TDATA              => S00_AXIS_TDATA,
      --AXI Stream Slave (RX)
      S00_AXIS_TREADY             => M00_AXIS_TREADY,
      S00_AXIS_TVALID             => M00_AXIS_TVALID,
      S00_AXIS_TUSER              => M00_AXIS_TUSER,
      S00_AXIS_TDATA              => M00_AXIS_TDATA,
      --------------------------------------------------------------------------
      -- AXI Master
      --------------------------------------------------------------------------
      -- Write Address
      M00_AXI_AWADDR              => AXI1_AWADDR,
      M00_AXI_AWVALID             => AXI1_AWVALID,
      M00_AXI_AWREADY             => AXI1_AWREADY,
      M00_AXI_AWLEN               => AXI1_AWLEN,
      M00_AXI_AWSIZE              => AXI1_AWSIZE,
      M00_AXI_AWBURST             => AXI1_AWBURST,
      -- Write Data
      M00_AXI_WDATA               => AXI1_WDATA,
      M00_AXI_WSTRB               => AXI1_WSTRB,
      M00_AXI_WLAST               => AXI1_WLAST,
      M00_AXI_WVALID              => AXI1_WVALID,
      M00_AXI_WREADY              => AXI1_WREADY,
      -- Write response.
      M00_AXI_BRESP               => AXI1_BRESP,
      M00_AXI_BVALID              => AXI1_BVALID,
      M00_AXI_BREADY              => AXI1_BREADY,
      -- Read address.
      M00_AXI_ARADDR              => AXI1_ARADDR,
      M00_AXI_ARVALID             => AXI1_ARVALID,
      M00_AXI_ARREADY             => AXI1_ARREADY,
      M00_AXI_ARLEN               => AXI1_ARLEN,
      M00_AXI_ARSIZE              => AXI1_ARSIZE,
      M00_AXI_ARBURST             => AXI1_ARBURST,
      -- Read Data
      M00_AXI_RDATA               => AXI1_RDATA,
      M00_AXI_RRESP               => AXI1_RRESP,
      M00_AXI_RLAST               => AXI1_RLAST,
      M00_AXI_RVALID              => AXI1_RVALID,
      M00_AXI_RREADY              => AXI1_RREADY
   );

   axi_slave_inst: cdn_axi4_bfm_slave_wrap
   generic map
   (
      C_AXI_NAME                  => "SLAVE_test",

      C_AXI_MEMORY_MODEL_MODE     => 1,
      C_AXI_SLAVE_ADDRESS         => 0,
      C_AXI_SLAVE_MEM_SIZE        => 4096
   )
   port map
   (
      --------------------------------------------------------------------------
      -- AXI
      --------------------------------------------------------------------------
      -- System
      ACLK                        => ACLK,
      ARESETN                     => ARESETN,
      -- Write address channel
      AWID                        => AXI1_AWID,
      AWADDR                      => AXI1_AWADDR,
      AWVALID                     => AXI1_AWVALID,
      AWREADY                     => AXI1_AWREADY,
      AWLEN                       => AXI1_AWLEN,
      AWSIZE                      => AXI1_AWSIZE,
      AWBURST                     => AXI1_AWBURST,
      AWLOCK                      => AXI1_AWLOCK,
      AWCACHE                     => AXI1_AWCACHE,
      AWPROT                      => AXI1_AWPROT,
      AWREGION                    => AXI1_AWREGION,
      AWQOS                       => AXI1_AWQOS,
      AWUSER                      => AXI1_AWUSER,
      --  Write data channel
      WDATA                       => AXI1_WDATA,
      WLAST                       => AXI1_WLAST,
      WVALID                      => AXI1_WVALID,
      WREADY                      => AXI1_WREADY,
      WSTRB                       => AXI1_WSTRB,
      WUSER                       => AXI1_WUSER,
      -- Write response channel
      BID                         => AXI1_BID,
      BRESP                       => AXI1_BRESP,
      BVALID                      => AXI1_BVALID,
      BREADY                      => AXI1_BREADY,
      BUSER                       => AXI1_BUSER,
      -- Read address channel
      ARID                        => AXI1_ARID,
      ARADDR                      => AXI1_ARADDR,
      ARVALID                     => AXI1_ARVALID,
      ARREADY                     => AXI1_ARREADY,
      ARLEN                       => AXI1_ARLEN,
      ARSIZE                      => AXI1_ARSIZE,
      ARBURST                     => AXI1_ARBURST,
      ARLOCK                      => AXI1_ARLOCK,
      ARCACHE                     => AXI1_ARCACHE,
      ARPROT                      => AXI1_ARPROT,
      ARREGION                    => AXI1_ARREGION,
      ARQOS                       => AXI1_ARQOS,
      ARUSER                      => AXI1_ARUSER,
      -- Read data channel
      RID                         => AXI1_RID,
      RDATA                       => AXI1_RDATA,
      RLAST                       => AXI1_RLAST,
      RVALID                      => AXI1_RVALID,
      RREADY                      => AXI1_RREADY,
      RRESP                       => AXI1_RRESP,
      RUSER                       => AXI1_RUSER
   );


   -----------------------------------------------------------------------------
   -- AXI clock
   -----------------------------------------------------------------------------
   process
   begin
      loop
         ACLK                     <= '0';
         wait for C_AXI_ACLK_CYCLE / 2;
         ACLK                     <= '1';
         wait for C_AXI_ACLK_CYCLE / 2;
      end loop;
   end process;

   -----------------------------------------------------------------------------
   -- AXI reset
   -----------------------------------------------------------------------------
   process
   begin
      ARESETN                     <= '0';
      wait for 50 ns;
      wait until (rising_edge(ACLK));
      ARESETN                     <= '1';
      wait ;
   end process;

   -----------------------------------------------------------------------------
   -- Stimulus slave AXI stream interface
   -----------------------------------------------------------------------------
   process
   begin
      --------------------------------------------------------------------------
      -- Get out of reset
      --------------------------------------------------------------------------
      wait until (ARESETN = '1');
      wait for 50 ns;
      --------------------------------------------------------------------------
      -- Test Write
      --------------------------------------------------------------------------
      wait until (ACLK = '1');
      -- Write
      S_TST_WRITE_BURST           <= '1';
      S_TST_AWADDR                <= X"0000_0010";
      S_TST_AWLEN(7 downto 0)     <= X"01";
      S_TST_AWBURST               <= "01";
      S_TST_WDATA                 <= (others => '0');
      S_TST_WDATA(511 downto 0)   <= X"00000000111111112222222233333333444444445555555566666666777777778888888899999999AAAAAAAABBBBBBBBCCCCCCCCDDDDDDDDEEEEEEEEFFFFFFFF";
      S_TST_WDATA_SIZE            <= "00000001000";
      wait until (S_TST_WRITE_BURST_DONE = '1');
      S_TST_WRITE_BURST           <= '0';
      --------------------------------------------------------------------------
      -- Test Read
      --------------------------------------------------------------------------
      wait for 50 ns;
      wait until (ACLK = '1');
      S_TST_READ_BURST            <= '1';
      S_TST_ARADDR                <= X"0000_0010";
      S_TST_ARLEN(7 downto 0)     <= X"01";
      S_TST_ARBURST               <= "01";
      wait until (S_TST_READ_BURST_DONE = '1');
      S_TST_READ_BURST            <= '0';
      --------------------------------------------------------------------------
      -- Simulation done
      --------------------------------------------------------------------------
      wait;
   end process;

end architecture testbench;

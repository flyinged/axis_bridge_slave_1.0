-- (c) Copyright 2011 - 2012 Xilinx, Inc. All rights reserved.
--
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
--
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
--
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
--
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

package cdn_axi4_package is

   -----------------------------------------------------------------------------
   -- Constants AXI bus
   -----------------------------------------------------------------------------
   constant C_AXI_DATA_BUS_WIDTH       : integer := 32;
   constant C_AXI_ADDRESS_BUS_WIDTH    : integer := 32;
   constant C_AXI_ID_BUS_WIDTH         : integer := 4;

   constant C_AXI_AWUSER_BUS_WIDTH     : integer := 1;
   constant C_AXI_WUSER_BUS_WIDTH      : integer := 1;
   constant C_AXI_BUSER_BUS_WIDTH      : integer := 1;

   constant C_AXI_ARUSER_BUS_WIDTH     : integer := 1;
   constant C_AXI_RUSER_BUS_WIDTH      : integer := 1;

   constant C_AXI_MAX_BURST_LENGTH     : integer := 255;
   constant C_AXI_RESP_BUS_WIDTH       : integer := 2;
   -----------------------------------------------------------------------------
   -- Signals AXI bus
   -----------------------------------------------------------------------------
   -- System
   signal   ACLK                  : std_logic := '0';
   signal   ARESETN               : std_logic := '0';
   -- Write address channel
   signal   AWID                  : std_logic_vector(C_AXI_ID_BUS_WIDTH-1 downto 0) := (others => '0');
   signal   AWADDR                : std_logic_vector(C_AXI_ADDRESS_BUS_WIDTH-1 downto 0) := (others => '0');
   signal   AWVALID               : std_logic := '0';
   signal   AWREADY               : std_logic := '0';
   signal   AWLEN                 : std_logic_vector(7 downto 0) := (others => '0');
   signal   AWSIZE                : std_logic_vector(2 downto 0) := (others => '0');
   signal   AWBURST               : std_logic_vector(1 downto 0) := (others => '0');
   signal   AWLOCK                : std_logic := '0';
   signal   AWCACHE               : std_logic_vector(3 downto 0) := (others => '0');
   signal   AWPROT                : std_logic_vector(2 downto 0) := (others => '0');
   signal   AWREGION              : std_logic_vector(3 downto 0) := (others => '0');
   signal   AWQOS                 : std_logic_vector(3 downto 0) := (others => '0');
   signal   AWUSER                : std_logic_vector(C_AXI_AWUSER_BUS_WIDTH-1 downto 0) := (others => '0');
   --  Write data channel
   signal   WDATA                 : std_logic_vector(C_AXI_DATA_BUS_WIDTH-1 downto 0) := (others => '0');
   signal   WLAST                 : std_logic := '0';
   signal   WVALID                : std_logic := '0';
   signal   WREADY                : std_logic := '0';
   signal   WSTRB                 : std_logic_vector(3 downto 0);
   signal   WUSER                 : std_logic_vector(C_AXI_WUSER_BUS_WIDTH-1 downto 0) := (others => '0');
   -- Write response channel
   signal   BID                   : std_logic_vector(C_AXI_ID_BUS_WIDTH-1 downto 0) := (others => '0');
   signal   BRESP                 : std_logic_vector(1 downto 0) := (others => '0');
   signal   BVALID                : std_logic := '0';
   signal   BREADY                : std_logic := '0';
   signal   BUSER                 : std_logic_vector(C_AXI_BUSER_BUS_WIDTH-1 downto 0) := (others => '0');
   -- Read address channel
   signal   ARID                  : std_logic_vector(C_AXI_ID_BUS_WIDTH-1 downto 0) := (others => '0');
   signal   ARADDR                : std_logic_vector(C_AXI_ADDRESS_BUS_WIDTH-1 downto 0) := (others => '0');
   signal   ARVALID               : std_logic := '0';
   signal   ARREADY               : std_logic := '0';
   signal   ARLEN                 : std_logic_vector(7 downto 0) := (others => '0');
   signal   ARSIZE                : std_logic_vector(2 downto 0) := (others => '0');
   signal   ARBURST               : std_logic_vector(1 downto 0) := (others => '0');
   signal   ARLOCK                : std_logic := '0';
   signal   ARCACHE               : std_logic_vector(3 downto 0) := (others => '0');
   signal   ARPROT                : std_logic_vector(2 downto 0) := (others => '0');
   signal   ARREGION              : std_logic_vector(3 downto 0) := (others => '0');
   signal   ARQOS                 : std_logic_vector(3 downto 0) := (others => '0');
   signal   ARUSER                : std_logic_vector(C_AXI_ARUSER_BUS_WIDTH-1 downto 0) := (others => '0');
   -- Read data channel
   signal   RID                   : std_logic_vector(C_AXI_ID_BUS_WIDTH-1 downto 0) := (others => '0');
   signal   RDATA                 : std_logic_vector(C_AXI_DATA_BUS_WIDTH-1 downto 0) := (others=>'0');
   signal   RLAST                 : std_logic := '0';
   signal   RVALID                : std_logic := '0';
   signal   RREADY                : std_logic := '0';
   signal   RRESP                 : std_logic_vector(1 downto 0);
   signal   RUSER                 : std_logic_vector(C_AXI_RUSER_BUS_WIDTH-1 downto 0) := (others => '0');
   -----------------------------------------------------------------------------
   -- Signals test
   -----------------------------------------------------------------------------
   -- Write
   signal   S_TST_WRITE_BURST     : std_logic := '0';
   signal   S_TST_WRITE_BURST_DONE: std_logic := '0';
   signal   S_TST_AWID            : std_logic_vector( 3 downto  0) := (others => '0');
   signal   S_TST_AWADDR          : std_logic_vector(C_AXI_ADDRESS_BUS_WIDTH-1 downto  0) := (others => '0');
   signal   S_TST_AWLEN           : std_logic_vector(((C_AXI_DATA_BUS_WIDTH/8)*(C_AXI_MAX_BURST_LENGTH+1))-1 downto  0) := (others => '0');
   signal   S_TST_AWBURST         : std_logic_vector( 1 downto  0) := (others => '0');
   signal   S_TST_WDATA           : std_logic_vector((C_AXI_DATA_BUS_WIDTH*(C_AXI_MAX_BURST_LENGTH+1))-1 downto  0) := (others => '0');
   signal   S_TST_WDATA_SIZE      : std_logic_vector(10 downto  0) := (others => '0');
   signal   S_TST_BRESP           : std_logic_vector( 1 downto  0) := (others => '0');
   -- Read
   signal   S_TST_READ_BURST      : std_logic := '0';
   signal   S_TST_READ_BURST_DONE : std_logic := '0';
   signal   S_TST_ARID            : std_logic_vector( 3 downto  0) := (others => '0');
   signal   S_TST_ARADDR          : std_logic_vector(C_AXI_ADDRESS_BUS_WIDTH-1 downto  0) := (others => '0');
   signal   S_TST_ARLEN           : std_logic_vector(((C_AXI_DATA_BUS_WIDTH/8)*(C_AXI_MAX_BURST_LENGTH+1))-1 downto  0) := (others => '0');
   signal   S_TST_ARBURST         : std_logic_vector( 1 downto  0) := (others => '0');
   signal   S_TST_RDATA           : std_logic_vector((C_AXI_DATA_BUS_WIDTH*(C_AXI_MAX_BURST_LENGTH+1))-1 downto  0) := (others => '0');
   signal   S_TST_RRESP           : std_logic_vector((C_AXI_RESP_BUS_WIDTH*(C_AXI_MAX_BURST_LENGTH+1))-1 downto  0) := (others => '0');

   -----------------------------------------------------------------------------
   -- Components
   -----------------------------------------------------------------------------
   component cdn_axi4_bfm_master_wrap is
   generic
   (
      C_AXI_NAME                  : string  := "MASTER_0";

      C_AXI_DATA_BUS_WIDTH        : integer := C_AXI_DATA_BUS_WIDTH;
      C_AXI_ADDRESS_BUS_WIDTH     : integer := C_AXI_ADDRESS_BUS_WIDTH;
      C_AXI_ID_BUS_WIDTH          : integer := C_AXI_ID_BUS_WIDTH;

      C_AXI_AWUSER_BUS_WIDTH      : integer := C_AXI_AWUSER_BUS_WIDTH;
      C_AXI_WUSER_BUS_WIDTH       : integer := C_AXI_WUSER_BUS_WIDTH;
      C_AXI_BUSER_BUS_WIDTH       : integer := C_AXI_BUSER_BUS_WIDTH;

      C_AXI_ARUSER_BUS_WIDTH      : integer := C_AXI_ARUSER_BUS_WIDTH;
      C_AXI_RUSER_BUS_WIDTH       : integer := C_AXI_RUSER_BUS_WIDTH
   );
   port
   (
      --------------------------------------------------------------------------
      -- AXI
      --------------------------------------------------------------------------
      -- System
      ACLK                        : in    std_logic;
      ARESETN                     : in    std_logic;
      -- Write address channel
      AWID                        : out   std_logic_vector(C_AXI_ID_BUS_WIDTH-1 downto 0);  -- Master Write address ID.
      AWADDR                      : out   std_logic_vector(C_AXI_ADDRESS_BUS_WIDTH-1 downto 0);  -- Master Write address.
      AWVALID                     : out   std_logic; -- Master Write address valid.
      AWREADY                     : in    std_logic; -- Slave Write address ready.
      AWLEN                       : out   std_logic_vector(7 downto 0);  -- Master Burst length.
      AWSIZE                      : out   std_logic_vector(2 downto 0);  -- Master Burst size.
      AWBURST                     : out   std_logic_vector(1 downto 0); -- Master Burst type.
      AWLOCK                      : out   std_logic;  -- Master Lock type.
      AWCACHE                     : out   std_logic_vector(3 downto 0); -- Master Cache type.
      AWPROT                      : out   std_logic_vector(2 downto 0);  -- Master Protection type.
      AWREGION                    : out   std_logic_vector(3 downto 0);-- Master Region signals.
      AWQOS                       : out   std_logic_vector(3 downto 0);   -- Master QoS signals.
      AWUSER                      : out   std_logic_vector(C_AXI_AWUSER_BUS_WIDTH-1 downto 0);  -- Master User defined signals.
      -- Write data channel
      WDATA                       : out   std_logic_vector(C_AXI_DATA_BUS_WIDTH-1 downto 0);   -- Master Write data.
      WLAST                       : out   std_logic;   -- Master Write last.
      WVALID                      : out   std_logic;  -- Master Write valid.
      WREADY                      : in    std_logic;  -- Slave Write ready.
      WSTRB                       : out   std_logic_vector(3 downto 0);   -- Master Write strobes.
      WUSER                       : out   std_logic_vector(C_AXI_WUSER_BUS_WIDTH-1 downto 0);   -- Master Write User defined signals.
      -- Write response channel
      BID                         : in    std_logic_vector(C_AXI_ID_BUS_WIDTH-1 downto 0);     -- Slave Response ID.
      BRESP                       : in    std_logic_vector(1 downto 0);   -- Slave Write response.
      BVALID                      : in    std_logic;  -- Slave Write response valid.
      BREADY                      : out   std_logic;  -- Master Response ready.
      BUSER                       : in    std_logic_vector(C_AXI_BUSER_BUS_WIDTH-1 downto 0);   -- Slave Write user defined signals.
      -- Read address channel
      ARID                        : out   std_logic_vector(C_AXI_ID_BUS_WIDTH-1 downto 0);    -- Master Read address ID.
      ARADDR                      : out   std_logic_vector(C_AXI_ADDRESS_BUS_WIDTH-1 downto 0);  -- Master Read address.
      ARVALID                     : out   std_logic; -- Master Read address valid.
      ARREADY                     : in    std_logic; -- Slave Read address ready.
      ARLEN                       : out   std_logic_vector(7 downto 0);   -- Master Burst length.
      ARSIZE                      : out   std_logic_vector(2 downto 0);  -- Master Burst size.
      ARBURST                     : out   std_logic_vector(1 downto 0); -- Master Burst type.
      ARLOCK                      : out   std_logic;  -- Master Lock typ
      ARCACHE                     : out   std_logic_vector(3 downto 0); -- Master Cache type.
      ARPROT                      : out   std_logic_vector(2 downto 0);  -- Master Protection type.
      ARREGION                    : out   std_logic_vector(3 downto 0);-- Master Region signals.
      ARQOS                       : out   std_logic_vector(3 downto 0);   -- Master QoS signals.
      ARUSER                      : out   std_logic_vector(C_AXI_ARUSER_BUS_WIDTH-1 downto 0);  -- Master User defined signals.
      -- Read data channel
      RID                         : in    std_logic_vector(C_AXI_ID_BUS_WIDTH-1 downto 0);     -- Slave Read ID tag.
      RDATA                       : in    std_logic_vector(C_AXI_DATA_BUS_WIDTH-1 downto 0);   -- Slave Read data.
      RLAST                       : in    std_logic;   -- Slave Read last.
      RVALID                      : in    std_logic;   -- Slave Read valid.
      RREADY                      : out   std_logic;   -- Master Read ready.
      RRESP                       : in    std_logic_vector(1 downto 0);   -- Slave Read response.
      RUSER                       : in    std_logic_vector(C_AXI_RUSER_BUS_WIDTH-1 downto 0);   -- Slave Read user defined signals.
      --------------------------------------------------------------------------
      -- Test
      --------------------------------------------------------------------------
      -- Write
      S_TST_WRITE_BURST           : in    std_logic := '0';
      S_TST_WRITE_BURST_DONE      : out   std_logic := '0';
      S_TST_AWID                  : in    std_logic_vector( 3 downto  0) := (others => '0');
      S_TST_AWADDR                : in    std_logic_vector(C_AXI_ADDRESS_BUS_WIDTH-1 downto  0) := (others => '0');
      S_TST_AWLEN                 : in    std_logic_vector(((C_AXI_DATA_BUS_WIDTH/8)*(C_AXI_MAX_BURST_LENGTH+1))-1 downto  0) := (others => '0');
      S_TST_AWBURST               : in    std_logic_vector( 1 downto  0) := (others => '0');
      S_TST_AWLOCK                : in    std_logic := '0';
      S_TST_AWCACHE               : in    std_logic := '0';
      S_TST_AWPROT                : in    std_logic := '0';
      S_TST_AWREGION              : in    std_logic := '0';
      S_TST_AWQOS                 : in    std_logic := '0';
      S_TST_AWUSER                : in    std_logic := '0';
      S_TST_WDATA                 : in    std_logic_vector((C_AXI_DATA_BUS_WIDTH*(C_AXI_MAX_BURST_LENGTH+1))-1 downto  0) := (others => '0');
      S_TST_WDATA_SIZE            : in    std_logic_vector(10 downto  0) := (others => '0');
      S_TST_WUSER                 : in    std_logic_vector((C_AXI_RUSER_BUS_WIDTH*(C_AXI_MAX_BURST_LENGTH+1))-1 downto  0) := (others => '0');
      S_TST_BRESP                 : out   std_logic_vector( 1 downto  0) := (others => '0');
      S_TST_BUSER                 : out   std_logic := '0';
      -- Read
      S_TST_READ_BURST            : in    std_logic := '0';
      S_TST_READ_BURST_DONE       : out   std_logic := '0';
      S_TST_ARID                  : in    std_logic_vector( 3 downto  0) := (others => '0');
      S_TST_ARADDR                : in    std_logic_vector(C_AXI_ADDRESS_BUS_WIDTH-1 downto  0) := (others => '0');
      S_TST_ARLEN                 : in    std_logic_vector(((C_AXI_DATA_BUS_WIDTH/8)*(C_AXI_MAX_BURST_LENGTH+1))-1 downto  0) := (others => '0');
      S_TST_ARBURST               : in    std_logic_vector( 1 downto  0) := (others => '0');
      S_TST_ARLOCK                : in    std_logic := '0';
      S_TST_ARCACHE               : in    std_logic := '0';
      S_TST_ARPROT                : in    std_logic := '0';
      S_TST_ARREGION              : in    std_logic := '0';
      S_TST_ARQOS                 : in    std_logic := '0';
      S_TST_ARUSER                : in    std_logic := '0';
      S_TST_RDATA                 : out   std_logic_vector((C_AXI_DATA_BUS_WIDTH*(C_AXI_MAX_BURST_LENGTH+1))-1 downto  0) := (others => '0');
      S_TST_RRESP                 : out   std_logic_vector((C_AXI_RESP_BUS_WIDTH*(C_AXI_MAX_BURST_LENGTH+1))-1 downto  0) := (others => '0');
      S_TST_RUSER                 : out   std_logic_vector((C_AXI_RUSER_BUS_WIDTH*(C_AXI_MAX_BURST_LENGTH+1))-1 downto  0) := (others => '0')
   );
   end component;

   component cdn_axi4_bfm_slave_wrap is
   generic
   (
      C_AXI_NAME                  : string := "SLAVE_0";

      C_AXI_MEMORY_MODEL_MODE     : integer := 0;
      C_AXI_SLAVE_ADDRESS         : integer := 0;
      C_AXI_SLAVE_MEM_SIZE        : integer := 4096;

      C_AXI_DATA_BUS_WIDTH        : integer := C_AXI_DATA_BUS_WIDTH;
      C_AXI_ADDRESS_BUS_WIDTH     : integer := C_AXI_ADDRESS_BUS_WIDTH;
      C_AXI_ID_BUS_WIDTH          : integer := C_AXI_ID_BUS_WIDTH;

      C_AXI_AWUSER_BUS_WIDTH      : integer := C_AXI_AWUSER_BUS_WIDTH;
      C_AXI_WUSER_BUS_WIDTH       : integer := C_AXI_WUSER_BUS_WIDTH;
      C_AXI_BUSER_BUS_WIDTH       : integer := C_AXI_BUSER_BUS_WIDTH;

      C_AXI_ARUSER_BUS_WIDTH      : integer := C_AXI_ARUSER_BUS_WIDTH;
      C_AXI_RUSER_BUS_WIDTH       : integer := C_AXI_RUSER_BUS_WIDTH
   );
   port
   (
      --------------------------------------------------------------------------
      -- AXI
      --------------------------------------------------------------------------
      -- System
      ACLK                        : in    std_logic;
      ARESETN                     : in    std_logic;
      -- Write address channel
      AWID                        : in    std_logic_vector(C_AXI_ID_BUS_WIDTH-1 downto 0);-- Master Write address ID.
      AWADDR                      : in    std_logic_vector(C_AXI_ADDRESS_BUS_WIDTH-1 downto 0);-- Master Write address.
      AWVALID                     : in    std_logic;-- Master Write address valid.
      AWREADY                     : out   std_logic;-- Slave Write address ready.
      AWLEN                       : in    std_logic_vector(7 downto 0);-- Master Burst length.
      AWSIZE                      : in    std_logic_vector(2 downto 0);-- Master Burst size.
      AWBURST                     : in    std_logic_vector(1 downto 0);-- Master Burst type.
      AWLOCK                      : in    std_logic;-- Master Lock type.
      AWCACHE                     : in    std_logic_vector(3 downto 0);-- Master Cache type.
      AWPROT                      : in    std_logic_vector(2 downto 0);-- Master Protection type.
      AWREGION                    : in    std_logic_vector(3 downto 0);-- Master Region signals.
      AWQOS                       : in    std_logic_vector(3 downto 0);-- Master QoS signals.
      AWUSER                      : in    std_logic_vector(C_AXI_AWUSER_BUS_WIDTH-1 downto 0);-- Master User defined signals.
      -- Write data channel
      WDATA                       : in    std_logic_vector(C_AXI_DATA_BUS_WIDTH-1 downto 0);-- Master Write data.
      WLAST                       : in    std_logic;-- Master Write last.
      WVALID                      : in    std_logic;-- Master Write valid.
      WREADY                      : out   std_logic;-- Slave Write ready.
      WSTRB                       : in    std_logic_vector(3 downto 0);-- Master Write strobes.
      WUSER                       : in    std_logic_vector(C_AXI_WUSER_BUS_WIDTH-1 downto 0);-- Master Write User defined signals.
      -- Write response channel
      BID                         : out   std_logic_vector (C_AXI_ID_BUS_WIDTH-1 downto 0);-- Slave Response ID.
      BRESP                       : out   std_logic_vector (1 downto 0);-- Slave Write response.
      BVALID                      : out   std_logic;-- Slave Write response valid.
      BREADY                      : in    std_logic;-- Master Response ready.
      BUSER                       : out   std_logic_vector (C_AXI_BUSER_BUS_WIDTH-1 downto 0);-- Slave Write user defined signals.
      -- Read address channel
      ARID                        : in    std_logic_vector(C_AXI_ID_BUS_WIDTH-1 downto 0);-- Master Read address ID.
      ARADDR                      : in    std_logic_vector(C_AXI_ADDRESS_BUS_WIDTH-1 downto 0);-- Master Read address.
      ARVALID                     : in    std_logic;-- Master Read address valid.
      ARREADY                     : out   std_logic;-- Slave Read address ready.
      ARLEN                       : in    std_logic_vector(7 downto 0);-- Master Burst length.
      ARSIZE                      : in    std_logic_vector(2 downto 0);-- Master Burst size.
      ARBURST                     : in    std_logic_vector(1 downto 0);-- Master Burst type.
      ARLOCK                      : in    std_logic;-- Master Lock type.
      ARCACHE                     : in    std_logic_vector(3 downto 0);-- Master Cache type.
      ARPROT                      : in    std_logic_vector(2 downto 0);-- Master Protection type.
      ARREGION                    : in    std_logic_vector(3 downto 0);-- Master Region signals.
      ARQOS                       : in    std_logic_vector(3 downto 0);-- Master QoS signals.
      ARUSER                      : in    std_logic_vector(C_AXI_ARUSER_BUS_WIDTH-1 downto 0);-- Master User defined signals.
      -- Read data channel
      RID                         : out   std_logic_vector (C_AXI_ID_BUS_WIDTH-1 downto 0);-- Slave Read ID tag.
      RDATA                       : out   std_logic_vector (C_AXI_DATA_BUS_WIDTH-1 downto 0);-- Slave Read data.
      RLAST                       : out   std_logic;-- Slave Read last.
      RVALID                      : out   std_logic;-- Slave Read valid.
      RRESP                       : out   std_logic_vector (1 downto 0);-- Slave Read response.
      RREADY                      : in    std_logic;-- Master Read ready.
      RUSER                       : out   std_logic_vector (C_AXI_RUSER_BUS_WIDTH-1 downto 0);-- Slave Read user defined signals.
      --------------------------------------------------------------------------
      -- Test
      --------------------------------------------------------------------------
      -- CDC task WRITE_BURST_RESPOND
      S_TST_WRITE_BURST           : in    std_logic := '0';
      S_TST_WRITE_BURST_DONE      : out   std_logic := '0';
      S_TST_AWID                  : in    std_logic_vector(3 downto 0) := (others => '0');
      S_TST_WDATA                 : out   std_logic_vector((C_AXI_DATA_BUS_WIDTH * (C_AXI_MAX_BURST_LENGTH+1)) - 1 downto  0) := (others => '0');
      S_TST_WDATA_SIZE            : out   std_logic := '0';
      S_TST_WUSER                 : out   std_logic_vector((C_AXI_WUSER_BUS_WIDTH * (C_AXI_MAX_BURST_LENGTH+1)) - 1 downto  0) := (others => '0');
      S_TST_BUSER                 : in    std_logic := '0';
      -- CDC task READ_BURST_RESPOND
      S_TST_READ_BURST            : in    std_logic := '0';
      S_TST_READ_BURST_DONE       : out   std_logic := '0';
      S_TST_ARID                  : in    std_logic_vector(3 downto 0) := (others => '0');
      S_TST_RDATA                 : in    std_logic_vector((C_AXI_DATA_BUS_WIDTH * (C_AXI_MAX_BURST_LENGTH+1)) - 1 downto  0) := (others => '0');
      S_TST_RUSER                 : in    std_logic_vector((C_AXI_RUSER_BUS_WIDTH * (C_AXI_MAX_BURST_LENGTH+1)) - 1 downto  0) := (others => '0')
   );
   end component;

end;

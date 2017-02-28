// (c) Copyright 2011 - 2012 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.

//
// File name: cdn_axi4_bfm_master_wrap.v
//
// Description: Verilog wrapper for Cadence's "cdn_axi4_master_bfm" module.
//
//
//-----------------------------------------------------------------------------
`timescale 1ps/1ps
// Burst Type Defines
`define BURST_TYPE_FIXED          2'b00
`define BURST_TYPE_INCR           2'b01
`define BURST_TYPE_WRAP           2'b10

// Burst Size Defines
`define BURST_SIZE_1_BYTE         3'b000
`define BURST_SIZE_2_BYTES        3'b001
`define BURST_SIZE_4_BYTES        3'b010
`define BURST_SIZE_8_BYTES        3'b011
`define BURST_SIZE_16_BYTES       3'b100
`define BURST_SIZE_32_BYTES       3'b101
`define BURST_SIZE_64_BYTES       3'b110
`define BURST_SIZE_128_BYTES      3'b111

// Lock Type Defines
`define LOCK_TYPE_NORMAL          1'b0
`define LOCK_TYPE_EXCLUSIVE       1'b1

// S_TST_BRESP Type Defines
`define RESPONSE_OKAY             2'b00
`define RESPONSE_EXOKAY           2'b01
`define RESPONSE_SLVERR           2'b10
`define RESPONSE_DECERR           2'b11

// AMBA AXI 4 Bus Size Constants
`define LENGTH_BUS_WIDTH          8
`define SIZE_BUS_WIDTH            3
`define BURST_BUS_WIDTH           2
`define LOCK_BUS_WIDTH            1
`define CACHE_BUS_WIDTH           4
`define PROT_BUS_WIDTH            3
`define RESP_BUS_WIDTH            2
`define QOS_BUS_WIDTH             4
`define REGION_BUS_WIDTH          4

// AMBA AXI 4 Range Constants
`define MAX_BURST_LENGTH          8'b1111_1111
`define MAX_DATA_SIZE             (DATA_BUS_WIDTH*(`MAX_BURST_LENGTH+1))/8

// Required for test of WRAP and FIXED max bursts lengths
`define AXI3_MAX_BURST_LENGTH     8'b0000_1111

// Message defines
`define MSG_WARNING               WARNING
`define MSG_INFO                  INFO
`define MSG_ERROR                 ERROR

// Define for intenal control value
`define ANY_ID_NEXT               100
`define IDVALID_TRUE              1'b1
`define IDVALID_FALSE             1'b0

//-----------------------------------------------------------------------------
// The AXI 4 Master BFM Top Level Wrapper
//-----------------------------------------------------------------------------
module cdn_axi4_bfm_master_wrap
(
   //---------------------------------------------------------------------------
   // AXI
   //---------------------------------------------------------------------------
   // System
   ACLK,
   ARESETN,
   // Write address channel
   AWID,
   AWADDR,
   AWVALID,
   AWREADY,
   AWLEN,
   AWSIZE,
   AWBURST,
   AWLOCK,
   AWCACHE,
   AWPROT,
   AWREGION,
   AWQOS,
   AWUSER,
   // Write data channel
   WDATA,
   WLAST,
   WSTRB,
   WVALID,
   WREADY,
   WUSER,
   // Write S_TST_BRESP channel
   BID,
   BRESP,
   BVALID,
   BREADY,
   BUSER,
   // Read address channel
   ARID,
   ARADDR,
   ARVALID,
   ARREADY,
   ARLEN,
   ARSIZE,
   ARBURST,
   ARLOCK,
   ARCACHE,
   ARPROT,
   ARREGION,
   ARQOS,
   ARUSER,
   // Read data channel
   RID,
   RDATA,
   RLAST,
   RVALID,
   RREADY,
   RRESP,
   RUSER,
   //---------------------------------------------------------------------------
   // Test
   //---------------------------------------------------------------------------
   // Write
   S_TST_WRITE_BURST,
   S_TST_WRITE_BURST_DONE,
   S_TST_AWID, 
   S_TST_AWADDR,
   S_TST_AWLEN,
   S_TST_AWBURST,
   S_TST_AWLOCK,
   S_TST_AWCACHE, 
   S_TST_AWPROT, 
   S_TST_AWREGION, 
   S_TST_AWQOS,
   S_TST_AWUSER, 
   S_TST_WDATA,
   S_TST_WDATA_SIZE,
   S_TST_WUSER,
   S_TST_BRESP, 
   S_TST_BUSER,
   // Read
   S_TST_READ_BURST,
   S_TST_READ_BURST_DONE,
   S_TST_ARID,
   S_TST_ARADDR,
   S_TST_ARLEN,
   S_TST_ARBURST,
   S_TST_ARLOCK,
   S_TST_ARCACHE,
   S_TST_ARPROT,
   S_TST_ARREGION,
   S_TST_ARQOS,
   S_TST_ARUSER,
   S_TST_RDATA,
   S_TST_RRESP,
   S_TST_RUSER
);

//------------------------------------------------------------------------------
parameter C_AXI_NAME = "MASTER_0";

parameter C_AXI_DATA_BUS_WIDTH    = 32;
parameter C_AXI_ADDRESS_BUS_WIDTH = 32;
parameter C_AXI_ID_BUS_WIDTH      = 4;

parameter C_AXI_AWUSER_BUS_WIDTH  = 1;
parameter C_AXI_WUSER_BUS_WIDTH   = 1;
parameter C_AXI_BUSER_BUS_WIDTH   = 1;

parameter C_AXI_ARUSER_BUS_WIDTH  = 1;
parameter C_AXI_RUSER_BUS_WIDTH   = 1;

parameter C_AXI_MAX_OUTSTANDING_TRANSACTIONS = 8;
parameter C_AXI_EXCLUSIVE_ACCESS_SUPPORTED = 0;

//------------------------------------------------------------------------------
// AXI
//------------------------------------------------------------------------------
// System
input wire                                 ACLK;
input wire                                 ARESETN;
// Write address channel
output wire [C_AXI_ID_BUS_WIDTH-1:0]       AWID;    // Master Write address ID.
output wire [C_AXI_ADDRESS_BUS_WIDTH-1:0]  AWADDR;  // Master Write address.
output wire                                AWVALID; // Master Write address valid.
input  wire                                AWREADY; // Slave Write address ready.
output wire [7:0]                          AWLEN;   // Master Burst length.
output wire [2:0]                          AWSIZE;  // Master Burst size.
output wire [1:0]                          AWBURST; // Master Burst type.
output wire                                AWLOCK;  // Master Lock type.
output wire [3:0]                          AWCACHE; // Master Cache type.
output wire [2:0]                          AWPROT;  // Master Protection type.
output wire [3:0]                          AWREGION;// Master Region signals.
output wire [3:0]                          AWQOS;   // Master QoS signals.
output wire [C_AXI_AWUSER_BUS_WIDTH-1:0]   AWUSER;  // Master User defined signals.
// Write data channel
output wire [C_AXI_DATA_BUS_WIDTH-1:0]     WDATA;   // Master Write data.
output wire                                WLAST;   // Master Write last.
output wire                                WVALID;  // Master Write valid.
input  wire                                WREADY;  // Slave Write ready.
output wire [(C_AXI_DATA_BUS_WIDTH/8)-1:0] WSTRB;   // Master Write strobes.
output wire [C_AXI_WUSER_BUS_WIDTH-1:0]    WUSER;   // Master Write User defined signals.
// Write S_TST_BRESP channel
input  wire [C_AXI_ID_BUS_WIDTH-1:0]       BID;     // Slave S_TST_BRESP ID.
input  wire [1:0]                          BRESP;   // Slave Write S_TST_BRESP.
input  wire                                BVALID;  // Slave Write S_TST_BRESP valid.
output wire                                BREADY;  // Master S_TST_BRESP ready.
input  wire [C_AXI_BUSER_BUS_WIDTH-1:0]    BUSER;   // Slave Write user defined signals.
// Read address channel
output wire [C_AXI_ID_BUS_WIDTH-1:0]       ARID;    // Master Read address ID.
output wire [C_AXI_ADDRESS_BUS_WIDTH-1:0]  ARADDR;  // Master Read address.
output wire                                ARVALID; // Master Read address valid.
input  wire                                ARREADY; // Slave Read address ready.
output wire [7:0]                          ARLEN;   // Master Burst length.
output wire [2:0]                          ARSIZE;  // Master Burst size.
output wire [1:0]                          ARBURST; // Master Burst type.
output wire                                ARLOCK;  // Master Lock type.
output wire [3:0]                          ARCACHE; // Master Cache type.
output wire [2:0]                          ARPROT;  // Master Protection type.
output wire [3:0]                          ARREGION;// Master Region signals.
output wire [3:0]                          ARQOS;   // Master QoS signals.
output wire [C_AXI_ARUSER_BUS_WIDTH-1:0]   ARUSER;  // Master User defined signals.
// Read data channel
input  wire [C_AXI_ID_BUS_WIDTH-1:0]       RID;     // Slave Read ID tag.
input  wire [C_AXI_DATA_BUS_WIDTH-1:0]     RDATA;   // Slave Read data.
input  wire                                RLAST;   // Slave Read last.
input  wire                                RVALID;  // Slave Read valid.
output wire                                RREADY;  // Master Read ready.
input  wire [1:0]                          RRESP;   // Slave Read S_TST_BRESP.
input  wire [C_AXI_RUSER_BUS_WIDTH-1:0]    RUSER;   // Slave Read user defined signals.
//------------------------------------------------------------------------------
// Test
//------------------------------------------------------------------------------
// Write
input wire                               S_TST_WRITE_BURST;
output reg                               S_TST_WRITE_BURST_DONE;
input wire [3:0]                         S_TST_AWID;
input wire [C_AXI_ADDRESS_BUS_WIDTH-1:0] S_TST_AWADDR;
input wire [((C_AXI_DATA_BUS_WIDTH/8)*(`MAX_BURST_LENGTH+1))-1:0] S_TST_AWLEN;
input wire [1:0]                         S_TST_AWBURST;
input wire                               S_TST_AWLOCK;
input wire                               S_TST_AWCACHE;
input wire                               S_TST_AWPROT;
input wire                               S_TST_AWREGION;
input wire                               S_TST_AWQOS;
input wire                               S_TST_AWUSER;
input wire [(C_AXI_DATA_BUS_WIDTH*(`MAX_BURST_LENGTH+1))-1:0]  S_TST_WDATA ;
input wire [10:0]                                              S_TST_WDATA_SIZE;
input wire [(C_AXI_RUSER_BUS_WIDTH*(`MAX_BURST_LENGTH+1))-1:0] S_TST_WUSER;
output reg [`RESP_BUS_WIDTH-1:0]                               S_TST_BRESP;
output reg                               S_TST_BUSER;
// Read
input wire                               S_TST_READ_BURST;
output reg                               S_TST_READ_BURST_DONE;
input wire [3:0]                         S_TST_ARID;
input wire [C_AXI_ADDRESS_BUS_WIDTH-1:0] S_TST_ARADDR;
input wire [((C_AXI_DATA_BUS_WIDTH/8)*(`MAX_BURST_LENGTH+1))-1:0] S_TST_ARLEN;
input wire [1:0]                         S_TST_ARBURST;
input wire                               S_TST_ARLOCK;
input wire                               S_TST_ARCACHE;
input wire                               S_TST_ARPROT;
input wire                               S_TST_ARREGION;
input wire                               S_TST_ARQOS;
input wire                               S_TST_ARUSER;
output reg [(C_AXI_DATA_BUS_WIDTH*(`MAX_BURST_LENGTH+1))-1:0]  S_TST_RDATA ;
output reg [(`RESP_BUS_WIDTH*(`MAX_BURST_LENGTH+1))-1:0]       S_TST_RRESP;
output reg [(C_AXI_RUSER_BUS_WIDTH*(`MAX_BURST_LENGTH+1))-1:0] S_TST_RUSER;
//------------------------------------------------------------------------------
// Internal
//------------------------------------------------------------------------------
reg reset_done;

   //---------------------------------------------------------------------------
   // AXI slave instance
   //---------------------------------------------------------------------------
   cdn_axi4_master_bfm #
   (
      .NAME(C_AXI_NAME),
      .DATA_BUS_WIDTH(C_AXI_DATA_BUS_WIDTH),
      .ADDRESS_BUS_WIDTH(C_AXI_ADDRESS_BUS_WIDTH),
      .ID_BUS_WIDTH(C_AXI_ID_BUS_WIDTH),
      .AWUSER_BUS_WIDTH(C_AXI_AWUSER_BUS_WIDTH),
      .ARUSER_BUS_WIDTH(C_AXI_ARUSER_BUS_WIDTH),
      .RUSER_BUS_WIDTH(C_AXI_RUSER_BUS_WIDTH),
      .WUSER_BUS_WIDTH(C_AXI_WUSER_BUS_WIDTH),
      .BUSER_BUS_WIDTH(C_AXI_BUSER_BUS_WIDTH),
      .MAX_OUTSTANDING_TRANSACTIONS(C_AXI_MAX_OUTSTANDING_TRANSACTIONS),
      .EXCLUSIVE_ACCESS_SUPPORTED(C_AXI_EXCLUSIVE_ACCESS_SUPPORTED)
   )
   cdn_axi4_master_bfm_inst
   (
      // System
      .ACLK(ACLK),
      .ARESETn(ARESETN),
      // Write address channel
      .AWID(AWID),
      .AWADDR(AWADDR),
      .AWVALID(AWVALID),
      .AWREADY(AWREADY),
      .AWLEN(AWLEN),
      .AWSIZE(AWSIZE),
      .AWBURST(AWBURST),
      .AWLOCK(AWLOCK),
      .AWCACHE(AWCACHE),
      .AWPROT(AWPROT),
      .AWREGION(AWREGION),
      .AWQOS(AWQOS),
      .AWUSER(AWUSER),
      // Write data channel
      .WDATA(WDATA),
      .WSTRB(WSTRB),
      .WLAST(WLAST),
      .WVALID(WVALID),
      .WREADY(WREADY),
      .WUSER(WUSER),
      // Write S_TST_BRESP channel
      .BID(BID),
      .BRESP(BRESP),
      .BVALID(BVALID),
      .BREADY(BREADY),
      .BUSER(BUSER),
      // Read address channel
      .ARID(ARID),
      .ARADDR(ARADDR),
      .ARVALID(ARVALID),
      .ARREADY(ARREADY),
      .ARLEN(ARLEN),
      .ARSIZE(ARSIZE),
      .ARBURST(ARBURST),
      .ARLOCK(ARLOCK),
      .ARCACHE(ARCACHE),
      .ARPROT(ARPROT),
      .ARREGION(ARREGION),
      .ARQOS(ARQOS),
      .ARUSER(ARUSER),
      // Read data channel
      .RID(RID),
      .RDATA(RDATA),
      .RRESP(RRESP),
      .RLAST(RLAST),
      .RUSER(RUSER),
      .RVALID(RVALID),
      .RREADY(RREADY)
   );

   //---------------------------------------------------------------------------
   // Reset
   //---------------------------------------------------------------------------
   initial begin
      reset_done = 0;
      // Wait for end of reset
      wait(ARESETN === 0) @(posedge ACLK);
      wait(ARESETN === 1) @(posedge ACLK);
      reset_done = 1;
      $display("--------------------------------------------------------------------------------");
      $display("-- Master reset");
      $display("--------------------------------------------------------------------------------");
      $display("(%0t): Reset done", $time);
   end

   //---------------------------------------------------------------------------
   // Commands
   //---------------------------------------------------------------------------
   always @(posedge ACLK) begin
      if ((S_TST_WRITE_BURST == 1) && (reset_done == 1)) begin
         $display("--------------------------------------------------------------------------------");
         $display("-- BFM command WRITE_BURST");
         $display("--------------------------------------------------------------------------------");
         cdn_axi4_master_bfm_inst.WRITE_BURST
         (
            S_TST_AWID, 
            S_TST_AWADDR, 
            S_TST_AWLEN, 
            `BURST_SIZE_4_BYTES, 
            S_TST_AWBURST,
            S_TST_AWLOCK, 
            S_TST_AWCACHE, 
            S_TST_AWPROT, 
            S_TST_WDATA, 
            S_TST_WDATA_SIZE, 
            S_TST_AWREGION, 
            S_TST_AWQOS, 
            S_TST_AWUSER,
            S_TST_WUSER,
            S_TST_BRESP,
            S_TST_BUSER
         );
         $display("Write WDATA = 0x%h, BRESP = 0x%h", S_TST_WDATA, S_TST_BRESP);
         S_TST_WRITE_BURST_DONE = 1;
      end
      else begin
         S_TST_WRITE_BURST_DONE = 0;
      end
   end

   always @(posedge ACLK) begin
      if ((S_TST_READ_BURST == 1) && (reset_done == 1)) begin
         $display("--------------------------------------------------------------------------------");
         $display("-- BFM command READ_BURST");
         $display("--------------------------------------------------------------------------------");
         cdn_axi4_master_bfm_inst.READ_BURST
         (
            S_TST_ARID,
            S_TST_ARADDR,
            S_TST_ARLEN,
            `BURST_SIZE_4_BYTES,
            S_TST_ARBURST,
            S_TST_ARLOCK,
            S_TST_ARCACHE,
            S_TST_ARPROT,
            S_TST_ARREGION,
            S_TST_ARQOS,
            S_TST_ARUSER,
            S_TST_RDATA,
            S_TST_RRESP,
            S_TST_RUSER
         );
         $display("Read RDATA = 0x%h, RRESP = 0x%h", S_TST_RDATA, S_TST_RRESP);
         S_TST_READ_BURST_DONE = 1;
      end
      else begin
         S_TST_READ_BURST_DONE = 0;
      end
   end

endmodule

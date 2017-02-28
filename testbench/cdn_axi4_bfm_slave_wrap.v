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
// File name: cdn_axi4_slave_bfm_top.v
//
// Description: Verilog wrapper for Cadence's "cdn_axi4_slave_bfm" module.
//
//
//------------------------------------------------------------------------------
`timescale 1ps/1ps

// AMBA AXI 4 Range Constants
`define MAX_BURST_LENGTH          8'b1111_1111
`define MAX_DATA_SIZE             (DATA_BUS_WIDTH * (`MAX_BURST_LENGTH + 1)) / 8
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

// Response Type Defines
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

//------------------------------------------------------------------------------
// The AXI 4 Slave BFM Top Level Wrapper
//------------------------------------------------------------------------------
module cdn_axi4_bfm_slave_wrap
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
   // Write response channel
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
   S_TST_WDATA,
   S_TST_WDATA_SIZE,
   S_TST_WUSER,
   S_TST_BUSER,
   // Read
   S_TST_READ_BURST,
   S_TST_READ_BURST_DONE,
   S_TST_ARID,
   S_TST_RDATA,
   S_TST_RUSER
);

//------------------------------------------------------------------------------
parameter C_AXI_NAME              = "SLAVE_0";

parameter C_AXI_SLAVE_ADDRESS     = 32'h00000000;
parameter C_AXI_SLAVE_MEM_SIZE    = 4096;

parameter C_AXI_DATA_BUS_WIDTH    = 32;
parameter C_AXI_ADDRESS_BUS_WIDTH = 32;
parameter C_AXI_ID_BUS_WIDTH      = 4;

parameter C_AXI_AWUSER_BUS_WIDTH  = 1;
parameter C_AXI_WUSER_BUS_WIDTH   = 1;
parameter C_AXI_BUSER_BUS_WIDTH   = 1;

parameter C_AXI_ARUSER_BUS_WIDTH  = 1;
parameter C_AXI_RUSER_BUS_WIDTH   = 1;

parameter C_AXI_MAX_OUTSTANDING_TRANSACTIONS = 8;
parameter C_AXI_MEMORY_MODEL_MODE = 1;
parameter C_AXI_EXCLUSIVE_ACCESS_SUPPORTED = 1;

//------------------------------------------------------------------------------
// AXI
//------------------------------------------------------------------------------
// System
input wire                                 ACLK;    // Global Clock Input. All signals are sampled on the rising edge.
input wire                                 ARESETN; // Global Reset Input. Active Low.
// Write address channel
input  wire [C_AXI_ID_BUS_WIDTH-1:0]       AWID;    // Master Write address ID.
input  wire [C_AXI_ADDRESS_BUS_WIDTH-1:0]  AWADDR;  // Master Write address.
input  wire                                AWVALID; // Master Write address valid.
output wire                                AWREADY; // Slave Write address ready.
input  wire [7:0]                          AWLEN;   // Master Burst length.
input  wire [2:0]                          AWSIZE;  // Master Burst size.
input  wire [1:0]                          AWBURST; // Master Burst type.
input  wire                                AWLOCK;  // Master Lock type.
input  wire [3:0]                          AWCACHE; // Master Cache type.
input  wire [2:0]                          AWPROT;  // Master Protection type.
input  wire [3:0]                          AWREGION;// Master Region signals.
input  wire [3:0]                          AWQOS;   // Master QoS signals.
input  wire [C_AXI_AWUSER_BUS_WIDTH-1:0]   AWUSER;  // Master User defined signals.
// Write data channel
input  wire [C_AXI_DATA_BUS_WIDTH-1:0]     WDATA;   // Master Write data.
input  wire                                WLAST;   // Master Write last.
input  wire                                WVALID;  // Master Write valid.
output wire                                WREADY;  // Slave Write ready.
input  wire [(C_AXI_DATA_BUS_WIDTH/8)-1:0] WSTRB;   // Master Write strobes.
input  wire [C_AXI_WUSER_BUS_WIDTH-1:0]    WUSER;   // Master Write User defined signals.
// Write response channel
output wire [C_AXI_ID_BUS_WIDTH-1:0]       BID;     // Slave Response ID.
output wire [1:0]                          BRESP;   // Slave Write response.
output wire                                BVALID;  // Slave Write response valid.
input  wire                                BREADY;  // Master Response ready.
output wire [C_AXI_BUSER_BUS_WIDTH-1:0]    BUSER;   // Slave Write user defined signals.
// Read address channel
input  wire [C_AXI_ID_BUS_WIDTH-1:0]       ARID;    // Master Read address ID.
input  wire [C_AXI_ADDRESS_BUS_WIDTH-1:0]  ARADDR;  // Master Read address.
input  wire                                ARVALID; // Master Read address valid.
output wire                                ARREADY; // Slave Read address ready.
input  wire [7:0]                          ARLEN;   // Master Burst length.
input  wire [2:0]                          ARSIZE;  // Master Burst size.
input  wire [1:0]                          ARBURST; // Master Burst type.
input  wire                                ARLOCK;  // Master Lock type.
input  wire [3:0]                          ARCACHE; // Master Cache type.
input  wire [2:0]                          ARPROT;  // Master Protection type.
input  wire [3:0]                          ARREGION;// Master Region signals.
input  wire [3:0]                          ARQOS;   // Master QoS signals.
input  wire [C_AXI_ARUSER_BUS_WIDTH-1:0]   ARUSER;  // Master User defined signals.
// Read data channel
output wire [C_AXI_ID_BUS_WIDTH-1:0]       RID;     // Slave Read ID tag.
output wire [C_AXI_DATA_BUS_WIDTH-1:0]     RDATA;   // Slave Read data.
output wire                                RLAST;   // Slave Read last.
output wire                                RVALID;  // Slave Read valid.
input  wire                                RREADY;  // Master Read ready.
output wire [1:0]                          RRESP;   // Slave Read response.
output wire [C_AXI_RUSER_BUS_WIDTH-1:0]    RUSER;   // Slave Read user defined signals.
//------------------------------------------------------------------------------
// Test
//------------------------------------------------------------------------------
// Write
input  wire                                                     S_TST_BUSER;
output reg [(C_AXI_WUSER_BUS_WIDTH*(`MAX_BURST_LENGTH+1))-1:0]  S_TST_WUSER;
output reg                                                      S_TST_WDATA_SIZE;
output reg [(C_AXI_DATA_BUS_WIDTH*(`MAX_BURST_LENGTH+1))-1:0]   S_TST_WDATA;
input  wire [3:0]                                               S_TST_AWID;
input  wire [3:0]                                               S_TST_ARID;
// Read
input  wire [(C_AXI_DATA_BUS_WIDTH*(`MAX_BURST_LENGTH+1))-1:0]  S_TST_RDATA;
input  wire                                                     S_TST_WRITE_BURST;
input  wire                                                     S_TST_READ_BURST;
output reg                                                      S_TST_WRITE_BURST_DONE;
output reg                                                      S_TST_READ_BURST_DONE;
input  wire [(C_AXI_RUSER_BUS_WIDTH*(`MAX_BURST_LENGTH+1))-1:0] S_TST_RUSER;
//------------------------------------------------------------------------------
// Internal
//------------------------------------------------------------------------------
reg    reset_done;
reg [7:0] memory_array[4096:0];

   //---------------------------------------------------------------------------
   // AXI slave instance
   //---------------------------------------------------------------------------
   cdn_axi4_slave_bfm #
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
      .SLAVE_ADDRESS(C_AXI_SLAVE_ADDRESS),
      .SLAVE_MEM_SIZE(C_AXI_SLAVE_MEM_SIZE),
      .MAX_OUTSTANDING_TRANSACTIONS(C_AXI_MAX_OUTSTANDING_TRANSACTIONS),
      .MEMORY_MODEL_MODE(C_AXI_MEMORY_MODEL_MODE),
      .EXCLUSIVE_ACCESS_SUPPORTED(C_AXI_EXCLUSIVE_ACCESS_SUPPORTED)
   )
   cdn_axi4_slave_bfm_inst
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
      .WLAST(WLAST),
      .WVALID(WVALID),
      .WREADY(WREADY),
      .WSTRB(WSTRB),
      .WUSER(WUSER),
      // Write response channel
      .BID(BID),
      .BRESP(BRESP),
      .BVALID(BVALID),
      .BUSER(BUSER),
      .BREADY(BREADY),
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
      .RLAST(RLAST),
      .RVALID(RVALID),
      .RREADY(RREADY),
      .RRESP(RRESP),
      .RUSER(RUSER)
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
      $display("-- Slave reset");
      $display("--------------------------------------------------------------------------------");
      $display("(%0t): Reset done", $time);
   end

   //---------------------------------------------------------------------------
   // Commands
   //---------------------------------------------------------------------------
   always @(posedge ACLK)
   begin
      if ((S_TST_WRITE_BURST == 1) && (reset_done == 1)) begin
         $display("--------------------------------------------------------------------------------");
         $display("-- CDC command WRITE_BURST_RESPOND");
         $display("--------------------------------------------------------------------------------");
         cdn_axi4_slave_bfm_inst.WRITE_BURST_RESPOND(S_TST_AWID, S_TST_BUSER, S_TST_WDATA, S_TST_WDATA_SIZE, S_TST_WUSER);
         $display("(%0t): Write of data 0x%h", $time, S_TST_WDATA);
         S_TST_WRITE_BURST_DONE = 1;
      end
      else begin
         S_TST_WRITE_BURST_DONE = 0;
      end
   end

   always @(posedge ACLK)
   begin
      if ((S_TST_READ_BURST == 1) && (reset_done == 1 )) begin
         $display("--------------------------------------------------------------------------------");
         $display("-- CDC command READ_BURST_RESPOND");
         $display("--------------------------------------------------------------------------------");
         $display("---------------------------------------------------------");
         cdn_axi4_slave_bfm_inst.READ_BURST_RESPOND(S_TST_ARID, S_TST_RDATA, S_TST_RUSER);
         $display("(%0t): Read of data 0x%h", $time, S_TST_RDATA);
         S_TST_READ_BURST_DONE = 1;
      end
      else begin
         S_TST_READ_BURST_DONE = 0;
      end
   end

   //---------------------------------------------------------------------------
   // Write Path
   //---------------------------------------------------------------------------
   always @(posedge ACLK) begin : WRITE_PATH
      reg [C_AXI_ID_BUS_WIDTH-1:0]      id;
      reg [C_AXI_ADDRESS_BUS_WIDTH-1:0] address;
      reg [`LENGTH_BUS_WIDTH-1:0]       length;
      reg [`SIZE_BUS_WIDTH-1:0]         size;
      reg [`BURST_BUS_WIDTH-1:0]        burst_type;
      reg [`LOCK_BUS_WIDTH-1:0]         lock_type;
      reg [`CACHE_BUS_WIDTH-1:0]        cache_type;
      reg [`PROT_BUS_WIDTH-1:0]         protection_type;
      reg [`REGION_BUS_WIDTH-1:0]       region_type;
      reg [`QOS_BUS_WIDTH-1:0]          qos_type;
      reg [C_AXI_AWUSER_BUS_WIDTH-1:0]  awuser_type;
      reg [C_AXI_ID_BUS_WIDTH-1:0]      idtag;
      reg [(C_AXI_DATA_BUS_WIDTH*(`MAX_BURST_LENGTH+1))-1:0] data;
      reg [C_AXI_ADDRESS_BUS_WIDTH-1:0] internal_address;
      reg [C_AXI_WUSER_BUS_WIDTH-1:0]   wuser_type;
      reg [`RESP_BUS_WIDTH-1:0]         response;
      reg [C_AXI_BUSER_BUS_WIDTH-1:0]   buser_type;
      integer i;
      integer datasize;
      //----------------------------------------------------------------
      // Implementation Code
      //----------------------------------------------------------------
      if (C_AXI_MEMORY_MODEL_MODE == 1) begin
         // Receive the next available write address
         cdn_axi4_slave_bfm_inst.RECEIVE_WRITE_ADDRESS(id, `IDVALID_FALSE, address, length, size, burst_type, lock_type, cache_type, protection_type, region_type, qos_type, awuser_type, idtag);
         // Get the data to send to the memory.
         cdn_axi4_slave_bfm_inst.RECEIVE_WRITE_BURST(address, length, size, burst_type, data, datasize, wuser_type);
         // Put the data into the memory array
         internal_address = address - C_AXI_SLAVE_ADDRESS;
         for (i=0; i < datasize; i = i + 1) begin
            memory_array[internal_address+i] = data[i*8 +: 8];
         end
         // End the complete write burst/transfer with a write response
         // Work out which response type to send based on the lock type.
         response = `RESPONSE_OKAY;
         repeat(2) @(posedge ACLK);
         cdn_axi4_slave_bfm_inst.SEND_WRITE_RESPONSE(idtag, response, buser_type);
      end
   end

   //-----------------------------------------------------------------
   // Read Path
   //-----------------------------------------------------------------
   always @(posedge ACLK) begin : READ_PATH
      //---------------------------------------------------------------
      // Local Variables
      //---------------------------------------------------------------
      reg [C_AXI_ID_BUS_WIDTH-1:0] id;
      reg [C_AXI_ADDRESS_BUS_WIDTH-1:0] address;
      reg [`LENGTH_BUS_WIDTH-1:0] length;
      reg [`SIZE_BUS_WIDTH-1:0] size;
      reg [`BURST_BUS_WIDTH-1:0] burst_type;
      reg [`LOCK_BUS_WIDTH-1:0] lock_type;
      reg [`CACHE_BUS_WIDTH-1:0] cache_type;
      reg [`PROT_BUS_WIDTH-1:0] protection_type;
      reg [`REGION_BUS_WIDTH-1:0] region_type;
      reg [`QOS_BUS_WIDTH-1:0] qos_type;
      reg [C_AXI_AWUSER_BUS_WIDTH-1:0] aruser_type;
      reg [C_AXI_ID_BUS_WIDTH-1:0] idtag;
      reg [(C_AXI_DATA_BUS_WIDTH*(`MAX_BURST_LENGTH+1))-1:0] data;
      reg [C_AXI_ADDRESS_BUS_WIDTH-1:0] internal_address;
      reg [C_AXI_RUSER_BUS_WIDTH-1:0] ruser_type;
      integer i;
      integer number_of_valid_bytes;
      //---------------------------------------------------------------
      // Implementation Code
      //---------------------------------------------------------------
      if (C_AXI_MEMORY_MODEL_MODE == 1) begin
         // Receive a read address transfer
         cdn_axi4_slave_bfm_inst.RECEIVE_READ_ADDRESS(id,`IDVALID_FALSE,address,length,size, burst_type,lock_type,cache_type,protection_type,region_type, qos_type, aruser_type, idtag);
         // Get the data to send from the memory.
         internal_address = address - C_AXI_SLAVE_ADDRESS;
         data = 0;
         number_of_valid_bytes = (length*size)-(address % (C_AXI_DATA_BUS_WIDTH/8));
         for (i=0; i < number_of_valid_bytes; i=i+1) begin
            data[i*8 +: 8] = memory_array[internal_address+i];
         end
         // Send the read data
         repeat(2) @(posedge ACLK);
         cdn_axi4_slave_bfm_inst.SEND_READ_BURST(idtag,address,length,size,burst_type, lock_type,data,ruser_type);
      end
   end
 
endmodule

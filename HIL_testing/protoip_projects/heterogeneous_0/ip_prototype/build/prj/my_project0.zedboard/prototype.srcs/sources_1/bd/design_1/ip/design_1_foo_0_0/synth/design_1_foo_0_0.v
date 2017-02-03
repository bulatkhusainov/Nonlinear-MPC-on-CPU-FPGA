// (c) Copyright 1995-2017 Xilinx, Inc. All rights reserved.
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
// DO NOT MODIFY THIS FILE.


// IP VLNV: icl.ac.uk:hls:foo:1.0
// IP Revision: 1702031031

(* X_CORE_INFO = "foo,Vivado 2015.2" *)
(* CHECK_LICENSE_TYPE = "design_1_foo_0_0,foo,{}" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module design_1_foo_0_0 (
  s_axi_BUS_A_AWADDR,
  s_axi_BUS_A_AWVALID,
  s_axi_BUS_A_AWREADY,
  s_axi_BUS_A_WDATA,
  s_axi_BUS_A_WSTRB,
  s_axi_BUS_A_WVALID,
  s_axi_BUS_A_WREADY,
  s_axi_BUS_A_BRESP,
  s_axi_BUS_A_BVALID,
  s_axi_BUS_A_BREADY,
  s_axi_BUS_A_ARADDR,
  s_axi_BUS_A_ARVALID,
  s_axi_BUS_A_ARREADY,
  s_axi_BUS_A_RDATA,
  s_axi_BUS_A_RRESP,
  s_axi_BUS_A_RVALID,
  s_axi_BUS_A_RREADY,
  ap_clk,
  ap_rst_n,
  interrupt,
  m_axi_memory_inout_AWID,
  m_axi_memory_inout_AWADDR,
  m_axi_memory_inout_AWLEN,
  m_axi_memory_inout_AWSIZE,
  m_axi_memory_inout_AWBURST,
  m_axi_memory_inout_AWLOCK,
  m_axi_memory_inout_AWREGION,
  m_axi_memory_inout_AWCACHE,
  m_axi_memory_inout_AWPROT,
  m_axi_memory_inout_AWQOS,
  m_axi_memory_inout_AWVALID,
  m_axi_memory_inout_AWREADY,
  m_axi_memory_inout_WID,
  m_axi_memory_inout_WDATA,
  m_axi_memory_inout_WSTRB,
  m_axi_memory_inout_WLAST,
  m_axi_memory_inout_WVALID,
  m_axi_memory_inout_WREADY,
  m_axi_memory_inout_BID,
  m_axi_memory_inout_BRESP,
  m_axi_memory_inout_BVALID,
  m_axi_memory_inout_BREADY,
  m_axi_memory_inout_ARID,
  m_axi_memory_inout_ARADDR,
  m_axi_memory_inout_ARLEN,
  m_axi_memory_inout_ARSIZE,
  m_axi_memory_inout_ARBURST,
  m_axi_memory_inout_ARLOCK,
  m_axi_memory_inout_ARREGION,
  m_axi_memory_inout_ARCACHE,
  m_axi_memory_inout_ARPROT,
  m_axi_memory_inout_ARQOS,
  m_axi_memory_inout_ARVALID,
  m_axi_memory_inout_ARREADY,
  m_axi_memory_inout_RID,
  m_axi_memory_inout_RDATA,
  m_axi_memory_inout_RRESP,
  m_axi_memory_inout_RLAST,
  m_axi_memory_inout_RVALID,
  m_axi_memory_inout_RREADY
);

(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_BUS_A AWADDR" *)
input wire [5 : 0] s_axi_BUS_A_AWADDR;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_BUS_A AWVALID" *)
input wire s_axi_BUS_A_AWVALID;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_BUS_A AWREADY" *)
output wire s_axi_BUS_A_AWREADY;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_BUS_A WDATA" *)
input wire [31 : 0] s_axi_BUS_A_WDATA;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_BUS_A WSTRB" *)
input wire [3 : 0] s_axi_BUS_A_WSTRB;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_BUS_A WVALID" *)
input wire s_axi_BUS_A_WVALID;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_BUS_A WREADY" *)
output wire s_axi_BUS_A_WREADY;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_BUS_A BRESP" *)
output wire [1 : 0] s_axi_BUS_A_BRESP;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_BUS_A BVALID" *)
output wire s_axi_BUS_A_BVALID;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_BUS_A BREADY" *)
input wire s_axi_BUS_A_BREADY;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_BUS_A ARADDR" *)
input wire [5 : 0] s_axi_BUS_A_ARADDR;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_BUS_A ARVALID" *)
input wire s_axi_BUS_A_ARVALID;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_BUS_A ARREADY" *)
output wire s_axi_BUS_A_ARREADY;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_BUS_A RDATA" *)
output wire [31 : 0] s_axi_BUS_A_RDATA;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_BUS_A RRESP" *)
output wire [1 : 0] s_axi_BUS_A_RRESP;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_BUS_A RVALID" *)
output wire s_axi_BUS_A_RVALID;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi_BUS_A RREADY" *)
input wire s_axi_BUS_A_RREADY;
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 ap_clk CLK" *)
input wire ap_clk;
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 ap_rst_n RST" *)
input wire ap_rst_n;
(* X_INTERFACE_INFO = "xilinx.com:signal:interrupt:1.0 interrupt INTERRUPT" *)
output wire interrupt;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_memory_inout AWID" *)
output wire [0 : 0] m_axi_memory_inout_AWID;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_memory_inout AWADDR" *)
output wire [31 : 0] m_axi_memory_inout_AWADDR;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_memory_inout AWLEN" *)
output wire [7 : 0] m_axi_memory_inout_AWLEN;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_memory_inout AWSIZE" *)
output wire [2 : 0] m_axi_memory_inout_AWSIZE;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_memory_inout AWBURST" *)
output wire [1 : 0] m_axi_memory_inout_AWBURST;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_memory_inout AWLOCK" *)
output wire [1 : 0] m_axi_memory_inout_AWLOCK;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_memory_inout AWREGION" *)
output wire [3 : 0] m_axi_memory_inout_AWREGION;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_memory_inout AWCACHE" *)
output wire [3 : 0] m_axi_memory_inout_AWCACHE;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_memory_inout AWPROT" *)
output wire [2 : 0] m_axi_memory_inout_AWPROT;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_memory_inout AWQOS" *)
output wire [3 : 0] m_axi_memory_inout_AWQOS;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_memory_inout AWVALID" *)
output wire m_axi_memory_inout_AWVALID;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_memory_inout AWREADY" *)
input wire m_axi_memory_inout_AWREADY;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_memory_inout WID" *)
output wire [0 : 0] m_axi_memory_inout_WID;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_memory_inout WDATA" *)
output wire [31 : 0] m_axi_memory_inout_WDATA;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_memory_inout WSTRB" *)
output wire [3 : 0] m_axi_memory_inout_WSTRB;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_memory_inout WLAST" *)
output wire m_axi_memory_inout_WLAST;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_memory_inout WVALID" *)
output wire m_axi_memory_inout_WVALID;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_memory_inout WREADY" *)
input wire m_axi_memory_inout_WREADY;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_memory_inout BID" *)
input wire [0 : 0] m_axi_memory_inout_BID;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_memory_inout BRESP" *)
input wire [1 : 0] m_axi_memory_inout_BRESP;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_memory_inout BVALID" *)
input wire m_axi_memory_inout_BVALID;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_memory_inout BREADY" *)
output wire m_axi_memory_inout_BREADY;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_memory_inout ARID" *)
output wire [0 : 0] m_axi_memory_inout_ARID;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_memory_inout ARADDR" *)
output wire [31 : 0] m_axi_memory_inout_ARADDR;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_memory_inout ARLEN" *)
output wire [7 : 0] m_axi_memory_inout_ARLEN;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_memory_inout ARSIZE" *)
output wire [2 : 0] m_axi_memory_inout_ARSIZE;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_memory_inout ARBURST" *)
output wire [1 : 0] m_axi_memory_inout_ARBURST;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_memory_inout ARLOCK" *)
output wire [1 : 0] m_axi_memory_inout_ARLOCK;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_memory_inout ARREGION" *)
output wire [3 : 0] m_axi_memory_inout_ARREGION;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_memory_inout ARCACHE" *)
output wire [3 : 0] m_axi_memory_inout_ARCACHE;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_memory_inout ARPROT" *)
output wire [2 : 0] m_axi_memory_inout_ARPROT;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_memory_inout ARQOS" *)
output wire [3 : 0] m_axi_memory_inout_ARQOS;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_memory_inout ARVALID" *)
output wire m_axi_memory_inout_ARVALID;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_memory_inout ARREADY" *)
input wire m_axi_memory_inout_ARREADY;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_memory_inout RID" *)
input wire [0 : 0] m_axi_memory_inout_RID;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_memory_inout RDATA" *)
input wire [31 : 0] m_axi_memory_inout_RDATA;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_memory_inout RRESP" *)
input wire [1 : 0] m_axi_memory_inout_RRESP;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_memory_inout RLAST" *)
input wire m_axi_memory_inout_RLAST;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_memory_inout RVALID" *)
input wire m_axi_memory_inout_RVALID;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 m_axi_memory_inout RREADY" *)
output wire m_axi_memory_inout_RREADY;

  foo #(
    .C_S_AXI_BUS_A_ADDR_WIDTH(6),
    .C_S_AXI_BUS_A_DATA_WIDTH(32),
    .C_M_AXI_MEMORY_INOUT_ID_WIDTH(1),
    .C_M_AXI_MEMORY_INOUT_ADDR_WIDTH(32),
    .C_M_AXI_MEMORY_INOUT_DATA_WIDTH(32),
    .C_M_AXI_MEMORY_INOUT_AWUSER_WIDTH(1),
    .C_M_AXI_MEMORY_INOUT_ARUSER_WIDTH(1),
    .C_M_AXI_MEMORY_INOUT_WUSER_WIDTH(1),
    .C_M_AXI_MEMORY_INOUT_RUSER_WIDTH(1),
    .C_M_AXI_MEMORY_INOUT_BUSER_WIDTH(1),
    .C_M_AXI_MEMORY_INOUT_USER_VALUE(32'H00000000),
    .C_M_AXI_MEMORY_INOUT_PROT_VALUE(3'B000),
    .C_M_AXI_MEMORY_INOUT_CACHE_VALUE(4'B0011),
    .C_M_AXI_MEMORY_INOUT_TARGET_ADDR(32'H00000000)
  ) inst (
    .s_axi_BUS_A_AWADDR(s_axi_BUS_A_AWADDR),
    .s_axi_BUS_A_AWVALID(s_axi_BUS_A_AWVALID),
    .s_axi_BUS_A_AWREADY(s_axi_BUS_A_AWREADY),
    .s_axi_BUS_A_WDATA(s_axi_BUS_A_WDATA),
    .s_axi_BUS_A_WSTRB(s_axi_BUS_A_WSTRB),
    .s_axi_BUS_A_WVALID(s_axi_BUS_A_WVALID),
    .s_axi_BUS_A_WREADY(s_axi_BUS_A_WREADY),
    .s_axi_BUS_A_BRESP(s_axi_BUS_A_BRESP),
    .s_axi_BUS_A_BVALID(s_axi_BUS_A_BVALID),
    .s_axi_BUS_A_BREADY(s_axi_BUS_A_BREADY),
    .s_axi_BUS_A_ARADDR(s_axi_BUS_A_ARADDR),
    .s_axi_BUS_A_ARVALID(s_axi_BUS_A_ARVALID),
    .s_axi_BUS_A_ARREADY(s_axi_BUS_A_ARREADY),
    .s_axi_BUS_A_RDATA(s_axi_BUS_A_RDATA),
    .s_axi_BUS_A_RRESP(s_axi_BUS_A_RRESP),
    .s_axi_BUS_A_RVALID(s_axi_BUS_A_RVALID),
    .s_axi_BUS_A_RREADY(s_axi_BUS_A_RREADY),
    .ap_clk(ap_clk),
    .ap_rst_n(ap_rst_n),
    .interrupt(interrupt),
    .m_axi_memory_inout_AWID(m_axi_memory_inout_AWID),
    .m_axi_memory_inout_AWADDR(m_axi_memory_inout_AWADDR),
    .m_axi_memory_inout_AWLEN(m_axi_memory_inout_AWLEN),
    .m_axi_memory_inout_AWSIZE(m_axi_memory_inout_AWSIZE),
    .m_axi_memory_inout_AWBURST(m_axi_memory_inout_AWBURST),
    .m_axi_memory_inout_AWLOCK(m_axi_memory_inout_AWLOCK),
    .m_axi_memory_inout_AWREGION(m_axi_memory_inout_AWREGION),
    .m_axi_memory_inout_AWCACHE(m_axi_memory_inout_AWCACHE),
    .m_axi_memory_inout_AWPROT(m_axi_memory_inout_AWPROT),
    .m_axi_memory_inout_AWQOS(m_axi_memory_inout_AWQOS),
    .m_axi_memory_inout_AWUSER(),
    .m_axi_memory_inout_AWVALID(m_axi_memory_inout_AWVALID),
    .m_axi_memory_inout_AWREADY(m_axi_memory_inout_AWREADY),
    .m_axi_memory_inout_WID(m_axi_memory_inout_WID),
    .m_axi_memory_inout_WDATA(m_axi_memory_inout_WDATA),
    .m_axi_memory_inout_WSTRB(m_axi_memory_inout_WSTRB),
    .m_axi_memory_inout_WLAST(m_axi_memory_inout_WLAST),
    .m_axi_memory_inout_WUSER(),
    .m_axi_memory_inout_WVALID(m_axi_memory_inout_WVALID),
    .m_axi_memory_inout_WREADY(m_axi_memory_inout_WREADY),
    .m_axi_memory_inout_BID(m_axi_memory_inout_BID),
    .m_axi_memory_inout_BRESP(m_axi_memory_inout_BRESP),
    .m_axi_memory_inout_BUSER(1'B0),
    .m_axi_memory_inout_BVALID(m_axi_memory_inout_BVALID),
    .m_axi_memory_inout_BREADY(m_axi_memory_inout_BREADY),
    .m_axi_memory_inout_ARID(m_axi_memory_inout_ARID),
    .m_axi_memory_inout_ARADDR(m_axi_memory_inout_ARADDR),
    .m_axi_memory_inout_ARLEN(m_axi_memory_inout_ARLEN),
    .m_axi_memory_inout_ARSIZE(m_axi_memory_inout_ARSIZE),
    .m_axi_memory_inout_ARBURST(m_axi_memory_inout_ARBURST),
    .m_axi_memory_inout_ARLOCK(m_axi_memory_inout_ARLOCK),
    .m_axi_memory_inout_ARREGION(m_axi_memory_inout_ARREGION),
    .m_axi_memory_inout_ARCACHE(m_axi_memory_inout_ARCACHE),
    .m_axi_memory_inout_ARPROT(m_axi_memory_inout_ARPROT),
    .m_axi_memory_inout_ARQOS(m_axi_memory_inout_ARQOS),
    .m_axi_memory_inout_ARUSER(),
    .m_axi_memory_inout_ARVALID(m_axi_memory_inout_ARVALID),
    .m_axi_memory_inout_ARREADY(m_axi_memory_inout_ARREADY),
    .m_axi_memory_inout_RID(m_axi_memory_inout_RID),
    .m_axi_memory_inout_RDATA(m_axi_memory_inout_RDATA),
    .m_axi_memory_inout_RRESP(m_axi_memory_inout_RRESP),
    .m_axi_memory_inout_RLAST(m_axi_memory_inout_RLAST),
    .m_axi_memory_inout_RUSER(1'B0),
    .m_axi_memory_inout_RVALID(m_axi_memory_inout_RVALID),
    .m_axi_memory_inout_RREADY(m_axi_memory_inout_RREADY)
  );
endmodule

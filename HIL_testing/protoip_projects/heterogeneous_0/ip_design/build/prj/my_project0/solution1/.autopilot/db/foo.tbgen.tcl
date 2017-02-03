set C_TypeInfoList {{ 
"foo" : [[], { "return": [[], "void"]} , [{"ExternC" : 0}], [ {"byte_block_in_offset": [[],"0"] }, {"byte_x_in_in_offset": [[],"0"] }, {"byte_y_out_out_offset": [[],"0"] }, {"memory_inout": [[],{ "pointer": "1"}] }],[],""], 
"0": [ "uint32_t", {"typedef": [[[], {"scalar": "unsigned int"}],""]}], 
"1": [ "data_t_memory", {"typedef": [[[], {"scalar": "float"}],""]}]
}}
set moduleName foo
set isCombinational 0
set isDatapathOnly 0
set isPipelined 0
set pipeline_type none
set FunctionProtocol ap_ctrl_hs
set isOneStateSeq 0
set C_modelName {foo}
set C_modelType { void 0 }
set C_modelArgList { 
	{ byte_block_in_offset int 32 regular {axi_slave 0}  }
	{ byte_x_in_in_offset int 32 regular {axi_slave 0}  }
	{ byte_y_out_out_offset int 32 regular {axi_slave 0}  }
	{ memory_inout float 32 regular {axi_master 2}  }
}
set C_modelArgMapList {[ 
	{ "Name" : "byte_block_in_offset", "interface" : "axi_slave", "bundle":"BUS_A","type":"ap_none","bitwidth" : 32 ,"direction" : "READONLY" ,"bitSlice":[{"low":0,"up":31,"cElement": [{"cName": "byte_block_in_offset","cData": "unsigned int","bit_use": { "low": 0,"up": 31},"cArray": [{"low" : 0,"up" : 0,"step" : 0}]}]}], "offset" : {"in":16}, "offset_end" : {"in":23}} , 
 	{ "Name" : "byte_x_in_in_offset", "interface" : "axi_slave", "bundle":"BUS_A","type":"ap_none","bitwidth" : 32 ,"direction" : "READONLY" ,"bitSlice":[{"low":0,"up":31,"cElement": [{"cName": "byte_x_in_in_offset","cData": "unsigned int","bit_use": { "low": 0,"up": 31},"cArray": [{"low" : 0,"up" : 0,"step" : 0}]}]}], "offset" : {"in":24}, "offset_end" : {"in":31}} , 
 	{ "Name" : "byte_y_out_out_offset", "interface" : "axi_slave", "bundle":"BUS_A","type":"ap_none","bitwidth" : 32 ,"direction" : "READONLY" ,"bitSlice":[{"low":0,"up":31,"cElement": [{"cName": "byte_y_out_out_offset","cData": "unsigned int","bit_use": { "low": 0,"up": 31},"cArray": [{"low" : 0,"up" : 0,"step" : 0}]}]}], "offset" : {"in":32}, "offset_end" : {"in":39}} , 
 	{ "Name" : "memory_inout", "interface" : "axi_master", "bitwidth" : 32 ,"direction" : "READWRITE" ,"bitSlice":[{"low":0,"up":31,"cElement": [{"cName": "memory_inout","cData": "float","bit_use": { "low": 0,"up": 31},"cArray": [{"low" : 0,"up" : 14,"step" : 1}]}]}]} ]}
# RTL Port declarations: 
set portNum 65
set portList { 
	{ s_axi_BUS_A_AWVALID sc_in sc_logic 1 signal -1 } 
	{ s_axi_BUS_A_AWREADY sc_out sc_logic 1 signal -1 } 
	{ s_axi_BUS_A_AWADDR sc_in sc_lv 6 signal -1 } 
	{ s_axi_BUS_A_WVALID sc_in sc_logic 1 signal -1 } 
	{ s_axi_BUS_A_WREADY sc_out sc_logic 1 signal -1 } 
	{ s_axi_BUS_A_WDATA sc_in sc_lv 32 signal -1 } 
	{ s_axi_BUS_A_WSTRB sc_in sc_lv 4 signal -1 } 
	{ s_axi_BUS_A_ARVALID sc_in sc_logic 1 signal -1 } 
	{ s_axi_BUS_A_ARREADY sc_out sc_logic 1 signal -1 } 
	{ s_axi_BUS_A_ARADDR sc_in sc_lv 6 signal -1 } 
	{ s_axi_BUS_A_RVALID sc_out sc_logic 1 signal -1 } 
	{ s_axi_BUS_A_RREADY sc_in sc_logic 1 signal -1 } 
	{ s_axi_BUS_A_RDATA sc_out sc_lv 32 signal -1 } 
	{ s_axi_BUS_A_RRESP sc_out sc_lv 2 signal -1 } 
	{ s_axi_BUS_A_BVALID sc_out sc_logic 1 signal -1 } 
	{ s_axi_BUS_A_BREADY sc_in sc_logic 1 signal -1 } 
	{ s_axi_BUS_A_BRESP sc_out sc_lv 2 signal -1 } 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst_n sc_in sc_logic 1 reset -1 active_low_sync } 
	{ m_axi_memory_inout_AWVALID sc_out sc_logic 1 signal 3 } 
	{ m_axi_memory_inout_AWREADY sc_in sc_logic 1 signal 3 } 
	{ m_axi_memory_inout_AWADDR sc_out sc_lv 32 signal 3 } 
	{ m_axi_memory_inout_AWID sc_out sc_lv 1 signal 3 } 
	{ m_axi_memory_inout_AWLEN sc_out sc_lv 8 signal 3 } 
	{ m_axi_memory_inout_AWSIZE sc_out sc_lv 3 signal 3 } 
	{ m_axi_memory_inout_AWBURST sc_out sc_lv 2 signal 3 } 
	{ m_axi_memory_inout_AWLOCK sc_out sc_lv 2 signal 3 } 
	{ m_axi_memory_inout_AWCACHE sc_out sc_lv 4 signal 3 } 
	{ m_axi_memory_inout_AWPROT sc_out sc_lv 3 signal 3 } 
	{ m_axi_memory_inout_AWQOS sc_out sc_lv 4 signal 3 } 
	{ m_axi_memory_inout_AWREGION sc_out sc_lv 4 signal 3 } 
	{ m_axi_memory_inout_AWUSER sc_out sc_lv 1 signal 3 } 
	{ m_axi_memory_inout_WVALID sc_out sc_logic 1 signal 3 } 
	{ m_axi_memory_inout_WREADY sc_in sc_logic 1 signal 3 } 
	{ m_axi_memory_inout_WDATA sc_out sc_lv 32 signal 3 } 
	{ m_axi_memory_inout_WSTRB sc_out sc_lv 4 signal 3 } 
	{ m_axi_memory_inout_WLAST sc_out sc_logic 1 signal 3 } 
	{ m_axi_memory_inout_WID sc_out sc_lv 1 signal 3 } 
	{ m_axi_memory_inout_WUSER sc_out sc_lv 1 signal 3 } 
	{ m_axi_memory_inout_ARVALID sc_out sc_logic 1 signal 3 } 
	{ m_axi_memory_inout_ARREADY sc_in sc_logic 1 signal 3 } 
	{ m_axi_memory_inout_ARADDR sc_out sc_lv 32 signal 3 } 
	{ m_axi_memory_inout_ARID sc_out sc_lv 1 signal 3 } 
	{ m_axi_memory_inout_ARLEN sc_out sc_lv 8 signal 3 } 
	{ m_axi_memory_inout_ARSIZE sc_out sc_lv 3 signal 3 } 
	{ m_axi_memory_inout_ARBURST sc_out sc_lv 2 signal 3 } 
	{ m_axi_memory_inout_ARLOCK sc_out sc_lv 2 signal 3 } 
	{ m_axi_memory_inout_ARCACHE sc_out sc_lv 4 signal 3 } 
	{ m_axi_memory_inout_ARPROT sc_out sc_lv 3 signal 3 } 
	{ m_axi_memory_inout_ARQOS sc_out sc_lv 4 signal 3 } 
	{ m_axi_memory_inout_ARREGION sc_out sc_lv 4 signal 3 } 
	{ m_axi_memory_inout_ARUSER sc_out sc_lv 1 signal 3 } 
	{ m_axi_memory_inout_RVALID sc_in sc_logic 1 signal 3 } 
	{ m_axi_memory_inout_RREADY sc_out sc_logic 1 signal 3 } 
	{ m_axi_memory_inout_RDATA sc_in sc_lv 32 signal 3 } 
	{ m_axi_memory_inout_RLAST sc_in sc_logic 1 signal 3 } 
	{ m_axi_memory_inout_RID sc_in sc_lv 1 signal 3 } 
	{ m_axi_memory_inout_RUSER sc_in sc_lv 1 signal 3 } 
	{ m_axi_memory_inout_RRESP sc_in sc_lv 2 signal 3 } 
	{ m_axi_memory_inout_BVALID sc_in sc_logic 1 signal 3 } 
	{ m_axi_memory_inout_BREADY sc_out sc_logic 1 signal 3 } 
	{ m_axi_memory_inout_BRESP sc_in sc_lv 2 signal 3 } 
	{ m_axi_memory_inout_BID sc_in sc_lv 1 signal 3 } 
	{ m_axi_memory_inout_BUSER sc_in sc_lv 1 signal 3 } 
	{ interrupt sc_out sc_logic 1 signal -1 } 
}
set NewPortList {[ 
	{ "name": "s_axi_BUS_A_AWADDR", "direction": "in", "datatype": "sc_lv", "bitwidth":6, "type": "signal", "bundle":{"name": "BUS_A", "role": "AWADDR" },"address":[{"name":"foo","role":"start","value":"0","valid_bit":"0"},{"name":"foo","role":"continue","value":"0","valid_bit":"4"},{"name":"foo","role":"auto_start","value":"0","valid_bit":"7"},{"name":"byte_block_in_offset","role":"data","value":"16"},{"name":"byte_x_in_in_offset","role":"data","value":"24"},{"name":"byte_y_out_out_offset","role":"data","value":"32"}] },
	{ "name": "s_axi_BUS_A_AWVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "BUS_A", "role": "AWVALID" } },
	{ "name": "s_axi_BUS_A_AWREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "BUS_A", "role": "AWREADY" } },
	{ "name": "s_axi_BUS_A_WVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "BUS_A", "role": "WVALID" } },
	{ "name": "s_axi_BUS_A_WREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "BUS_A", "role": "WREADY" } },
	{ "name": "s_axi_BUS_A_WDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "BUS_A", "role": "WDATA" } },
	{ "name": "s_axi_BUS_A_WSTRB", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "BUS_A", "role": "WSTRB" } },
	{ "name": "s_axi_BUS_A_ARADDR", "direction": "in", "datatype": "sc_lv", "bitwidth":6, "type": "signal", "bundle":{"name": "BUS_A", "role": "ARADDR" },"address":[{"name":"foo","role":"start","value":"0","valid_bit":"0"},{"name":"foo","role":"done","value":"0","valid_bit":"1"},{"name":"foo","role":"idle","value":"0","valid_bit":"2"},{"name":"foo","role":"ready","value":"0","valid_bit":"3"},{"name":"foo","role":"auto_start","value":"0","valid_bit":"7"}] },
	{ "name": "s_axi_BUS_A_ARVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "BUS_A", "role": "ARVALID" } },
	{ "name": "s_axi_BUS_A_ARREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "BUS_A", "role": "ARREADY" } },
	{ "name": "s_axi_BUS_A_RVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "BUS_A", "role": "RVALID" } },
	{ "name": "s_axi_BUS_A_RREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "BUS_A", "role": "RREADY" } },
	{ "name": "s_axi_BUS_A_RDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "BUS_A", "role": "RDATA" } },
	{ "name": "s_axi_BUS_A_RRESP", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "BUS_A", "role": "RRESP" } },
	{ "name": "s_axi_BUS_A_BVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "BUS_A", "role": "BVALID" } },
	{ "name": "s_axi_BUS_A_BREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "BUS_A", "role": "BREADY" } },
	{ "name": "s_axi_BUS_A_BRESP", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "BUS_A", "role": "BRESP" } }, 
 	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst_n", "role": "default" }} , 
 	{ "name": "m_axi_memory_inout_AWVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "memory_inout", "role": "AWVALID" }} , 
 	{ "name": "m_axi_memory_inout_AWREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "memory_inout", "role": "AWREADY" }} , 
 	{ "name": "m_axi_memory_inout_AWADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "memory_inout", "role": "AWADDR" }} , 
 	{ "name": "m_axi_memory_inout_AWID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "memory_inout", "role": "AWID" }} , 
 	{ "name": "m_axi_memory_inout_AWLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "memory_inout", "role": "AWLEN" }} , 
 	{ "name": "m_axi_memory_inout_AWSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "memory_inout", "role": "AWSIZE" }} , 
 	{ "name": "m_axi_memory_inout_AWBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "memory_inout", "role": "AWBURST" }} , 
 	{ "name": "m_axi_memory_inout_AWLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "memory_inout", "role": "AWLOCK" }} , 
 	{ "name": "m_axi_memory_inout_AWCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "memory_inout", "role": "AWCACHE" }} , 
 	{ "name": "m_axi_memory_inout_AWPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "memory_inout", "role": "AWPROT" }} , 
 	{ "name": "m_axi_memory_inout_AWQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "memory_inout", "role": "AWQOS" }} , 
 	{ "name": "m_axi_memory_inout_AWREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "memory_inout", "role": "AWREGION" }} , 
 	{ "name": "m_axi_memory_inout_AWUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "memory_inout", "role": "AWUSER" }} , 
 	{ "name": "m_axi_memory_inout_WVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "memory_inout", "role": "WVALID" }} , 
 	{ "name": "m_axi_memory_inout_WREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "memory_inout", "role": "WREADY" }} , 
 	{ "name": "m_axi_memory_inout_WDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "memory_inout", "role": "WDATA" }} , 
 	{ "name": "m_axi_memory_inout_WSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "memory_inout", "role": "WSTRB" }} , 
 	{ "name": "m_axi_memory_inout_WLAST", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "memory_inout", "role": "WLAST" }} , 
 	{ "name": "m_axi_memory_inout_WID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "memory_inout", "role": "WID" }} , 
 	{ "name": "m_axi_memory_inout_WUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "memory_inout", "role": "WUSER" }} , 
 	{ "name": "m_axi_memory_inout_ARVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "memory_inout", "role": "ARVALID" }} , 
 	{ "name": "m_axi_memory_inout_ARREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "memory_inout", "role": "ARREADY" }} , 
 	{ "name": "m_axi_memory_inout_ARADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "memory_inout", "role": "ARADDR" }} , 
 	{ "name": "m_axi_memory_inout_ARID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "memory_inout", "role": "ARID" }} , 
 	{ "name": "m_axi_memory_inout_ARLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "memory_inout", "role": "ARLEN" }} , 
 	{ "name": "m_axi_memory_inout_ARSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "memory_inout", "role": "ARSIZE" }} , 
 	{ "name": "m_axi_memory_inout_ARBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "memory_inout", "role": "ARBURST" }} , 
 	{ "name": "m_axi_memory_inout_ARLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "memory_inout", "role": "ARLOCK" }} , 
 	{ "name": "m_axi_memory_inout_ARCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "memory_inout", "role": "ARCACHE" }} , 
 	{ "name": "m_axi_memory_inout_ARPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "memory_inout", "role": "ARPROT" }} , 
 	{ "name": "m_axi_memory_inout_ARQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "memory_inout", "role": "ARQOS" }} , 
 	{ "name": "m_axi_memory_inout_ARREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "memory_inout", "role": "ARREGION" }} , 
 	{ "name": "m_axi_memory_inout_ARUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "memory_inout", "role": "ARUSER" }} , 
 	{ "name": "m_axi_memory_inout_RVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "memory_inout", "role": "RVALID" }} , 
 	{ "name": "m_axi_memory_inout_RREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "memory_inout", "role": "RREADY" }} , 
 	{ "name": "m_axi_memory_inout_RDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "memory_inout", "role": "RDATA" }} , 
 	{ "name": "m_axi_memory_inout_RLAST", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "memory_inout", "role": "RLAST" }} , 
 	{ "name": "m_axi_memory_inout_RID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "memory_inout", "role": "RID" }} , 
 	{ "name": "m_axi_memory_inout_RUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "memory_inout", "role": "RUSER" }} , 
 	{ "name": "m_axi_memory_inout_RRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "memory_inout", "role": "RRESP" }} , 
 	{ "name": "m_axi_memory_inout_BVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "memory_inout", "role": "BVALID" }} , 
 	{ "name": "m_axi_memory_inout_BREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "memory_inout", "role": "BREADY" }} , 
 	{ "name": "m_axi_memory_inout_BRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "memory_inout", "role": "BRESP" }} , 
 	{ "name": "m_axi_memory_inout_BID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "memory_inout", "role": "BID" }} , 
 	{ "name": "m_axi_memory_inout_BUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "memory_inout", "role": "BUSER" }} , 
 	{ "name": "interrupt", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "interrupt", "role": "default" }}  ]}
set Spec2ImplPortList { 
	memory_inout { m_axi {  { m_axi_memory_inout_AWVALID VALID 1 1 }  { m_axi_memory_inout_AWREADY READY 0 1 }  { m_axi_memory_inout_AWADDR ADDR 1 32 }  { m_axi_memory_inout_AWID ID 1 1 }  { m_axi_memory_inout_AWLEN LEN 1 8 }  { m_axi_memory_inout_AWSIZE SIZE 1 3 }  { m_axi_memory_inout_AWBURST BURST 1 2 }  { m_axi_memory_inout_AWLOCK LOCK 1 2 }  { m_axi_memory_inout_AWCACHE CACHE 1 4 }  { m_axi_memory_inout_AWPROT PROT 1 3 }  { m_axi_memory_inout_AWQOS QOS 1 4 }  { m_axi_memory_inout_AWREGION REGION 1 4 }  { m_axi_memory_inout_AWUSER USER 1 1 }  { m_axi_memory_inout_WVALID VALID 1 1 }  { m_axi_memory_inout_WREADY READY 0 1 }  { m_axi_memory_inout_WDATA DATA 1 32 }  { m_axi_memory_inout_WSTRB STRB 1 4 }  { m_axi_memory_inout_WLAST LAST 1 1 }  { m_axi_memory_inout_WID ID 1 1 }  { m_axi_memory_inout_WUSER USER 1 1 }  { m_axi_memory_inout_ARVALID VALID 1 1 }  { m_axi_memory_inout_ARREADY READY 0 1 }  { m_axi_memory_inout_ARADDR ADDR 1 32 }  { m_axi_memory_inout_ARID ID 1 1 }  { m_axi_memory_inout_ARLEN LEN 1 8 }  { m_axi_memory_inout_ARSIZE SIZE 1 3 }  { m_axi_memory_inout_ARBURST BURST 1 2 }  { m_axi_memory_inout_ARLOCK LOCK 1 2 }  { m_axi_memory_inout_ARCACHE CACHE 1 4 }  { m_axi_memory_inout_ARPROT PROT 1 3 }  { m_axi_memory_inout_ARQOS QOS 1 4 }  { m_axi_memory_inout_ARREGION REGION 1 4 }  { m_axi_memory_inout_ARUSER USER 1 1 }  { m_axi_memory_inout_RVALID VALID 0 1 }  { m_axi_memory_inout_RREADY READY 1 1 }  { m_axi_memory_inout_RDATA DATA 0 32 }  { m_axi_memory_inout_RLAST LAST 0 1 }  { m_axi_memory_inout_RID ID 0 1 }  { m_axi_memory_inout_RUSER USER 0 1 }  { m_axi_memory_inout_RRESP RESP 0 2 }  { m_axi_memory_inout_BVALID VALID 0 1 }  { m_axi_memory_inout_BREADY READY 1 1 }  { m_axi_memory_inout_BRESP RESP 0 2 }  { m_axi_memory_inout_BID ID 0 1 }  { m_axi_memory_inout_BUSER USER 0 1 } } }
}

# RTL port scheduling information:
set fifoSchedulingInfoList { 
}

# RTL bus port read request latency information:
set busReadReqLatencyList { 
	{ memory_inout 5 }
}

# RTL bus port write response latency information:
set busWriteResLatencyList { 
	{ memory_inout 5 }
}

# RTL array port load latency information:
set memoryLoadLatencyList { 
}

set moduleName foo_foo_user
set isCombinational 0
set isDatapathOnly 0
set isPipelined 0
set pipeline_type none
set FunctionProtocol ap_ctrl_hs
set isOneStateSeq 0
set C_modelName {foo_foo_user}
set C_modelType { void 0 }
set C_modelArgList { 
	{ block_in_int float 32 regular {array 5 { 1 3 } 1 1 }  }
	{ x_in_in_int float 32 regular {array 5 { 1 3 } 1 1 }  }
	{ y_out_out_int float 32 regular {array 5 { 0 3 } 0 1 }  }
}
set C_modelArgMapList {[ 
	{ "Name" : "block_in_int", "interface" : "memory", "bitwidth" : 32 ,"direction" : "READONLY" } , 
 	{ "Name" : "x_in_in_int", "interface" : "memory", "bitwidth" : 32 ,"direction" : "READONLY" } , 
 	{ "Name" : "y_out_out_int", "interface" : "memory", "bitwidth" : 32 ,"direction" : "WRITEONLY" } ]}
# RTL Port declarations: 
set portNum 16
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ block_in_int_address0 sc_out sc_lv 3 signal 0 } 
	{ block_in_int_ce0 sc_out sc_logic 1 signal 0 } 
	{ block_in_int_q0 sc_in sc_lv 32 signal 0 } 
	{ x_in_in_int_address0 sc_out sc_lv 3 signal 1 } 
	{ x_in_in_int_ce0 sc_out sc_logic 1 signal 1 } 
	{ x_in_in_int_q0 sc_in sc_lv 32 signal 1 } 
	{ y_out_out_int_address0 sc_out sc_lv 3 signal 2 } 
	{ y_out_out_int_ce0 sc_out sc_logic 1 signal 2 } 
	{ y_out_out_int_we0 sc_out sc_logic 1 signal 2 } 
	{ y_out_out_int_d0 sc_out sc_lv 32 signal 2 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "block_in_int_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "block_in_int", "role": "address0" }} , 
 	{ "name": "block_in_int_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "block_in_int", "role": "ce0" }} , 
 	{ "name": "block_in_int_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "block_in_int", "role": "q0" }} , 
 	{ "name": "x_in_in_int_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "x_in_in_int", "role": "address0" }} , 
 	{ "name": "x_in_in_int_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "x_in_in_int", "role": "ce0" }} , 
 	{ "name": "x_in_in_int_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "x_in_in_int", "role": "q0" }} , 
 	{ "name": "y_out_out_int_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "y_out_out_int", "role": "address0" }} , 
 	{ "name": "y_out_out_int_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "y_out_out_int", "role": "ce0" }} , 
 	{ "name": "y_out_out_int_we0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "y_out_out_int", "role": "we0" }} , 
 	{ "name": "y_out_out_int_d0", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "y_out_out_int", "role": "d0" }}  ]}
set Spec2ImplPortList { 
	block_in_int { ap_memory {  { block_in_int_address0 mem_address 1 3 }  { block_in_int_ce0 mem_ce 1 1 }  { block_in_int_q0 mem_dout 0 32 } } }
	x_in_in_int { ap_memory {  { x_in_in_int_address0 mem_address 1 3 }  { x_in_in_int_ce0 mem_ce 1 1 }  { x_in_in_int_q0 mem_dout 0 32 } } }
	y_out_out_int { ap_memory {  { y_out_out_int_address0 mem_address 1 3 }  { y_out_out_int_ce0 mem_ce 1 1 }  { y_out_out_int_we0 mem_we 1 1 }  { y_out_out_int_d0 mem_din 1 32 } } }
}

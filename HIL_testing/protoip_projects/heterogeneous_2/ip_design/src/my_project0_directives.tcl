############################################################
## This file is generated automatically by Vivado HLS.
## Please DO NOT edit it.
## Copyright (C) 2015 Xilinx Inc. All rights reserved.
############################################################
set_directive_interface -mode m_axi -depth 431 "foo" memory_inout
set_directive_interface -mode s_axilite -bundle BUS_A "foo"
set_directive_interface -mode s_axilite -register -bundle BUS_A "foo" byte_init_in_offset
set_directive_interface -mode s_axilite -register -bundle BUS_A "foo" byte_sc_in_in_offset
set_directive_interface -mode s_axilite -register -bundle BUS_A "foo" byte_block_in_offset
set_directive_interface -mode s_axilite -register -bundle BUS_A "foo" byte_out_block_in_offset
set_directive_interface -mode s_axilite -register -bundle BUS_A "foo" byte_v_in_in_offset
set_directive_interface -mode s_axilite -register -bundle BUS_A "foo" byte_v_out_out_offset
set_directive_interface -mode s_axilite -register -bundle BUS_A "foo" byte_sc_out_out_offset
set_directive_inline -off "foo_user"
set_directive_pipeline "foo/input_cast_loop_init"
set_directive_pipeline "foo/input_cast_loop_sc_in"
set_directive_pipeline "foo/input_cast_loop_block"
set_directive_pipeline "foo/input_cast_loop_out_block"
set_directive_pipeline "foo/input_cast_loop_v_in"
set_directive_pipeline "foo/output_cast_loop_v_out"
set_directive_pipeline "foo/output_cast_loop_sc_out"


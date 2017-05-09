############################################################
## This file is generated automatically by Vivado HLS.
## Please DO NOT edit it.
## Copyright (C) 1986-2017 Xilinx, Inc. All Rights Reserved.
############################################################
set_directive_interface -mode m_axi -depth 1748 "foo" memory_inout
set_directive_interface -mode s_axilite -bundle BUS_A "foo"
set_directive_interface -mode s_axilite -register -bundle BUS_A "foo" byte_minres_data_in_offset
set_directive_interface -mode s_axilite -register -bundle BUS_A "foo" byte_block_in_offset
set_directive_interface -mode s_axilite -register -bundle BUS_A "foo" byte_out_block_in_offset
set_directive_interface -mode s_axilite -register -bundle BUS_A "foo" byte_x_in_in_offset
set_directive_interface -mode s_axilite -register -bundle BUS_A "foo" byte_y_out_out_offset
set_directive_inline -off "foo_user"
set_directive_pipeline "foo/input_cast_loop_minres_data"
set_directive_pipeline "foo/input_cast_loop_block"
set_directive_pipeline "foo/input_cast_loop_out_block"
set_directive_pipeline "foo/input_cast_loop_x_in"
set_directive_pipeline "foo/output_cast_loop_y_out"





























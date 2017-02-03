; ModuleID = '/home/bkhusain/Desktop/improved_NMPC_SOC/HIL_testing/protoip_projects/heterogeneous_0/ip_design/build/prj/my_project0/solution1/.autopilot/db/a.o.3.bc'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@p_str1804 = private unnamed_addr constant [10 x i8] c"s_axilite\00", align 1 ; [#uses=4 type=[10 x i8]*]
@p_str1805 = private unnamed_addr constant [6 x i8] c"BUS_A\00", align 1 ; [#uses=4 type=[6 x i8]*]
@p_str1806 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1 ; [#uses=11 type=[1 x i8]*]
@p_str1807 = private unnamed_addr constant [6 x i8] c"m_axi\00", align 1 ; [#uses=1 type=[6 x i8]*]
@block_in_int = internal global [5 x float] zeroinitializer, align 16 ; [#uses=2 type=[5 x float]*]
@x_in_in_int = internal global [5 x float] zeroinitializer, align 16 ; [#uses=2 type=[5 x float]*]
@llvm_global_ctors_0 = appending global [2 x i32] [i32 65535, i32 65535] ; [#uses=0 type=[2 x i32]*]
@llvm_global_ctors_1 = appending global [2 x void ()*] [void ()* @_GLOBAL__I_a, void ()* @_GLOBAL__I_a1967] ; [#uses=0 type=[2 x void ()*]*]
@p_str18051897 = private unnamed_addr constant [6 x i8] c"alg_0\00", align 1 ; [#uses=3 type=[6 x i8]*]
@p_str18061898 = private unnamed_addr constant [11 x i8] c"loop_block\00", align 1 ; [#uses=1 type=[11 x i8]*]
@p_str18071899 = private unnamed_addr constant [10 x i8] c"loop_x_in\00", align 1 ; [#uses=1 type=[10 x i8]*]
@foo_str = internal unnamed_addr constant [4 x i8] c"foo\00" ; [#uses=1 type=[4 x i8]*]
@memcpy_OC_foo_IC_unsigned_AC_i = internal unnamed_addr constant [97 x i8] c"memcpy.foo(unsigned int, unsigned int, unsigned int, float volatile*)::block_in_int.memory_inout\00" ; [#uses=1 type=[97 x i8]*]
@p_str1 = internal unnamed_addr constant [1 x i8] zeroinitializer ; [#uses=1 type=[1 x i8]*]
@burstread_OC_region_str = internal unnamed_addr constant [17 x i8] c"burstread.region\00" ; [#uses=4 type=[17 x i8]*]
@memcpy_OC_foo_IC_unsigned_AC_i_1 = internal unnamed_addr constant [96 x i8] c"memcpy.foo(unsigned int, unsigned int, unsigned int, float volatile*)::x_in_in_int.memory_inout\00" ; [#uses=1 type=[96 x i8]*]
@p_str2 = internal unnamed_addr constant [1 x i8] zeroinitializer ; [#uses=1 type=[1 x i8]*]
@memcpy_OC_memory_inout_OC_y_ou = internal unnamed_addr constant [38 x i8] c"memcpy.memory_inout.y_out_out_int.gep\00" ; [#uses=1 type=[38 x i8]*]
@p_str15 = internal unnamed_addr constant [1 x i8] zeroinitializer ; [#uses=1 type=[1 x i8]*]
@burstwrite_OC_region_str = internal unnamed_addr constant [18 x i8] c"burstwrite.region\00" ; [#uses=2 type=[18 x i8]*]

; [#uses=0]
define void @foo(i32 %byte_block_in_offset, i32 %byte_x_in_in_offset, i32 %byte_y_out_out_offset, float* %memory_inout) nounwind uwtable {
  call void (...)* @_ssdm_op_SpecBitsMap(i32 %byte_block_in_offset) nounwind, !map !7
  call void (...)* @_ssdm_op_SpecBitsMap(i32 %byte_x_in_in_offset) nounwind, !map !13
  call void (...)* @_ssdm_op_SpecBitsMap(i32 %byte_y_out_out_offset) nounwind, !map !17
  call void (...)* @_ssdm_op_SpecBitsMap(float* %memory_inout) nounwind, !map !21
  call void (...)* @_ssdm_op_SpecTopModule([4 x i8]* @foo_str) nounwind
  %byte_y_out_out_offset_read = call i32 @_ssdm_op_Read.s_axilite.i32(i32 %byte_y_out_out_offset) nounwind ; [#uses=2 type=i32]
  call void @llvm.dbg.value(metadata !{i32 %byte_y_out_out_offset_read}, i64 0, metadata !27), !dbg !40 ; [debug line = 19:14] [debug variable = byte_y_out_out_offset]
  %byte_x_in_in_offset_read = call i32 @_ssdm_op_Read.s_axilite.i32(i32 %byte_x_in_in_offset) nounwind ; [#uses=2 type=i32]
  call void @llvm.dbg.value(metadata !{i32 %byte_x_in_in_offset_read}, i64 0, metadata !41), !dbg !42 ; [debug line = 18:14] [debug variable = byte_x_in_in_offset]
  %byte_block_in_offset_read = call i32 @_ssdm_op_Read.s_axilite.i32(i32 %byte_block_in_offset) nounwind ; [#uses=2 type=i32]
  call void @llvm.dbg.value(metadata !{i32 %byte_block_in_offset_read}, i64 0, metadata !43), !dbg !44 ; [debug line = 17:14] [debug variable = byte_block_in_offset]
  %y_out_out_int = alloca [5 x float], align 16   ; [#uses=2 type=[5 x float]*]
  call void @llvm.dbg.value(metadata !{i32 %byte_block_in_offset}, i64 0, metadata !43), !dbg !44 ; [debug line = 17:14] [debug variable = byte_block_in_offset]
  call void @llvm.dbg.value(metadata !{i32 %byte_x_in_in_offset}, i64 0, metadata !41), !dbg !42 ; [debug line = 18:14] [debug variable = byte_x_in_in_offset]
  call void @llvm.dbg.value(metadata !{i32 %byte_y_out_out_offset}, i64 0, metadata !27), !dbg !40 ; [debug line = 19:14] [debug variable = byte_y_out_out_offset]
  call void @llvm.dbg.value(metadata !{float* %memory_inout}, i64 0, metadata !45), !dbg !46 ; [debug line = 20:29] [debug variable = memory_inout]
  call void (...)* @_ssdm_op_SpecInterface(i32 %byte_y_out_out_offset, [10 x i8]* @p_str1804, i32 1, i32 1, i32 0, i32 0, [6 x i8]* @p_str1805, [1 x i8]* @p_str1806, [1 x i8]* @p_str1806) nounwind, !dbg !47 ; [debug line = 22:1]
  call void (...)* @_ssdm_op_SpecInterface(i32 %byte_x_in_in_offset, [10 x i8]* @p_str1804, i32 1, i32 1, i32 0, i32 0, [6 x i8]* @p_str1805, [1 x i8]* @p_str1806, [1 x i8]* @p_str1806) nounwind, !dbg !47 ; [debug line = 22:1]
  call void (...)* @_ssdm_op_SpecInterface(i32 %byte_block_in_offset, [10 x i8]* @p_str1804, i32 1, i32 1, i32 0, i32 0, [6 x i8]* @p_str1805, [1 x i8]* @p_str1806, [1 x i8]* @p_str1806) nounwind, !dbg !47 ; [debug line = 22:1]
  call void (...)* @_ssdm_op_SpecInterface(i32 0, [10 x i8]* @p_str1804, i32 0, i32 0, i32 0, i32 0, [6 x i8]* @p_str1805, [1 x i8]* @p_str1806, [1 x i8]* @p_str1806) nounwind, !dbg !47 ; [debug line = 22:1]
  call void (...)* @_ssdm_op_SpecInterface(float* %memory_inout, [6 x i8]* @p_str1807, i32 0, i32 0, i32 0, i32 15, [1 x i8]* @p_str1806, [1 x i8]* @p_str1806, [1 x i8]* @p_str1806) nounwind, !dbg !47 ; [debug line = 22:1]
  %tmp = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %byte_block_in_offset_read, i32 31), !dbg !49 ; [#uses=1 type=i1] [debug line = 72:2]
  br i1 %tmp, label %._crit_edge, label %1, !dbg !49 ; [debug line = 72:2]

; <label>:1                                       ; preds = %0
  %tmp_1_cast = call i30 @_ssdm_op_PartSelect.i30.i32.i32.i32(i32 %byte_block_in_offset_read, i32 2, i32 31) ; [#uses=1 type=i30]
  %tmp_1 = zext i30 %tmp_1_cast to i64, !dbg !50  ; [#uses=1 type=i64] [debug line = 74:3]
  %memory_inout_addr = getelementptr float* %memory_inout, i64 %tmp_1, !dbg !50 ; [#uses=2 type=float*] [debug line = 74:3]
  %p_rd_req = call i1 @_ssdm_op_ReadReq.m_axi.floatP(float* %memory_inout_addr, i32 5) nounwind, !dbg !50 ; [#uses=0 type=i1] [debug line = 74:3]
  br label %burst.rd.header

burst.rd.header:                                  ; preds = %burst.rd.body, %1
  %indvar = phi i3 [ 0, %1 ], [ %indvar_next, %burst.rd.body ] ; [#uses=3 type=i3]
  %exitcond = icmp eq i3 %indvar, -3              ; [#uses=1 type=i1]
  %empty = call i32 (...)* @_ssdm_op_SpecLoopTripCount(i64 5, i64 5, i64 5) nounwind ; [#uses=0 type=i32]
  %indvar_next = add i3 %indvar, 1                ; [#uses=1 type=i3]
  br i1 %exitcond, label %._crit_edge, label %burst.rd.body

burst.rd.body:                                    ; preds = %burst.rd.header
  %burstread_rbegin = call i32 (...)* @_ssdm_op_SpecRegionBegin([17 x i8]* @burstread_OC_region_str) nounwind ; [#uses=1 type=i32]
  %empty_4 = call i32 (...)* @_ssdm_op_SpecPipeline(i32 1, i32 1, i32 1, i32 0, [1 x i8]* @p_str1) nounwind ; [#uses=0 type=i32]
  call void (...)* @_ssdm_op_SpecLoopName([97 x i8]* @memcpy_OC_foo_IC_unsigned_AC_i)
  %memory_inout_addr_read = call float @_ssdm_op_Read.m_axi.floatP(float* %memory_inout_addr) nounwind, !dbg !50 ; [#uses=1 type=float] [debug line = 74:3]
  %tmp_3 = zext i3 %indvar to i64, !dbg !50       ; [#uses=1 type=i64] [debug line = 74:3]
  %block_in_int_addr = getelementptr [5 x float]* @block_in_int, i64 0, i64 %tmp_3, !dbg !50 ; [#uses=1 type=float*] [debug line = 74:3]
  store float %memory_inout_addr_read, float* %block_in_int_addr, align 4, !dbg !50 ; [debug line = 74:3]
  %burstread_rend = call i32 (...)* @_ssdm_op_SpecRegionEnd([17 x i8]* @burstread_OC_region_str, i32 %burstread_rbegin) nounwind ; [#uses=0 type=i32]
  br label %burst.rd.header

._crit_edge:                                      ; preds = %burst.rd.header, %0
  %tmp_2 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %byte_x_in_in_offset_read, i32 31), !dbg !52 ; [#uses=1 type=i1] [debug line = 99:2]
  br i1 %tmp_2, label %._crit_edge1, label %2, !dbg !52 ; [debug line = 99:2]

; <label>:2                                       ; preds = %._crit_edge
  %tmp_5_cast = call i30 @_ssdm_op_PartSelect.i30.i32.i32.i32(i32 %byte_x_in_in_offset_read, i32 2, i32 31) ; [#uses=1 type=i30]
  %tmp_4 = zext i30 %tmp_5_cast to i64, !dbg !53  ; [#uses=1 type=i64] [debug line = 101:3]
  %memory_inout_addr_1 = getelementptr float* %memory_inout, i64 %tmp_4, !dbg !53 ; [#uses=2 type=float*] [debug line = 101:3]
  %p_rd_req1 = call i1 @_ssdm_op_ReadReq.m_axi.floatP(float* %memory_inout_addr_1, i32 5) nounwind, !dbg !53 ; [#uses=0 type=i1] [debug line = 101:3]
  br label %burst.rd.header6

burst.rd.header6:                                 ; preds = %burst.rd.body7, %2
  %indvar8 = phi i3 [ 0, %2 ], [ %indvar_next9, %burst.rd.body7 ] ; [#uses=3 type=i3]
  %exitcond1 = icmp eq i3 %indvar8, -3            ; [#uses=1 type=i1]
  %empty_5 = call i32 (...)* @_ssdm_op_SpecLoopTripCount(i64 5, i64 5, i64 5) nounwind ; [#uses=0 type=i32]
  %indvar_next9 = add i3 %indvar8, 1              ; [#uses=1 type=i3]
  br i1 %exitcond1, label %._crit_edge1, label %burst.rd.body7

burst.rd.body7:                                   ; preds = %burst.rd.header6
  %burstread_rbegin1 = call i32 (...)* @_ssdm_op_SpecRegionBegin([17 x i8]* @burstread_OC_region_str) nounwind ; [#uses=1 type=i32]
  %empty_6 = call i32 (...)* @_ssdm_op_SpecPipeline(i32 1, i32 1, i32 1, i32 0, [1 x i8]* @p_str2) nounwind ; [#uses=0 type=i32]
  call void (...)* @_ssdm_op_SpecLoopName([96 x i8]* @memcpy_OC_foo_IC_unsigned_AC_i_1)
  %memory_inout_addr_1_read = call float @_ssdm_op_Read.m_axi.floatP(float* %memory_inout_addr_1) nounwind, !dbg !53 ; [#uses=1 type=float] [debug line = 101:3]
  %tmp_7 = zext i3 %indvar8 to i64, !dbg !53      ; [#uses=1 type=i64] [debug line = 101:3]
  %x_in_in_int_addr = getelementptr [5 x float]* @x_in_in_int, i64 0, i64 %tmp_7, !dbg !53 ; [#uses=1 type=float*] [debug line = 101:3]
  store float %memory_inout_addr_1_read, float* %x_in_in_int_addr, align 4, !dbg !53 ; [debug line = 101:3]
  %burstread_rend16 = call i32 (...)* @_ssdm_op_SpecRegionEnd([17 x i8]* @burstread_OC_region_str, i32 %burstread_rbegin1) nounwind ; [#uses=0 type=i32]
  br label %burst.rd.header6

._crit_edge1:                                     ; preds = %burst.rd.header6, %._crit_edge
  call fastcc void @foo_foo_user([5 x float]* @block_in_int, [5 x float]* @x_in_in_int, [5 x float]* %y_out_out_int) nounwind, !dbg !55 ; [debug line = 115:16]
  %tmp_5 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %byte_y_out_out_offset_read, i32 31), !dbg !56 ; [#uses=1 type=i1] [debug line = 136:2]
  br i1 %tmp_5, label %._crit_edge2, label %3, !dbg !56 ; [debug line = 136:2]

; <label>:3                                       ; preds = %._crit_edge1
  %tmp_9_cast = call i30 @_ssdm_op_PartSelect.i30.i32.i32.i32(i32 %byte_y_out_out_offset_read, i32 2, i32 31) ; [#uses=1 type=i30]
  %tmp_6 = zext i30 %tmp_9_cast to i64, !dbg !57  ; [#uses=1 type=i64] [debug line = 138:3]
  %memory_inout_addr_2 = getelementptr float* %memory_inout, i64 %tmp_6, !dbg !57 ; [#uses=3 type=float*] [debug line = 138:3]
  %p_wr_req = call i1 @_ssdm_op_WriteReq.m_axi.floatP(float* %memory_inout_addr_2, i32 5) nounwind, !dbg !57 ; [#uses=0 type=i1] [debug line = 138:3]
  br label %burst.wr.header

burst.wr.header:                                  ; preds = %burst.wr.body, %3
  %indvar1 = phi i3 [ 0, %3 ], [ %indvar_next1, %burst.wr.body ] ; [#uses=3 type=i3]
  %exitcond2 = icmp eq i3 %indvar1, -3            ; [#uses=1 type=i1]
  %empty_7 = call i32 (...)* @_ssdm_op_SpecLoopTripCount(i64 5, i64 5, i64 5) nounwind ; [#uses=0 type=i32]
  %indvar_next1 = add i3 %indvar1, 1              ; [#uses=1 type=i3]
  br i1 %exitcond2, label %._crit_edge2.loopexit, label %burst.wr.body

burst.wr.body:                                    ; preds = %burst.wr.header
  %burstwrite_rbegin = call i32 (...)* @_ssdm_op_SpecRegionBegin([18 x i8]* @burstwrite_OC_region_str) nounwind ; [#uses=1 type=i32]
  %empty_8 = call i32 (...)* @_ssdm_op_SpecPipeline(i32 1, i32 1, i32 1, i32 0, [1 x i8]* @p_str15) nounwind ; [#uses=0 type=i32]
  call void (...)* @_ssdm_op_SpecLoopName([38 x i8]* @memcpy_OC_memory_inout_OC_y_ou)
  %tmp_s = zext i3 %indvar1 to i64, !dbg !57      ; [#uses=1 type=i64] [debug line = 138:3]
  %y_out_out_int_addr = getelementptr [5 x float]* %y_out_out_int, i64 0, i64 %tmp_s, !dbg !57 ; [#uses=1 type=float*] [debug line = 138:3]
  %y_out_out_int_load = load float* %y_out_out_int_addr, align 4, !dbg !57 ; [#uses=1 type=float] [debug line = 138:3]
  call void @_ssdm_op_Write.m_axi.floatP(float* %memory_inout_addr_2, float %y_out_out_int_load) nounwind, !dbg !57 ; [debug line = 138:3]
  %burstwrite_rend = call i32 (...)* @_ssdm_op_SpecRegionEnd([18 x i8]* @burstwrite_OC_region_str, i32 %burstwrite_rbegin) nounwind ; [#uses=0 type=i32]
  br label %burst.wr.header

._crit_edge2.loopexit:                            ; preds = %burst.wr.header
  %p_wr_resp = call i1 @_ssdm_op_WriteResp.m_axi.floatP(float* %memory_inout_addr_2) nounwind, !dbg !57 ; [#uses=0 type=i1] [debug line = 138:3]
  br label %._crit_edge2

._crit_edge2:                                     ; preds = %._crit_edge2.loopexit, %._crit_edge1
  ret void, !dbg !59                              ; [debug line = 146:1]
}

; [#uses=5]
define weak void @_ssdm_op_SpecInterface(...) nounwind {
entry:
  ret void
}

; [#uses=6]
define weak void @_ssdm_op_SpecLoopName(...) nounwind {
entry:
  ret void
}

; [#uses=13]
declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

; [#uses=1]
define weak void @_ssdm_op_SpecTopModule(...) {
entry:
  ret void
}

; [#uses=1]
declare void @_GLOBAL__I_a() nounwind section ".text.startup"

; [#uses=1]
declare void @_GLOBAL__I_a1967() nounwind section ".text.startup"

; [#uses=3]
define weak i32 @_ssdm_op_SpecPipeline(...) {
entry:
  ret i32 0
}

; [#uses=4]
define weak i32 @_ssdm_op_SpecRegionBegin(...) {
entry:
  ret i32 0
}

; [#uses=4]
define weak i32 @_ssdm_op_SpecRegionEnd(...) {
entry:
  ret i32 0
}

; [#uses=1]
define internal fastcc void @foo_foo_user([5 x float]* nocapture %block_in_int, [5 x float]* nocapture %x_in_in_int, [5 x float]* nocapture %y_out_out_int) {
  call void @llvm.dbg.value(metadata !{[5 x float]* %block_in_int}, i64 0, metadata !60), !dbg !74 ; [debug line = 11:32] [debug variable = block_in_int]
  call void @llvm.dbg.value(metadata !{[5 x float]* %x_in_in_int}, i64 0, metadata !75), !dbg !77 ; [debug line = 12:20] [debug variable = x_in_in_int]
  call void @llvm.dbg.value(metadata !{[5 x float]* %y_out_out_int}, i64 0, metadata !78), !dbg !80 ; [debug line = 13:22] [debug variable = y_out_out_int]
  br label %1, !dbg !81                           ; [debug line = 19:23]

; <label>:1                                       ; preds = %6, %0
  %i = phi i3 [ 0, %0 ], [ %i_1, %6 ]             ; [#uses=3 type=i3]
  %exitcond2 = icmp eq i3 %i, -3, !dbg !81        ; [#uses=1 type=i1] [debug line = 19:23]
  %empty = call i32 (...)* @_ssdm_op_SpecLoopTripCount(i64 5, i64 5, i64 5) ; [#uses=0 type=i32]
  %i_1 = add i3 %i, 1, !dbg !84                   ; [#uses=1 type=i3] [debug line = 19:31]
  br i1 %exitcond2, label %7, label %2, !dbg !81  ; [debug line = 19:23]

; <label>:2                                       ; preds = %1
  call void (...)* @_ssdm_op_SpecLoopName([6 x i8]* @p_str18051897) nounwind, !dbg !85 ; [debug line = 20:3]
  %tmp_1 = call i32 (...)* @_ssdm_op_SpecRegionBegin([6 x i8]* @p_str18051897), !dbg !85 ; [#uses=1 type=i32] [debug line = 20:3]
  %tmp = zext i3 %i to i64, !dbg !87              ; [#uses=1 type=i64] [debug line = 21:3]
  %y_out_out_int_addr = getelementptr [5 x float]* %y_out_out_int, i64 0, i64 %tmp, !dbg !87 ; [#uses=2 type=float*] [debug line = 21:3]
  br label %3, !dbg !88                           ; [debug line = 22:35]

; <label>:3                                       ; preds = %4, %2
  %storemerge = phi float [ 0.000000e+00, %2 ], [ %tmp_3, %4 ] ; [#uses=3 type=float]
  %i_block = phi i3 [ 0, %2 ], [ %i_block_1, %4 ] ; [#uses=3 type=i3]
  store float %storemerge, float* %y_out_out_int_addr, align 4, !dbg !90 ; [debug line = 24:4]
  %exitcond1 = icmp eq i3 %i_block, -3, !dbg !88  ; [#uses=1 type=i1] [debug line = 22:35]
  %empty_9 = call i32 (...)* @_ssdm_op_SpecLoopTripCount(i64 5, i64 5, i64 5) ; [#uses=0 type=i32]
  %i_block_1 = add i3 %i_block, 1, !dbg !92       ; [#uses=1 type=i3] [debug line = 22:49]
  br i1 %exitcond1, label %.preheader, label %4, !dbg !88 ; [debug line = 22:35]

; <label>:4                                       ; preds = %3
  call void (...)* @_ssdm_op_SpecLoopName([11 x i8]* @p_str18061898) nounwind, !dbg !93 ; [debug line = 23:4]
  %tmp_2 = zext i3 %i_block to i64, !dbg !90      ; [#uses=1 type=i64] [debug line = 24:4]
  %block_in_int_addr = getelementptr [5 x float]* %block_in_int, i64 0, i64 %tmp_2, !dbg !90 ; [#uses=1 type=float*] [debug line = 24:4]
  %block_in_int_load = load float* %block_in_int_addr, align 4, !dbg !90 ; [#uses=1 type=float] [debug line = 24:4]
  %tmp_3 = fadd float %storemerge, %block_in_int_load, !dbg !90 ; [#uses=1 type=float] [debug line = 24:4]
  call void @llvm.dbg.value(metadata !{i3 %i_block_1}, i64 0, metadata !94), !dbg !92 ; [debug line = 22:49] [debug variable = i_block]
  br label %3, !dbg !92                           ; [debug line = 22:49]

.preheader:                                       ; preds = %5, %3
  %tmp_4 = phi float [ %tmp_6, %5 ], [ %storemerge, %3 ] ; [#uses=1 type=float]
  %i_x_in = phi i3 [ %i_x_in_1, %5 ], [ 0, %3 ]   ; [#uses=3 type=i3]
  %exitcond = icmp eq i3 %i_x_in, -3, !dbg !96    ; [#uses=1 type=i1] [debug line = 26:33]
  %empty_10 = call i32 (...)* @_ssdm_op_SpecLoopTripCount(i64 5, i64 5, i64 5) ; [#uses=0 type=i32]
  %i_x_in_1 = add i3 %i_x_in, 1, !dbg !98         ; [#uses=1 type=i3] [debug line = 26:46]
  br i1 %exitcond, label %6, label %5, !dbg !96   ; [debug line = 26:33]

; <label>:5                                       ; preds = %.preheader
  call void (...)* @_ssdm_op_SpecLoopName([10 x i8]* @p_str18071899) nounwind, !dbg !99 ; [debug line = 27:4]
  %tmp_5 = zext i3 %i_x_in to i64, !dbg !101      ; [#uses=1 type=i64] [debug line = 28:4]
  %x_in_in_int_addr = getelementptr [5 x float]* %x_in_in_int, i64 0, i64 %tmp_5, !dbg !101 ; [#uses=1 type=float*] [debug line = 28:4]
  %x_in_in_int_load = load float* %x_in_in_int_addr, align 4, !dbg !101 ; [#uses=1 type=float] [debug line = 28:4]
  %tmp_6 = fadd float %tmp_4, %x_in_in_int_load, !dbg !101 ; [#uses=2 type=float] [debug line = 28:4]
  store float %tmp_6, float* %y_out_out_int_addr, align 4, !dbg !101 ; [debug line = 28:4]
  call void @llvm.dbg.value(metadata !{i3 %i_x_in_1}, i64 0, metadata !102), !dbg !98 ; [debug line = 26:46] [debug variable = i_x_in]
  br label %.preheader, !dbg !98                  ; [debug line = 26:46]

; <label>:6                                       ; preds = %.preheader
  %empty_11 = call i32 (...)* @_ssdm_op_SpecRegionEnd([6 x i8]* @p_str18051897, i32 %tmp_1), !dbg !103 ; [#uses=0 type=i32] [debug line = 30:2]
  call void @llvm.dbg.value(metadata !{i3 %i_1}, i64 0, metadata !104), !dbg !84 ; [debug line = 19:31] [debug variable = i]
  br label %1, !dbg !84                           ; [debug line = 19:31]

; <label>:7                                       ; preds = %1
  ret void, !dbg !105                             ; [debug line = 32:1]
}

; [#uses=4]
define weak void @_ssdm_op_SpecBitsMap(...) {
entry:
  ret void
}

; [#uses=6]
define weak i32 @_ssdm_op_SpecLoopTripCount(...) {
entry:
  ret i32 0
}

; [#uses=3]
define weak i30 @_ssdm_op_PartSelect.i30.i32.i32.i32(i32, i32, i32) nounwind readnone {
entry:
  %empty = call i32 @llvm.part.select.i32(i32 %0, i32 %1, i32 %2) ; [#uses=1 type=i32]
  %empty_12 = trunc i32 %empty to i30             ; [#uses=1 type=i30]
  ret i30 %empty_12
}

; [#uses=2]
define weak i1 @_ssdm_op_ReadReq.m_axi.floatP(float*, i32) {
entry:
  ret i1 true
}

; [#uses=2]
define weak float @_ssdm_op_Read.m_axi.floatP(float*) {
entry:
  %empty = load float* %0                         ; [#uses=1 type=float]
  ret float %empty
}

; [#uses=1]
define weak i1 @_ssdm_op_WriteReq.m_axi.floatP(float*, i32) {
entry:
  ret i1 true
}

; [#uses=1]
define weak void @_ssdm_op_Write.m_axi.floatP(float*, float) {
entry:
  store float %1, float* %0
  ret void
}

; [#uses=1]
define weak i1 @_ssdm_op_WriteResp.m_axi.floatP(float*) {
entry:
  ret i1 true
}

; [#uses=3]
define weak i32 @_ssdm_op_Read.s_axilite.i32(i32) {
entry:
  ret i32 %0
}

; [#uses=3]
define weak i1 @_ssdm_op_BitSelect.i1.i32.i32(i32, i32) nounwind readnone {
entry:
  %empty = shl i32 1, %1                          ; [#uses=1 type=i32]
  %empty_13 = and i32 %0, %empty                  ; [#uses=1 type=i32]
  %empty_14 = icmp ne i32 %empty_13, 0            ; [#uses=1 type=i1]
  ret i1 %empty_14
}

; [#uses=1]
declare i32 @llvm.part.select.i32(i32, i32, i32) nounwind readnone

!hls.encrypted.func = !{}
!llvm.map.gv = !{!0}

!0 = metadata !{metadata !1, [2 x i32]* @llvm_global_ctors_0}
!1 = metadata !{metadata !2}
!2 = metadata !{i32 0, i32 31, metadata !3}
!3 = metadata !{metadata !4}
!4 = metadata !{metadata !"llvm.global_ctors.0", metadata !5, metadata !"", i32 0, i32 31}
!5 = metadata !{metadata !6}
!6 = metadata !{i32 0, i32 1, i32 1}
!7 = metadata !{metadata !8}
!8 = metadata !{i32 0, i32 31, metadata !9}
!9 = metadata !{metadata !10}
!10 = metadata !{metadata !"byte_block_in_offset", metadata !11, metadata !"unsigned int", i32 0, i32 31}
!11 = metadata !{metadata !12}
!12 = metadata !{i32 0, i32 0, i32 0}
!13 = metadata !{metadata !14}
!14 = metadata !{i32 0, i32 31, metadata !15}
!15 = metadata !{metadata !16}
!16 = metadata !{metadata !"byte_x_in_in_offset", metadata !11, metadata !"unsigned int", i32 0, i32 31}
!17 = metadata !{metadata !18}
!18 = metadata !{i32 0, i32 31, metadata !19}
!19 = metadata !{metadata !20}
!20 = metadata !{metadata !"byte_y_out_out_offset", metadata !11, metadata !"unsigned int", i32 0, i32 31}
!21 = metadata !{metadata !22}
!22 = metadata !{i32 0, i32 31, metadata !23}
!23 = metadata !{metadata !24}
!24 = metadata !{metadata !"memory_inout", metadata !25, metadata !"float", i32 0, i32 31}
!25 = metadata !{metadata !26}
!26 = metadata !{i32 0, i32 14, i32 1}
!27 = metadata !{i32 786689, metadata !28, metadata !"byte_y_out_out_offset", metadata !29, i32 50331667, metadata !32, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!28 = metadata !{i32 786478, i32 0, metadata !29, metadata !"foo", metadata !"foo", metadata !"_Z3foojjjPVf", metadata !29, i32 16, metadata !30, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (i32, i32, i32, float*)* @foo, null, null, metadata !38, i32 21} ; [ DW_TAG_subprogram ]
!29 = metadata !{i32 786473, metadata !"../../src/foo.cpp", metadata !"/home/bkhusain/Desktop/improved_NMPC_SOC/HIL_testing/protoip_projects/heterogeneous_0", null} ; [ DW_TAG_file_type ]
!30 = metadata !{i32 786453, i32 0, metadata !"", i32 0, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !31, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!31 = metadata !{null, metadata !32, metadata !32, metadata !32, metadata !34}
!32 = metadata !{i32 786454, null, metadata !"uint32_t", metadata !29, i32 51, i64 0, i64 0, i64 0, i32 0, metadata !33} ; [ DW_TAG_typedef ]
!33 = metadata !{i32 786468, null, metadata !"unsigned int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!34 = metadata !{i32 786447, null, metadata !"", null, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !35} ; [ DW_TAG_pointer_type ]
!35 = metadata !{i32 786485, null, metadata !"", null, i32 0, i64 0, i64 0, i64 0, i32 0, metadata !36} ; [ DW_TAG_volatile_type ]
!36 = metadata !{i32 786454, null, metadata !"data_t_memory", metadata !29, i32 53, i64 0, i64 0, i64 0, i32 0, metadata !37} ; [ DW_TAG_typedef ]
!37 = metadata !{i32 786468, null, metadata !"float", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 4} ; [ DW_TAG_base_type ]
!38 = metadata !{metadata !39}
!39 = metadata !{i32 786468}                      ; [ DW_TAG_base_type ]
!40 = metadata !{i32 19, i32 14, metadata !28, null}
!41 = metadata !{i32 786689, metadata !28, metadata !"byte_x_in_in_offset", metadata !29, i32 33554450, metadata !32, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!42 = metadata !{i32 18, i32 14, metadata !28, null}
!43 = metadata !{i32 786689, metadata !28, metadata !"byte_block_in_offset", metadata !29, i32 16777233, metadata !32, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!44 = metadata !{i32 17, i32 14, metadata !28, null}
!45 = metadata !{i32 786689, metadata !28, metadata !"memory_inout", metadata !29, i32 67108884, metadata !34, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!46 = metadata !{i32 20, i32 29, metadata !28, null}
!47 = metadata !{i32 22, i32 1, metadata !48, null}
!48 = metadata !{i32 786443, metadata !28, i32 21, i32 1, metadata !29, i32 0} ; [ DW_TAG_lexical_block ]
!49 = metadata !{i32 72, i32 2, metadata !48, null}
!50 = metadata !{i32 74, i32 3, metadata !51, null}
!51 = metadata !{i32 786443, metadata !48, i32 73, i32 2, metadata !29, i32 1} ; [ DW_TAG_lexical_block ]
!52 = metadata !{i32 99, i32 2, metadata !48, null}
!53 = metadata !{i32 101, i32 3, metadata !54, null}
!54 = metadata !{i32 786443, metadata !48, i32 100, i32 2, metadata !29, i32 2} ; [ DW_TAG_lexical_block ]
!55 = metadata !{i32 115, i32 16, metadata !48, null}
!56 = metadata !{i32 136, i32 2, metadata !48, null}
!57 = metadata !{i32 138, i32 3, metadata !58, null}
!58 = metadata !{i32 786443, metadata !48, i32 137, i32 2, metadata !29, i32 3} ; [ DW_TAG_lexical_block ]
!59 = metadata !{i32 146, i32 1, metadata !48, null}
!60 = metadata !{i32 786689, metadata !61, metadata !"block_in_int", null, i32 11, metadata !71, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!61 = metadata !{i32 786478, i32 0, metadata !62, metadata !"foo_user", metadata !"foo_user", metadata !"_Z8foo_userPfS_S_", metadata !62, i32 11, metadata !63, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, null, null, null, metadata !38, i32 14} ; [ DW_TAG_subprogram ]
!62 = metadata !{i32 786473, metadata !"../../src/foo_user.cpp", metadata !"/home/bkhusain/Desktop/improved_NMPC_SOC/HIL_testing/protoip_projects/heterogeneous_0", null} ; [ DW_TAG_file_type ]
!63 = metadata !{i32 786453, i32 0, metadata !"", i32 0, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !64, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!64 = metadata !{null, metadata !65, metadata !67, metadata !69}
!65 = metadata !{i32 786447, null, metadata !"", null, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !66} ; [ DW_TAG_pointer_type ]
!66 = metadata !{i32 786454, null, metadata !"data_t_block_in", metadata !62, i32 65, i64 0, i64 0, i64 0, i32 0, metadata !37} ; [ DW_TAG_typedef ]
!67 = metadata !{i32 786447, null, metadata !"", null, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !68} ; [ DW_TAG_pointer_type ]
!68 = metadata !{i32 786454, null, metadata !"data_t_x_in_in", metadata !62, i32 69, i64 0, i64 0, i64 0, i32 0, metadata !37} ; [ DW_TAG_typedef ]
!69 = metadata !{i32 786447, null, metadata !"", null, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !70} ; [ DW_TAG_pointer_type ]
!70 = metadata !{i32 786454, null, metadata !"data_t_y_out_out", metadata !62, i32 77, i64 0, i64 0, i64 0, i32 0, metadata !37} ; [ DW_TAG_typedef ]
!71 = metadata !{i32 786433, null, metadata !"", null, i32 0, i64 0, i64 0, i32 0, i32 0, metadata !66, metadata !72, i32 0, i32 0} ; [ DW_TAG_array_type ]
!72 = metadata !{metadata !73}
!73 = metadata !{i32 786465, i64 0, i64 4}        ; [ DW_TAG_subrange_type ]
!74 = metadata !{i32 11, i32 32, metadata !61, null}
!75 = metadata !{i32 786689, metadata !61, metadata !"x_in_in_int", null, i32 12, metadata !76, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!76 = metadata !{i32 786433, null, metadata !"", null, i32 0, i64 0, i64 0, i32 0, i32 0, metadata !68, metadata !72, i32 0, i32 0} ; [ DW_TAG_array_type ]
!77 = metadata !{i32 12, i32 20, metadata !61, null}
!78 = metadata !{i32 786689, metadata !61, metadata !"y_out_out_int", null, i32 13, metadata !79, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!79 = metadata !{i32 786433, null, metadata !"", null, i32 0, i64 0, i64 0, i32 0, i32 0, metadata !70, metadata !72, i32 0, i32 0} ; [ DW_TAG_array_type ]
!80 = metadata !{i32 13, i32 22, metadata !61, null}
!81 = metadata !{i32 19, i32 23, metadata !82, null}
!82 = metadata !{i32 786443, metadata !83, i32 19, i32 10, metadata !62, i32 1} ; [ DW_TAG_lexical_block ]
!83 = metadata !{i32 786443, metadata !61, i32 14, i32 1, metadata !62, i32 0} ; [ DW_TAG_lexical_block ]
!84 = metadata !{i32 19, i32 31, metadata !82, null}
!85 = metadata !{i32 20, i32 3, metadata !86, null}
!86 = metadata !{i32 786443, metadata !82, i32 20, i32 2, metadata !62, i32 2} ; [ DW_TAG_lexical_block ]
!87 = metadata !{i32 21, i32 3, metadata !86, null}
!88 = metadata !{i32 22, i32 35, metadata !89, null}
!89 = metadata !{i32 786443, metadata !86, i32 22, i32 16, metadata !62, i32 3} ; [ DW_TAG_lexical_block ]
!90 = metadata !{i32 24, i32 4, metadata !91, null}
!91 = metadata !{i32 786443, metadata !89, i32 23, i32 3, metadata !62, i32 4} ; [ DW_TAG_lexical_block ]
!92 = metadata !{i32 22, i32 49, metadata !89, null}
!93 = metadata !{i32 23, i32 4, metadata !91, null}
!94 = metadata !{i32 786688, metadata !89, metadata !"i_block", metadata !62, i32 22, metadata !95, i32 0, i32 0} ; [ DW_TAG_auto_variable ]
!95 = metadata !{i32 786468, null, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!96 = metadata !{i32 26, i32 33, metadata !97, null}
!97 = metadata !{i32 786443, metadata !86, i32 26, i32 15, metadata !62, i32 5} ; [ DW_TAG_lexical_block ]
!98 = metadata !{i32 26, i32 46, metadata !97, null}
!99 = metadata !{i32 27, i32 4, metadata !100, null}
!100 = metadata !{i32 786443, metadata !97, i32 27, i32 3, metadata !62, i32 6} ; [ DW_TAG_lexical_block ]
!101 = metadata !{i32 28, i32 4, metadata !100, null}
!102 = metadata !{i32 786688, metadata !97, metadata !"i_x_in", metadata !62, i32 26, metadata !95, i32 0, i32 0} ; [ DW_TAG_auto_variable ]
!103 = metadata !{i32 30, i32 2, metadata !86, null}
!104 = metadata !{i32 786688, metadata !82, metadata !"i", metadata !62, i32 19, metadata !95, i32 0, i32 0} ; [ DW_TAG_auto_variable ]
!105 = metadata !{i32 32, i32 1, metadata !83, null}

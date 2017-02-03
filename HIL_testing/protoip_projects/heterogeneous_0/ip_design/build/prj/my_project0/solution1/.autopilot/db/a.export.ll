; ModuleID = '/home/bkhusain/Desktop/improved_NMPC_SOC/HIL_testing/protoip_projects/heterogeneous_0/ip_design/build/prj/my_project0/solution1/.autopilot/db/a.o.2.bc'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@p_str1804 = private unnamed_addr constant [10 x i8] c"s_axilite\00", align 1
@p_str1805 = private unnamed_addr constant [6 x i8] c"BUS_A\00", align 1
@p_str1806 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@p_str1807 = private unnamed_addr constant [6 x i8] c"m_axi\00", align 1
@block_in_int = internal global [5 x float] zeroinitializer, align 16
@x_in_in_int = internal global [5 x float] zeroinitializer, align 16
@llvm_global_ctors_0 = appending global [2 x i32] [i32 65535, i32 65535]
@llvm_global_ctors_1 = appending global [2 x void ()*] [void ()* @_GLOBAL__I_a, void ()* @_GLOBAL__I_a1967]
@p_str18051897 = private unnamed_addr constant [6 x i8] c"alg_0\00", align 1
@p_str18061898 = private unnamed_addr constant [11 x i8] c"loop_block\00", align 1
@p_str18071899 = private unnamed_addr constant [10 x i8] c"loop_x_in\00", align 1
@foo_str = internal unnamed_addr constant [4 x i8] c"foo\00"
@memcpy_OC_foo_IC_unsigned_AC_i = internal unnamed_addr constant [97 x i8] c"memcpy.foo(unsigned int, unsigned int, unsigned int, float volatile*)::block_in_int.memory_inout\00"
@p_str1 = internal unnamed_addr constant [1 x i8] zeroinitializer
@burstread_OC_region_str = internal unnamed_addr constant [17 x i8] c"burstread.region\00"
@memcpy_OC_foo_IC_unsigned_AC_i_1 = internal unnamed_addr constant [96 x i8] c"memcpy.foo(unsigned int, unsigned int, unsigned int, float volatile*)::x_in_in_int.memory_inout\00"
@p_str2 = internal unnamed_addr constant [1 x i8] zeroinitializer
@memcpy_OC_memory_inout_OC_y_ou = internal unnamed_addr constant [38 x i8] c"memcpy.memory_inout.y_out_out_int.gep\00"
@p_str15 = internal unnamed_addr constant [1 x i8] zeroinitializer
@burstwrite_OC_region_str = internal unnamed_addr constant [18 x i8] c"burstwrite.region\00"

define void @foo(i32 %byte_block_in_offset, i32 %byte_x_in_in_offset, i32 %byte_y_out_out_offset, float* %memory_inout) nounwind uwtable {
  call void (...)* @_ssdm_op_SpecBitsMap(i32 %byte_block_in_offset) nounwind, !map !7
  call void (...)* @_ssdm_op_SpecBitsMap(i32 %byte_x_in_in_offset) nounwind, !map !13
  call void (...)* @_ssdm_op_SpecBitsMap(i32 %byte_y_out_out_offset) nounwind, !map !17
  call void (...)* @_ssdm_op_SpecBitsMap(float* %memory_inout) nounwind, !map !21
  call void (...)* @_ssdm_op_SpecTopModule([4 x i8]* @foo_str) nounwind
  %byte_y_out_out_offset_read = call i32 @_ssdm_op_Read.s_axilite.i32(i32 %byte_y_out_out_offset) nounwind
  %byte_x_in_in_offset_read = call i32 @_ssdm_op_Read.s_axilite.i32(i32 %byte_x_in_in_offset) nounwind
  %byte_block_in_offset_read = call i32 @_ssdm_op_Read.s_axilite.i32(i32 %byte_block_in_offset) nounwind
  %y_out_out_int = alloca [5 x float], align 16
  call void (...)* @_ssdm_op_SpecInterface(i32 %byte_y_out_out_offset, [10 x i8]* @p_str1804, i32 1, i32 1, i32 0, i32 0, [6 x i8]* @p_str1805, [1 x i8]* @p_str1806, [1 x i8]* @p_str1806) nounwind
  call void (...)* @_ssdm_op_SpecInterface(i32 %byte_x_in_in_offset, [10 x i8]* @p_str1804, i32 1, i32 1, i32 0, i32 0, [6 x i8]* @p_str1805, [1 x i8]* @p_str1806, [1 x i8]* @p_str1806) nounwind
  call void (...)* @_ssdm_op_SpecInterface(i32 %byte_block_in_offset, [10 x i8]* @p_str1804, i32 1, i32 1, i32 0, i32 0, [6 x i8]* @p_str1805, [1 x i8]* @p_str1806, [1 x i8]* @p_str1806) nounwind
  call void (...)* @_ssdm_op_SpecInterface(i32 0, [10 x i8]* @p_str1804, i32 0, i32 0, i32 0, i32 0, [6 x i8]* @p_str1805, [1 x i8]* @p_str1806, [1 x i8]* @p_str1806) nounwind
  call void (...)* @_ssdm_op_SpecInterface(float* %memory_inout, [6 x i8]* @p_str1807, i32 0, i32 0, i32 0, i32 15, [1 x i8]* @p_str1806, [1 x i8]* @p_str1806, [1 x i8]* @p_str1806) nounwind
  %tmp = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %byte_block_in_offset_read, i32 31)
  br i1 %tmp, label %._crit_edge, label %1

; <label>:1                                       ; preds = %0
  %tmp_1_cast = call i30 @_ssdm_op_PartSelect.i30.i32.i32.i32(i32 %byte_block_in_offset_read, i32 2, i32 31)
  %tmp_1 = zext i30 %tmp_1_cast to i64
  %memory_inout_addr = getelementptr float* %memory_inout, i64 %tmp_1
  %p_rd_req = call i1 @_ssdm_op_ReadReq.m_axi.floatP(float* %memory_inout_addr, i32 5) nounwind
  br label %burst.rd.header

burst.rd.header:                                  ; preds = %burst.rd.body, %1
  %indvar = phi i3 [ 0, %1 ], [ %indvar_next, %burst.rd.body ]
  %exitcond = icmp eq i3 %indvar, -3
  %empty = call i32 (...)* @_ssdm_op_SpecLoopTripCount(i64 5, i64 5, i64 5) nounwind
  %indvar_next = add i3 %indvar, 1
  br i1 %exitcond, label %._crit_edge, label %burst.rd.body

burst.rd.body:                                    ; preds = %burst.rd.header
  %burstread_rbegin = call i32 (...)* @_ssdm_op_SpecRegionBegin([17 x i8]* @burstread_OC_region_str) nounwind
  %empty_4 = call i32 (...)* @_ssdm_op_SpecPipeline(i32 1, i32 1, i32 1, i32 0, [1 x i8]* @p_str1) nounwind
  call void (...)* @_ssdm_op_SpecLoopName([97 x i8]* @memcpy_OC_foo_IC_unsigned_AC_i)
  %memory_inout_addr_read = call float @_ssdm_op_Read.m_axi.floatP(float* %memory_inout_addr) nounwind
  %tmp_3 = zext i3 %indvar to i64
  %block_in_int_addr = getelementptr [5 x float]* @block_in_int, i64 0, i64 %tmp_3
  store float %memory_inout_addr_read, float* %block_in_int_addr, align 4
  %burstread_rend = call i32 (...)* @_ssdm_op_SpecRegionEnd([17 x i8]* @burstread_OC_region_str, i32 %burstread_rbegin) nounwind
  br label %burst.rd.header

._crit_edge:                                      ; preds = %burst.rd.header, %0
  %tmp_2 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %byte_x_in_in_offset_read, i32 31)
  br i1 %tmp_2, label %._crit_edge1, label %2

; <label>:2                                       ; preds = %._crit_edge
  %tmp_5_cast = call i30 @_ssdm_op_PartSelect.i30.i32.i32.i32(i32 %byte_x_in_in_offset_read, i32 2, i32 31)
  %tmp_4 = zext i30 %tmp_5_cast to i64
  %memory_inout_addr_1 = getelementptr float* %memory_inout, i64 %tmp_4
  %p_rd_req1 = call i1 @_ssdm_op_ReadReq.m_axi.floatP(float* %memory_inout_addr_1, i32 5) nounwind
  br label %burst.rd.header6

burst.rd.header6:                                 ; preds = %burst.rd.body7, %2
  %indvar8 = phi i3 [ 0, %2 ], [ %indvar_next9, %burst.rd.body7 ]
  %exitcond1 = icmp eq i3 %indvar8, -3
  %empty_5 = call i32 (...)* @_ssdm_op_SpecLoopTripCount(i64 5, i64 5, i64 5) nounwind
  %indvar_next9 = add i3 %indvar8, 1
  br i1 %exitcond1, label %._crit_edge1, label %burst.rd.body7

burst.rd.body7:                                   ; preds = %burst.rd.header6
  %burstread_rbegin1 = call i32 (...)* @_ssdm_op_SpecRegionBegin([17 x i8]* @burstread_OC_region_str) nounwind
  %empty_6 = call i32 (...)* @_ssdm_op_SpecPipeline(i32 1, i32 1, i32 1, i32 0, [1 x i8]* @p_str2) nounwind
  call void (...)* @_ssdm_op_SpecLoopName([96 x i8]* @memcpy_OC_foo_IC_unsigned_AC_i_1)
  %memory_inout_addr_1_read = call float @_ssdm_op_Read.m_axi.floatP(float* %memory_inout_addr_1) nounwind
  %tmp_7 = zext i3 %indvar8 to i64
  %x_in_in_int_addr = getelementptr [5 x float]* @x_in_in_int, i64 0, i64 %tmp_7
  store float %memory_inout_addr_1_read, float* %x_in_in_int_addr, align 4
  %burstread_rend16 = call i32 (...)* @_ssdm_op_SpecRegionEnd([17 x i8]* @burstread_OC_region_str, i32 %burstread_rbegin1) nounwind
  br label %burst.rd.header6

._crit_edge1:                                     ; preds = %burst.rd.header6, %._crit_edge
  call fastcc void @foo_foo_user([5 x float]* @block_in_int, [5 x float]* @x_in_in_int, [5 x float]* %y_out_out_int) nounwind
  %tmp_5 = call i1 @_ssdm_op_BitSelect.i1.i32.i32(i32 %byte_y_out_out_offset_read, i32 31)
  br i1 %tmp_5, label %._crit_edge2, label %3

; <label>:3                                       ; preds = %._crit_edge1
  %tmp_9_cast = call i30 @_ssdm_op_PartSelect.i30.i32.i32.i32(i32 %byte_y_out_out_offset_read, i32 2, i32 31)
  %tmp_6 = zext i30 %tmp_9_cast to i64
  %memory_inout_addr_2 = getelementptr float* %memory_inout, i64 %tmp_6
  %p_wr_req = call i1 @_ssdm_op_WriteReq.m_axi.floatP(float* %memory_inout_addr_2, i32 5) nounwind
  br label %burst.wr.header

burst.wr.header:                                  ; preds = %burst.wr.body, %3
  %indvar1 = phi i3 [ 0, %3 ], [ %indvar_next1, %burst.wr.body ]
  %exitcond2 = icmp eq i3 %indvar1, -3
  %empty_7 = call i32 (...)* @_ssdm_op_SpecLoopTripCount(i64 5, i64 5, i64 5) nounwind
  %indvar_next1 = add i3 %indvar1, 1
  br i1 %exitcond2, label %._crit_edge2.loopexit, label %burst.wr.body

burst.wr.body:                                    ; preds = %burst.wr.header
  %burstwrite_rbegin = call i32 (...)* @_ssdm_op_SpecRegionBegin([18 x i8]* @burstwrite_OC_region_str) nounwind
  %empty_8 = call i32 (...)* @_ssdm_op_SpecPipeline(i32 1, i32 1, i32 1, i32 0, [1 x i8]* @p_str15) nounwind
  call void (...)* @_ssdm_op_SpecLoopName([38 x i8]* @memcpy_OC_memory_inout_OC_y_ou)
  %tmp_s = zext i3 %indvar1 to i64
  %y_out_out_int_addr = getelementptr [5 x float]* %y_out_out_int, i64 0, i64 %tmp_s
  %y_out_out_int_load = load float* %y_out_out_int_addr, align 4
  call void @_ssdm_op_Write.m_axi.floatP(float* %memory_inout_addr_2, float %y_out_out_int_load) nounwind
  %burstwrite_rend = call i32 (...)* @_ssdm_op_SpecRegionEnd([18 x i8]* @burstwrite_OC_region_str, i32 %burstwrite_rbegin) nounwind
  br label %burst.wr.header

._crit_edge2.loopexit:                            ; preds = %burst.wr.header
  %p_wr_resp = call i1 @_ssdm_op_WriteResp.m_axi.floatP(float* %memory_inout_addr_2) nounwind
  br label %._crit_edge2

._crit_edge2:                                     ; preds = %._crit_edge2.loopexit, %._crit_edge1
  ret void
}

define weak void @_ssdm_op_SpecInterface(...) nounwind {
entry:
  ret void
}

define weak void @_ssdm_op_SpecLoopName(...) nounwind {
entry:
  ret void
}

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

define weak void @_ssdm_op_SpecTopModule(...) {
entry:
  ret void
}

declare void @_GLOBAL__I_a() nounwind section ".text.startup"

declare void @_GLOBAL__I_a1967() nounwind section ".text.startup"

define weak i32 @_ssdm_op_SpecPipeline(...) {
entry:
  ret i32 0
}

define weak i32 @_ssdm_op_SpecRegionBegin(...) {
entry:
  ret i32 0
}

define weak i32 @_ssdm_op_SpecRegionEnd(...) {
entry:
  ret i32 0
}

define internal fastcc void @foo_foo_user([5 x float]* nocapture %block_in_int, [5 x float]* nocapture %x_in_in_int, [5 x float]* nocapture %y_out_out_int) {
  br label %1

; <label>:1                                       ; preds = %6, %0
  %i = phi i3 [ 0, %0 ], [ %i_1, %6 ]
  %exitcond2 = icmp eq i3 %i, -3
  %empty = call i32 (...)* @_ssdm_op_SpecLoopTripCount(i64 5, i64 5, i64 5)
  %i_1 = add i3 %i, 1
  br i1 %exitcond2, label %7, label %2

; <label>:2                                       ; preds = %1
  call void (...)* @_ssdm_op_SpecLoopName([6 x i8]* @p_str18051897) nounwind
  %tmp_1 = call i32 (...)* @_ssdm_op_SpecRegionBegin([6 x i8]* @p_str18051897)
  %tmp = zext i3 %i to i64
  %y_out_out_int_addr = getelementptr [5 x float]* %y_out_out_int, i64 0, i64 %tmp
  br label %3

; <label>:3                                       ; preds = %4, %2
  %storemerge = phi float [ 0.000000e+00, %2 ], [ %tmp_3, %4 ]
  %i_block = phi i3 [ 0, %2 ], [ %i_block_1, %4 ]
  store float %storemerge, float* %y_out_out_int_addr, align 4
  %exitcond1 = icmp eq i3 %i_block, -3
  %empty_9 = call i32 (...)* @_ssdm_op_SpecLoopTripCount(i64 5, i64 5, i64 5)
  %i_block_1 = add i3 %i_block, 1
  br i1 %exitcond1, label %.preheader, label %4

; <label>:4                                       ; preds = %3
  call void (...)* @_ssdm_op_SpecLoopName([11 x i8]* @p_str18061898) nounwind
  %tmp_2 = zext i3 %i_block to i64
  %block_in_int_addr = getelementptr [5 x float]* %block_in_int, i64 0, i64 %tmp_2
  %block_in_int_load = load float* %block_in_int_addr, align 4
  %tmp_3 = fadd float %storemerge, %block_in_int_load
  br label %3

.preheader:                                       ; preds = %3, %5
  %tmp_4 = phi float [ %tmp_6, %5 ], [ %storemerge, %3 ]
  %i_x_in = phi i3 [ %i_x_in_1, %5 ], [ 0, %3 ]
  %exitcond = icmp eq i3 %i_x_in, -3
  %empty_10 = call i32 (...)* @_ssdm_op_SpecLoopTripCount(i64 5, i64 5, i64 5)
  %i_x_in_1 = add i3 %i_x_in, 1
  br i1 %exitcond, label %6, label %5

; <label>:5                                       ; preds = %.preheader
  call void (...)* @_ssdm_op_SpecLoopName([10 x i8]* @p_str18071899) nounwind
  %tmp_5 = zext i3 %i_x_in to i64
  %x_in_in_int_addr = getelementptr [5 x float]* %x_in_in_int, i64 0, i64 %tmp_5
  %x_in_in_int_load = load float* %x_in_in_int_addr, align 4
  %tmp_6 = fadd float %tmp_4, %x_in_in_int_load
  store float %tmp_6, float* %y_out_out_int_addr, align 4
  br label %.preheader

; <label>:6                                       ; preds = %.preheader
  %empty_11 = call i32 (...)* @_ssdm_op_SpecRegionEnd([6 x i8]* @p_str18051897, i32 %tmp_1)
  br label %1

; <label>:7                                       ; preds = %1
  ret void
}

define weak void @_ssdm_op_SpecBitsMap(...) {
entry:
  ret void
}

define weak i32 @_ssdm_op_SpecLoopTripCount(...) {
entry:
  ret i32 0
}

define weak i30 @_ssdm_op_PartSelect.i30.i32.i32.i32(i32, i32, i32) nounwind readnone {
entry:
  %empty = call i32 @llvm.part.select.i32(i32 %0, i32 %1, i32 %2)
  %empty_12 = trunc i32 %empty to i30
  ret i30 %empty_12
}

define weak i1 @_ssdm_op_ReadReq.m_axi.floatP(float*, i32) {
entry:
  ret i1 true
}

define weak float @_ssdm_op_Read.m_axi.floatP(float*) {
entry:
  %empty = load float* %0
  ret float %empty
}

define weak i1 @_ssdm_op_WriteReq.m_axi.floatP(float*, i32) {
entry:
  ret i1 true
}

define weak void @_ssdm_op_Write.m_axi.floatP(float*, float) {
entry:
  store float %1, float* %0
  ret void
}

define weak i1 @_ssdm_op_WriteResp.m_axi.floatP(float*) {
entry:
  ret i1 true
}

define weak i32 @_ssdm_op_Read.s_axilite.i32(i32) {
entry:
  ret i32 %0
}

define weak i1 @_ssdm_op_BitSelect.i1.i32.i32(i32, i32) nounwind readnone {
entry:
  %empty = shl i32 1, %1
  %empty_13 = and i32 %0, %empty
  %empty_14 = icmp ne i32 %empty_13, 0
  ret i1 %empty_14
}

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

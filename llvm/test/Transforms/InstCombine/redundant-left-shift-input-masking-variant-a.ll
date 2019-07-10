; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt %s -instcombine -S | FileCheck %s

; If we have some pattern that leaves only some low bits set, and then performs
; left-shift of those bits, if none of the bits that are left after the final
; shift are modified by the mask, we can omit the mask.

; There are many variants to this pattern:
;   a)  (x & ((1 << maskNbits) - 1)) << shiftNbits
; simplify to:
;   x << shiftNbits
; iff (maskNbits+shiftNbits) u>= bitwidth(x)

; Simple tests. We don't care about extra uses.

declare void @use32(i32)

define i32 @t0_basic(i32 %x, i32 %nbits) {
; CHECK-LABEL: @t0_basic(
; CHECK-NEXT:    [[T0:%.*]] = shl i32 1, [[NBITS:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = add nsw i32 [[T0]], -1
; CHECK-NEXT:    [[T2:%.*]] = and i32 [[T1]], [[X:%.*]]
; CHECK-NEXT:    [[T3:%.*]] = sub i32 32, [[NBITS]]
; CHECK-NEXT:    call void @use32(i32 [[T0]])
; CHECK-NEXT:    call void @use32(i32 [[T1]])
; CHECK-NEXT:    call void @use32(i32 [[T2]])
; CHECK-NEXT:    call void @use32(i32 [[T3]])
; CHECK-NEXT:    [[T4:%.*]] = shl i32 [[T2]], [[T3]]
; CHECK-NEXT:    ret i32 [[T4]]
;
  %t0 = shl i32 1, %nbits
  %t1 = add nsw i32 %t0, -1
  %t2 = and i32 %t1, %x
  %t3 = sub i32 32, %nbits
  call void @use32(i32 %t0)
  call void @use32(i32 %t1)
  call void @use32(i32 %t2)
  call void @use32(i32 %t3)
  %t4 = shl i32 %t2, %t3
  ret i32 %t4
}

define i32 @t1_bigger_shift(i32 %x, i32 %nbits) {
; CHECK-LABEL: @t1_bigger_shift(
; CHECK-NEXT:    [[T0:%.*]] = shl i32 1, [[NBITS:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = add nsw i32 [[T0]], -1
; CHECK-NEXT:    [[T2:%.*]] = and i32 [[T1]], [[X:%.*]]
; CHECK-NEXT:    [[T3:%.*]] = sub i32 33, [[NBITS]]
; CHECK-NEXT:    call void @use32(i32 [[T0]])
; CHECK-NEXT:    call void @use32(i32 [[T1]])
; CHECK-NEXT:    call void @use32(i32 [[T2]])
; CHECK-NEXT:    call void @use32(i32 [[T3]])
; CHECK-NEXT:    [[T4:%.*]] = shl i32 [[T2]], [[T3]]
; CHECK-NEXT:    ret i32 [[T4]]
;
  %t0 = shl i32 1, %nbits
  %t1 = add nsw i32 %t0, -1
  %t2 = and i32 %t1, %x
  %t3 = sub i32 33, %nbits ; subtracting from bitwidth+1
  call void @use32(i32 %t0)
  call void @use32(i32 %t1)
  call void @use32(i32 %t2)
  call void @use32(i32 %t3)
  %t4 = shl i32 %t2, %t3
  ret i32 %t4
}

define i32 @t2_bigger_mask(i32 %x, i32 %nbits) {
; CHECK-LABEL: @t2_bigger_mask(
; CHECK-NEXT:    [[T0:%.*]] = add i32 [[NBITS:%.*]], 1
; CHECK-NEXT:    [[T1:%.*]] = shl i32 1, [[T0]]
; CHECK-NEXT:    [[T2:%.*]] = add nsw i32 [[T1]], -1
; CHECK-NEXT:    [[T3:%.*]] = and i32 [[T2]], [[X:%.*]]
; CHECK-NEXT:    [[T4:%.*]] = sub i32 32, [[NBITS]]
; CHECK-NEXT:    call void @use32(i32 [[T0]])
; CHECK-NEXT:    call void @use32(i32 [[T1]])
; CHECK-NEXT:    call void @use32(i32 [[T2]])
; CHECK-NEXT:    call void @use32(i32 [[T3]])
; CHECK-NEXT:    call void @use32(i32 [[T4]])
; CHECK-NEXT:    [[T5:%.*]] = shl i32 [[T3]], [[T4]]
; CHECK-NEXT:    ret i32 [[T5]]
;
  %t0 = add i32 %nbits, 1
  %t1 = shl i32 1, %t0 ; shifting by nbits+1
  %t2 = add nsw i32 %t1, -1
  %t3 = and i32 %t2, %x
  %t4 = sub i32 32, %nbits
  call void @use32(i32 %t0)
  call void @use32(i32 %t1)
  call void @use32(i32 %t2)
  call void @use32(i32 %t3)
  call void @use32(i32 %t4)
  %t5 = shl i32 %t3, %t4
  ret i32 %t5
}

; Vectors

declare void @use3xi32(<3 x i32>)

define <3 x i32> @t3_vec_splat(<3 x i32> %x, <3 x i32> %nbits) {
; CHECK-LABEL: @t3_vec_splat(
; CHECK-NEXT:    [[T1:%.*]] = shl <3 x i32> <i32 1, i32 1, i32 1>, [[NBITS:%.*]]
; CHECK-NEXT:    [[T2:%.*]] = add nsw <3 x i32> [[T1]], <i32 -1, i32 -1, i32 -1>
; CHECK-NEXT:    [[T3:%.*]] = and <3 x i32> [[T2]], [[X:%.*]]
; CHECK-NEXT:    [[T4:%.*]] = sub <3 x i32> <i32 32, i32 32, i32 32>, [[NBITS]]
; CHECK-NEXT:    call void @use3xi32(<3 x i32> [[NBITS]])
; CHECK-NEXT:    call void @use3xi32(<3 x i32> [[T1]])
; CHECK-NEXT:    call void @use3xi32(<3 x i32> [[T2]])
; CHECK-NEXT:    call void @use3xi32(<3 x i32> [[T3]])
; CHECK-NEXT:    call void @use3xi32(<3 x i32> [[T4]])
; CHECK-NEXT:    [[T5:%.*]] = shl <3 x i32> [[T3]], [[T4]]
; CHECK-NEXT:    ret <3 x i32> [[T5]]
;
  %t0 = add <3 x i32> %nbits, <i32 0, i32 0, i32 0>
  %t1 = shl <3 x i32> <i32 1, i32 1, i32 1>, %t0
  %t2 = add nsw <3 x i32> %t1, <i32 -1, i32 -1, i32 -1>
  %t3 = and <3 x i32> %t2, %x
  %t4 = sub <3 x i32> <i32 32, i32 32, i32 32>, %nbits
  call void @use3xi32(<3 x i32> %t0)
  call void @use3xi32(<3 x i32> %t1)
  call void @use3xi32(<3 x i32> %t2)
  call void @use3xi32(<3 x i32> %t3)
  call void @use3xi32(<3 x i32> %t4)
  %t5 = shl <3 x i32> %t3, %t4
  ret <3 x i32> %t5
}

define <3 x i32> @t4_vec_nonsplat(<3 x i32> %x, <3 x i32> %nbits) {
; CHECK-LABEL: @t4_vec_nonsplat(
; CHECK-NEXT:    [[T0:%.*]] = add <3 x i32> [[NBITS:%.*]], <i32 -1, i32 0, i32 1>
; CHECK-NEXT:    [[T1:%.*]] = shl <3 x i32> <i32 1, i32 1, i32 1>, [[T0]]
; CHECK-NEXT:    [[T2:%.*]] = add nsw <3 x i32> [[T1]], <i32 -1, i32 -1, i32 -1>
; CHECK-NEXT:    [[T3:%.*]] = and <3 x i32> [[T2]], [[X:%.*]]
; CHECK-NEXT:    [[T4:%.*]] = sub <3 x i32> <i32 33, i32 32, i32 32>, [[NBITS]]
; CHECK-NEXT:    call void @use3xi32(<3 x i32> [[T0]])
; CHECK-NEXT:    call void @use3xi32(<3 x i32> [[T1]])
; CHECK-NEXT:    call void @use3xi32(<3 x i32> [[T2]])
; CHECK-NEXT:    call void @use3xi32(<3 x i32> [[T3]])
; CHECK-NEXT:    call void @use3xi32(<3 x i32> [[T4]])
; CHECK-NEXT:    [[T5:%.*]] = shl <3 x i32> [[T3]], [[T4]]
; CHECK-NEXT:    ret <3 x i32> [[T5]]
;
  %t0 = add <3 x i32> %nbits, <i32 -1, i32 0, i32 1>
  %t1 = shl <3 x i32> <i32 1, i32 1, i32 1>, %t0
  %t2 = add nsw <3 x i32> %t1, <i32 -1, i32 -1, i32 -1>
  %t3 = and <3 x i32> %t2, %x
  %t4 = sub <3 x i32> <i32 33, i32 32, i32 32>, %nbits
  call void @use3xi32(<3 x i32> %t0)
  call void @use3xi32(<3 x i32> %t1)
  call void @use3xi32(<3 x i32> %t2)
  call void @use3xi32(<3 x i32> %t3)
  call void @use3xi32(<3 x i32> %t4)
  %t5 = shl <3 x i32> %t3, %t4
  ret <3 x i32> %t5
}

define <3 x i32> @t5_vec_undef(<3 x i32> %x, <3 x i32> %nbits) {
; CHECK-LABEL: @t5_vec_undef(
; CHECK-NEXT:    [[T1:%.*]] = shl <3 x i32> <i32 1, i32 undef, i32 1>, [[NBITS:%.*]]
; CHECK-NEXT:    [[T2:%.*]] = add nsw <3 x i32> [[T1]], <i32 -1, i32 undef, i32 -1>
; CHECK-NEXT:    [[T3:%.*]] = and <3 x i32> [[T2]], [[X:%.*]]
; CHECK-NEXT:    [[T4:%.*]] = sub <3 x i32> <i32 32, i32 undef, i32 32>, [[NBITS]]
; CHECK-NEXT:    call void @use3xi32(<3 x i32> [[NBITS]])
; CHECK-NEXT:    call void @use3xi32(<3 x i32> [[T1]])
; CHECK-NEXT:    call void @use3xi32(<3 x i32> [[T2]])
; CHECK-NEXT:    call void @use3xi32(<3 x i32> [[T3]])
; CHECK-NEXT:    call void @use3xi32(<3 x i32> [[T4]])
; CHECK-NEXT:    [[T5:%.*]] = shl <3 x i32> [[T3]], [[T4]]
; CHECK-NEXT:    ret <3 x i32> [[T5]]
;
  %t0 = add <3 x i32> %nbits, <i32 0, i32 undef, i32 0>
  %t1 = shl <3 x i32> <i32 1, i32 undef, i32 1>, %t0
  %t2 = add nsw <3 x i32> %t1, <i32 -1, i32 undef, i32 -1>
  %t3 = and <3 x i32> %t2, %x
  %t4 = sub <3 x i32> <i32 32, i32 undef, i32 32>, %nbits
  call void @use3xi32(<3 x i32> %t0)
  call void @use3xi32(<3 x i32> %t1)
  call void @use3xi32(<3 x i32> %t2)
  call void @use3xi32(<3 x i32> %t3)
  call void @use3xi32(<3 x i32> %t4)
  %t5 = shl <3 x i32> %t3, %t4
  ret <3 x i32> %t5
}

; Commutativity

declare i32 @gen32()

define i32 @t6_commutativity0(i32 %nbits) {
; CHECK-LABEL: @t6_commutativity0(
; CHECK-NEXT:    [[X:%.*]] = call i32 @gen32()
; CHECK-NEXT:    [[T0:%.*]] = shl i32 1, [[NBITS:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = add nsw i32 [[T0]], -1
; CHECK-NEXT:    [[T2:%.*]] = and i32 [[X]], [[T1]]
; CHECK-NEXT:    [[T3:%.*]] = sub i32 32, [[NBITS]]
; CHECK-NEXT:    call void @use32(i32 [[T0]])
; CHECK-NEXT:    call void @use32(i32 [[T1]])
; CHECK-NEXT:    call void @use32(i32 [[T2]])
; CHECK-NEXT:    call void @use32(i32 [[T3]])
; CHECK-NEXT:    [[T4:%.*]] = shl i32 [[T2]], [[T3]]
; CHECK-NEXT:    ret i32 [[T4]]
;
  %x = call i32 @gen32()
  %t0 = shl i32 1, %nbits
  %t1 = add nsw i32 %t0, -1
  %t2 = and i32 %x, %t1 ; swapped
  %t3 = sub i32 32, %nbits
  call void @use32(i32 %t0)
  call void @use32(i32 %t1)
  call void @use32(i32 %t2)
  call void @use32(i32 %t3)
  %t4 = shl i32 %t2, %t3
  ret i32 %t4
}

define i32 @t6_commutativity1(i32 %nbits0, i32 %nbits1) {
; CHECK-LABEL: @t6_commutativity1(
; CHECK-NEXT:    [[T0:%.*]] = shl i32 1, [[NBITS0:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = add nsw i32 [[T0]], -1
; CHECK-NEXT:    [[T2:%.*]] = shl i32 1, [[NBITS1:%.*]]
; CHECK-NEXT:    [[T3:%.*]] = add nsw i32 [[T2]], -1
; CHECK-NEXT:    [[T4:%.*]] = and i32 [[T3]], [[T1]]
; CHECK-NEXT:    [[T5:%.*]] = sub i32 32, [[NBITS0]]
; CHECK-NEXT:    call void @use32(i32 [[T0]])
; CHECK-NEXT:    call void @use32(i32 [[T1]])
; CHECK-NEXT:    call void @use32(i32 [[T2]])
; CHECK-NEXT:    call void @use32(i32 [[T3]])
; CHECK-NEXT:    call void @use32(i32 [[T4]])
; CHECK-NEXT:    call void @use32(i32 [[T5]])
; CHECK-NEXT:    ret i32 [[T4]]
;
  %t0 = shl i32 1, %nbits0
  %t1 = add nsw i32 %t0, -1
  %t2 = shl i32 1, %nbits1
  %t3 = add nsw i32 %t2, -1
  %t4 = and i32 %t3, %t1 ; both hands of 'and' could be mask..
  %t5 = sub i32 32, %nbits0
  call void @use32(i32 %t0)
  call void @use32(i32 %t1)
  call void @use32(i32 %t2)
  call void @use32(i32 %t3)
  call void @use32(i32 %t4)
  call void @use32(i32 %t5)
  %t6 = shl i32 %t4, %t5
  ret i32 %t4
}
define i32 @t6_commutativity2(i32 %nbits0, i32 %nbits1) {
; CHECK-LABEL: @t6_commutativity2(
; CHECK-NEXT:    [[T0:%.*]] = shl i32 1, [[NBITS0:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = add nsw i32 [[T0]], -1
; CHECK-NEXT:    [[T2:%.*]] = shl i32 1, [[NBITS1:%.*]]
; CHECK-NEXT:    [[T3:%.*]] = add nsw i32 [[T2]], -1
; CHECK-NEXT:    [[T4:%.*]] = and i32 [[T3]], [[T1]]
; CHECK-NEXT:    [[T5:%.*]] = sub i32 32, [[NBITS1]]
; CHECK-NEXT:    call void @use32(i32 [[T0]])
; CHECK-NEXT:    call void @use32(i32 [[T1]])
; CHECK-NEXT:    call void @use32(i32 [[T2]])
; CHECK-NEXT:    call void @use32(i32 [[T3]])
; CHECK-NEXT:    call void @use32(i32 [[T4]])
; CHECK-NEXT:    call void @use32(i32 [[T5]])
; CHECK-NEXT:    ret i32 [[T4]]
;
  %t0 = shl i32 1, %nbits0
  %t1 = add nsw i32 %t0, -1
  %t2 = shl i32 1, %nbits1
  %t3 = add nsw i32 %t2, -1
  %t4 = and i32 %t3, %t1 ; both hands of 'and' could be mask..
  %t5 = sub i32 32, %nbits1
  call void @use32(i32 %t0)
  call void @use32(i32 %t1)
  call void @use32(i32 %t2)
  call void @use32(i32 %t3)
  call void @use32(i32 %t4)
  call void @use32(i32 %t5)
  %t6 = shl i32 %t4, %t5
  ret i32 %t4
}

; Fast-math flags. We must not preserve them!

define i32 @t7_nuw(i32 %x, i32 %nbits) {
; CHECK-LABEL: @t7_nuw(
; CHECK-NEXT:    [[T0:%.*]] = shl i32 1, [[NBITS:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = add nsw i32 [[T0]], -1
; CHECK-NEXT:    [[T2:%.*]] = and i32 [[T1]], [[X:%.*]]
; CHECK-NEXT:    [[T3:%.*]] = sub i32 32, [[NBITS]]
; CHECK-NEXT:    call void @use32(i32 [[T0]])
; CHECK-NEXT:    call void @use32(i32 [[T1]])
; CHECK-NEXT:    call void @use32(i32 [[T2]])
; CHECK-NEXT:    call void @use32(i32 [[T3]])
; CHECK-NEXT:    [[T4:%.*]] = shl nuw i32 [[T2]], [[T3]]
; CHECK-NEXT:    ret i32 [[T4]]
;
  %t0 = shl i32 1, %nbits
  %t1 = add nsw i32 %t0, -1
  %t2 = and i32 %t1, %x
  %t3 = sub i32 32, %nbits
  call void @use32(i32 %t0)
  call void @use32(i32 %t1)
  call void @use32(i32 %t2)
  call void @use32(i32 %t3)
  %t4 = shl nuw i32 %t2, %t3
  ret i32 %t4
}

define i32 @t8_nsw(i32 %x, i32 %nbits) {
; CHECK-LABEL: @t8_nsw(
; CHECK-NEXT:    [[T0:%.*]] = shl i32 1, [[NBITS:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = add nsw i32 [[T0]], -1
; CHECK-NEXT:    [[T2:%.*]] = and i32 [[T1]], [[X:%.*]]
; CHECK-NEXT:    [[T3:%.*]] = sub i32 32, [[NBITS]]
; CHECK-NEXT:    call void @use32(i32 [[T0]])
; CHECK-NEXT:    call void @use32(i32 [[T1]])
; CHECK-NEXT:    call void @use32(i32 [[T2]])
; CHECK-NEXT:    call void @use32(i32 [[T3]])
; CHECK-NEXT:    [[T4:%.*]] = shl nsw i32 [[T2]], [[T3]]
; CHECK-NEXT:    ret i32 [[T4]]
;
  %t0 = shl i32 1, %nbits
  %t1 = add nsw i32 %t0, -1
  %t2 = and i32 %t1, %x
  %t3 = sub i32 32, %nbits
  call void @use32(i32 %t0)
  call void @use32(i32 %t1)
  call void @use32(i32 %t2)
  call void @use32(i32 %t3)
  %t4 = shl nsw i32 %t2, %t3
  ret i32 %t4
}

define i32 @t9_nuw_nsw(i32 %x, i32 %nbits) {
; CHECK-LABEL: @t9_nuw_nsw(
; CHECK-NEXT:    [[T0:%.*]] = shl i32 1, [[NBITS:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = add nsw i32 [[T0]], -1
; CHECK-NEXT:    [[T2:%.*]] = and i32 [[T1]], [[X:%.*]]
; CHECK-NEXT:    [[T3:%.*]] = sub i32 32, [[NBITS]]
; CHECK-NEXT:    call void @use32(i32 [[T0]])
; CHECK-NEXT:    call void @use32(i32 [[T1]])
; CHECK-NEXT:    call void @use32(i32 [[T2]])
; CHECK-NEXT:    call void @use32(i32 [[T3]])
; CHECK-NEXT:    [[T4:%.*]] = shl nuw nsw i32 [[T2]], [[T3]]
; CHECK-NEXT:    ret i32 [[T4]]
;
  %t0 = shl i32 1, %nbits
  %t1 = add nsw i32 %t0, -1
  %t2 = and i32 %t1, %x
  %t3 = sub i32 32, %nbits
  call void @use32(i32 %t0)
  call void @use32(i32 %t1)
  call void @use32(i32 %t2)
  call void @use32(i32 %t3)
  %t4 = shl nuw nsw i32 %t2, %t3
  ret i32 %t4
}

; Negative tests

define i32 @n10(i32 %x, i32 %nbits) {
; CHECK-LABEL: @n10(
; CHECK-NEXT:    [[T0:%.*]] = shl i32 2, [[NBITS:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = add nsw i32 [[T0]], -1
; CHECK-NEXT:    [[T2:%.*]] = and i32 [[T1]], [[X:%.*]]
; CHECK-NEXT:    [[T3:%.*]] = sub i32 32, [[NBITS]]
; CHECK-NEXT:    call void @use32(i32 [[T0]])
; CHECK-NEXT:    call void @use32(i32 [[T1]])
; CHECK-NEXT:    call void @use32(i32 [[T2]])
; CHECK-NEXT:    call void @use32(i32 [[T3]])
; CHECK-NEXT:    [[T4:%.*]] = shl i32 [[T2]], [[T3]]
; CHECK-NEXT:    ret i32 [[T4]]
;
  %t0 = shl i32 2, %nbits ; shifting not '-1'
  %t1 = add nsw i32 %t0, -1
  %t2 = and i32 %t1, %x
  %t3 = sub i32 32, %nbits
  call void @use32(i32 %t0)
  call void @use32(i32 %t1)
  call void @use32(i32 %t2)
  call void @use32(i32 %t3)
  %t4 = shl i32 %t2, %t3
  ret i32 %t4
}

define i32 @n11(i32 %x, i32 %nbits) {
; CHECK-LABEL: @n11(
; CHECK-NEXT:    [[T0:%.*]] = shl i32 1, [[NBITS:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = add nsw i32 [[T0]], 2147483647
; CHECK-NEXT:    [[T2:%.*]] = and i32 [[T1]], [[X:%.*]]
; CHECK-NEXT:    [[T3:%.*]] = sub i32 32, [[NBITS]]
; CHECK-NEXT:    call void @use32(i32 [[T0]])
; CHECK-NEXT:    call void @use32(i32 [[T1]])
; CHECK-NEXT:    call void @use32(i32 [[T2]])
; CHECK-NEXT:    call void @use32(i32 [[T3]])
; CHECK-NEXT:    [[T4:%.*]] = shl i32 [[T2]], [[T3]]
; CHECK-NEXT:    ret i32 [[T4]]
;
  %t0 = shl i32 1, %nbits
  %t1 = add nsw i32 %t0, 2147483647 ; adding not '-1'
  %t2 = and i32 %t1, %x
  %t3 = sub i32 32, %nbits
  call void @use32(i32 %t0)
  call void @use32(i32 %t1)
  call void @use32(i32 %t2)
  call void @use32(i32 %t3)
  %t4 = shl i32 %t2, %t3
  ret i32 %t4
}

define i32 @n12(i32 %x, i32 %nbits) {
; CHECK-LABEL: @n12(
; CHECK-NEXT:    [[T0:%.*]] = shl i32 1, [[NBITS:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = add nsw i32 [[T0]], -1
; CHECK-NEXT:    [[T2:%.*]] = and i32 [[T1]], [[X:%.*]]
; CHECK-NEXT:    [[T3:%.*]] = sub i32 31, [[NBITS]]
; CHECK-NEXT:    call void @use32(i32 [[T0]])
; CHECK-NEXT:    call void @use32(i32 [[T1]])
; CHECK-NEXT:    call void @use32(i32 [[T2]])
; CHECK-NEXT:    call void @use32(i32 [[T3]])
; CHECK-NEXT:    [[T4:%.*]] = shl i32 [[T2]], [[T3]]
; CHECK-NEXT:    ret i32 [[T4]]
;
  %t0 = shl i32 1, %nbits
  %t1 = add nsw i32 %t0, -1
  %t2 = and i32 %t1, %x
  %t3 = sub i32 31, %nbits ; summary shift amount is less than 32
  call void @use32(i32 %t0)
  call void @use32(i32 %t1)
  call void @use32(i32 %t2)
  call void @use32(i32 %t3)
  %t4 = shl i32 %t2, %t3
  ret i32 %t4
}

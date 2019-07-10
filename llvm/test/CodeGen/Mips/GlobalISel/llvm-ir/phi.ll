; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc  -O0 -mtriple=mipsel-linux-gnu -global-isel  -verify-machineinstrs %s -o -| FileCheck %s -check-prefixes=MIPS32

define i1 @phi_i1(i1 %cnd, i1 %a, i1 %b) {
; MIPS32-LABEL: phi_i1:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    addiu $sp, $sp, -16
; MIPS32-NEXT:    .cfi_def_cfa_offset 16
; MIPS32-NEXT:    ori $1, $zero, 1
; MIPS32-NEXT:    and $1, $4, $1
; MIPS32-NEXT:    sw $5, 12($sp) # 4-byte Folded Spill
; MIPS32-NEXT:    sw $6, 8($sp) # 4-byte Folded Spill
; MIPS32-NEXT:    bnez $1, $BB0_2
; MIPS32-NEXT:    nop
; MIPS32-NEXT:  # %bb.1: # %entry
; MIPS32-NEXT:    j $BB0_3
; MIPS32-NEXT:    nop
; MIPS32-NEXT:  $BB0_2: # %cond.true
; MIPS32-NEXT:    lw $1, 12($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    sw $1, 4($sp) # 4-byte Folded Spill
; MIPS32-NEXT:    j $BB0_4
; MIPS32-NEXT:    nop
; MIPS32-NEXT:  $BB0_3: # %cond.false
; MIPS32-NEXT:    lw $1, 8($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    sw $1, 4($sp) # 4-byte Folded Spill
; MIPS32-NEXT:  $BB0_4: # %cond.end
; MIPS32-NEXT:    lw $1, 4($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    move $2, $1
; MIPS32-NEXT:    addiu $sp, $sp, 16
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  br i1 %cnd, label %cond.true, label %cond.false

cond.true:
  br label %cond.end

cond.false:
  br label %cond.end

cond.end:
  %cond = phi i1 [ %a, %cond.true ], [ %b, %cond.false ]
  ret i1 %cond
}

define i8 @phi_i8(i1 %cnd, i8 %a, i8 %b) {
; MIPS32-LABEL: phi_i8:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    addiu $sp, $sp, -16
; MIPS32-NEXT:    .cfi_def_cfa_offset 16
; MIPS32-NEXT:    ori $1, $zero, 1
; MIPS32-NEXT:    and $1, $4, $1
; MIPS32-NEXT:    sw $5, 12($sp) # 4-byte Folded Spill
; MIPS32-NEXT:    sw $6, 8($sp) # 4-byte Folded Spill
; MIPS32-NEXT:    bnez $1, $BB1_2
; MIPS32-NEXT:    nop
; MIPS32-NEXT:  # %bb.1: # %entry
; MIPS32-NEXT:    j $BB1_3
; MIPS32-NEXT:    nop
; MIPS32-NEXT:  $BB1_2: # %cond.true
; MIPS32-NEXT:    lw $1, 12($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    sw $1, 4($sp) # 4-byte Folded Spill
; MIPS32-NEXT:    j $BB1_4
; MIPS32-NEXT:    nop
; MIPS32-NEXT:  $BB1_3: # %cond.false
; MIPS32-NEXT:    lw $1, 8($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    sw $1, 4($sp) # 4-byte Folded Spill
; MIPS32-NEXT:  $BB1_4: # %cond.end
; MIPS32-NEXT:    lw $1, 4($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    move $2, $1
; MIPS32-NEXT:    addiu $sp, $sp, 16
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  br i1 %cnd, label %cond.true, label %cond.false

cond.true:
  br label %cond.end

cond.false:
  br label %cond.end

cond.end:
  %cond = phi i8 [ %a, %cond.true ], [ %b, %cond.false ]
  ret i8 %cond
}

define i16 @phi_i16(i1 %cnd, i16 %a, i16 %b) {
; MIPS32-LABEL: phi_i16:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    addiu $sp, $sp, -16
; MIPS32-NEXT:    .cfi_def_cfa_offset 16
; MIPS32-NEXT:    ori $1, $zero, 1
; MIPS32-NEXT:    and $1, $4, $1
; MIPS32-NEXT:    sw $5, 12($sp) # 4-byte Folded Spill
; MIPS32-NEXT:    sw $6, 8($sp) # 4-byte Folded Spill
; MIPS32-NEXT:    bnez $1, $BB2_2
; MIPS32-NEXT:    nop
; MIPS32-NEXT:  # %bb.1: # %entry
; MIPS32-NEXT:    j $BB2_3
; MIPS32-NEXT:    nop
; MIPS32-NEXT:  $BB2_2: # %cond.true
; MIPS32-NEXT:    lw $1, 12($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    sw $1, 4($sp) # 4-byte Folded Spill
; MIPS32-NEXT:    j $BB2_4
; MIPS32-NEXT:    nop
; MIPS32-NEXT:  $BB2_3: # %cond.false
; MIPS32-NEXT:    lw $1, 8($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    sw $1, 4($sp) # 4-byte Folded Spill
; MIPS32-NEXT:  $BB2_4: # %cond.end
; MIPS32-NEXT:    lw $1, 4($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    move $2, $1
; MIPS32-NEXT:    addiu $sp, $sp, 16
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  br i1 %cnd, label %cond.true, label %cond.false

cond.true:
  br label %cond.end

cond.false:
  br label %cond.end

cond.end:
  %cond = phi i16 [ %a, %cond.true ], [ %b, %cond.false ]
  ret i16 %cond
}

define i32 @phi_i32(i1 %cnd, i32 %a, i32 %b) {
; MIPS32-LABEL: phi_i32:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    addiu $sp, $sp, -16
; MIPS32-NEXT:    .cfi_def_cfa_offset 16
; MIPS32-NEXT:    ori $1, $zero, 1
; MIPS32-NEXT:    and $1, $4, $1
; MIPS32-NEXT:    sw $5, 12($sp) # 4-byte Folded Spill
; MIPS32-NEXT:    sw $6, 8($sp) # 4-byte Folded Spill
; MIPS32-NEXT:    bnez $1, $BB3_2
; MIPS32-NEXT:    nop
; MIPS32-NEXT:  # %bb.1: # %entry
; MIPS32-NEXT:    j $BB3_3
; MIPS32-NEXT:    nop
; MIPS32-NEXT:  $BB3_2: # %cond.true
; MIPS32-NEXT:    lw $1, 12($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    sw $1, 4($sp) # 4-byte Folded Spill
; MIPS32-NEXT:    j $BB3_4
; MIPS32-NEXT:    nop
; MIPS32-NEXT:  $BB3_3: # %cond.false
; MIPS32-NEXT:    lw $1, 8($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    sw $1, 4($sp) # 4-byte Folded Spill
; MIPS32-NEXT:  $BB3_4: # %cond.end
; MIPS32-NEXT:    lw $1, 4($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    move $2, $1
; MIPS32-NEXT:    addiu $sp, $sp, 16
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  br i1 %cnd, label %cond.true, label %cond.false

cond.true:
  br label %cond.end

cond.false:
  br label %cond.end

cond.end:
  %cond = phi i32 [ %a, %cond.true ], [ %b, %cond.false ]
  ret i32 %cond
}

define i64 @phi_i64(i1 %cnd, i64 %a, i64 %b) {
; MIPS32-LABEL: phi_i64:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    addiu $sp, $sp, -24
; MIPS32-NEXT:    .cfi_def_cfa_offset 24
; MIPS32-NEXT:    addiu $1, $sp, 40
; MIPS32-NEXT:    lw $1, 0($1)
; MIPS32-NEXT:    addiu $2, $sp, 44
; MIPS32-NEXT:    lw $2, 0($2)
; MIPS32-NEXT:    ori $3, $zero, 1
; MIPS32-NEXT:    and $3, $4, $3
; MIPS32-NEXT:    sw $1, 20($sp) # 4-byte Folded Spill
; MIPS32-NEXT:    sw $6, 16($sp) # 4-byte Folded Spill
; MIPS32-NEXT:    sw $7, 12($sp) # 4-byte Folded Spill
; MIPS32-NEXT:    sw $2, 8($sp) # 4-byte Folded Spill
; MIPS32-NEXT:    bnez $3, $BB4_2
; MIPS32-NEXT:    nop
; MIPS32-NEXT:  # %bb.1: # %entry
; MIPS32-NEXT:    j $BB4_3
; MIPS32-NEXT:    nop
; MIPS32-NEXT:  $BB4_2: # %cond.true
; MIPS32-NEXT:    lw $1, 16($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    lw $2, 12($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    sw $1, 4($sp) # 4-byte Folded Spill
; MIPS32-NEXT:    sw $2, 0($sp) # 4-byte Folded Spill
; MIPS32-NEXT:    j $BB4_4
; MIPS32-NEXT:    nop
; MIPS32-NEXT:  $BB4_3: # %cond.false
; MIPS32-NEXT:    lw $1, 20($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    lw $2, 8($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    sw $1, 4($sp) # 4-byte Folded Spill
; MIPS32-NEXT:    sw $2, 0($sp) # 4-byte Folded Spill
; MIPS32-NEXT:  $BB4_4: # %cond.end
; MIPS32-NEXT:    lw $1, 0($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    lw $2, 4($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    move $3, $1
; MIPS32-NEXT:    addiu $sp, $sp, 24
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  br i1 %cnd, label %cond.true, label %cond.false

cond.true:
  br label %cond.end

cond.false:
  br label %cond.end

cond.end:
  %cond = phi i64 [ %a, %cond.true ], [ %b, %cond.false ]
  ret i64 %cond
}

define float @phi_float(i1 %cnd, float %a, float %b) {
; MIPS32-LABEL: phi_float:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    addiu $sp, $sp, -16
; MIPS32-NEXT:    .cfi_def_cfa_offset 16
; MIPS32-NEXT:    mtc1 $5, $f0
; MIPS32-NEXT:    mtc1 $6, $f1
; MIPS32-NEXT:    ori $1, $zero, 1
; MIPS32-NEXT:    and $1, $4, $1
; MIPS32-NEXT:    swc1 $f0, 12($sp) # 4-byte Folded Spill
; MIPS32-NEXT:    swc1 $f1, 8($sp) # 4-byte Folded Spill
; MIPS32-NEXT:    bnez $1, $BB5_2
; MIPS32-NEXT:    nop
; MIPS32-NEXT:  # %bb.1: # %entry
; MIPS32-NEXT:    j $BB5_3
; MIPS32-NEXT:    nop
; MIPS32-NEXT:  $BB5_2: # %cond.true
; MIPS32-NEXT:    lwc1 $f0, 12($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    swc1 $f0, 4($sp) # 4-byte Folded Spill
; MIPS32-NEXT:    j $BB5_4
; MIPS32-NEXT:    nop
; MIPS32-NEXT:  $BB5_3: # %cond.false
; MIPS32-NEXT:    lwc1 $f0, 8($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    swc1 $f0, 4($sp) # 4-byte Folded Spill
; MIPS32-NEXT:  $BB5_4: # %cond.end
; MIPS32-NEXT:    lwc1 $f0, 4($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    addiu $sp, $sp, 16
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  br i1 %cnd, label %cond.true, label %cond.false

cond.true:
  br label %cond.end

cond.false:
  br label %cond.end

cond.end:
  %cond = phi float [ %a, %cond.true ], [ %b, %cond.false ]
  ret float %cond
}

define double @phi_double(double %a, double %b, i1 %cnd) {
; MIPS32-LABEL: phi_double:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    addiu $sp, $sp, -24
; MIPS32-NEXT:    .cfi_def_cfa_offset 24
; MIPS32-NEXT:    addiu $1, $sp, 40
; MIPS32-NEXT:    lw $1, 0($1)
; MIPS32-NEXT:    ori $2, $zero, 1
; MIPS32-NEXT:    and $1, $1, $2
; MIPS32-NEXT:    sdc1 $f12, 16($sp) # 8-byte Folded Spill
; MIPS32-NEXT:    sdc1 $f14, 8($sp) # 8-byte Folded Spill
; MIPS32-NEXT:    bnez $1, $BB6_2
; MIPS32-NEXT:    nop
; MIPS32-NEXT:  # %bb.1: # %entry
; MIPS32-NEXT:    j $BB6_3
; MIPS32-NEXT:    nop
; MIPS32-NEXT:  $BB6_2: # %cond.true
; MIPS32-NEXT:    ldc1 $f0, 16($sp) # 8-byte Folded Reload
; MIPS32-NEXT:    sdc1 $f0, 0($sp) # 8-byte Folded Spill
; MIPS32-NEXT:    j $BB6_4
; MIPS32-NEXT:    nop
; MIPS32-NEXT:  $BB6_3: # %cond.false
; MIPS32-NEXT:    ldc1 $f0, 8($sp) # 8-byte Folded Reload
; MIPS32-NEXT:    sdc1 $f0, 0($sp) # 8-byte Folded Spill
; MIPS32-NEXT:  $BB6_4: # %cond.end
; MIPS32-NEXT:    ldc1 $f0, 0($sp) # 8-byte Folded Reload
; MIPS32-NEXT:    addiu $sp, $sp, 24
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  br i1 %cnd, label %cond.true, label %cond.false

cond.true:
  br label %cond.end

cond.false:
  br label %cond.end

cond.end:
  %cond = phi double [ %a, %cond.true ], [ %b, %cond.false ]
  ret double %cond
}

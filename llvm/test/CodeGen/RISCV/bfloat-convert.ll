; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --version 2
; RUN: llc -mtriple=riscv32 -mattr=+experimental-zfbfmin -verify-machineinstrs \
; RUN:   -target-abi ilp32f < %s | FileCheck -check-prefixes=CHECK32,RV32IZFBFMIN %s
; RUN: llc -mtriple=riscv32 -mattr=+d,+experimental-zfbfmin -verify-machineinstrs \
; RUN:   -target-abi ilp32d < %s | FileCheck -check-prefixes=CHECK32,R32IDZFBFMIN %s
; RUN: llc -mtriple=riscv64 -mattr=+experimental-zfbfmin -verify-machineinstrs \
; RUN:   -target-abi lp64f < %s | FileCheck -check-prefixes=CHECK64,RV64IZFBFMIN %s
; RUN: llc -mtriple=riscv64 -mattr=+d,+experimental-zfbfmin -verify-machineinstrs \
; RUN:   -target-abi lp64f < %s | FileCheck -check-prefixes=CHECK64,RV64IDZFBFMIN %s

; These tests descend from float-arith.ll, where each function was targeted at
; a particular RISC-V FPU instruction.

define i16 @fcvt_si_bf16(bfloat %a) nounwind {
; CHECK32-LABEL: fcvt_si_bf16:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    fcvt.s.bf16 fa5, fa0, rne
; CHECK32-NEXT:    fcvt.w.s a0, fa5, rtz
; CHECK32-NEXT:    ret
;
; CHECK64-LABEL: fcvt_si_bf16:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    fcvt.s.bf16 fa5, fa0, rne
; CHECK64-NEXT:    fcvt.l.s a0, fa5, rtz
; CHECK64-NEXT:    ret
  %1 = fptosi bfloat %a to i16
  ret i16 %1
}

define i16 @fcvt_si_bf16_sat(bfloat %a) nounwind {
; CHECK32-LABEL: fcvt_si_bf16_sat:
; CHECK32:       # %bb.0: # %start
; CHECK32-NEXT:    fcvt.s.bf16 fa5, fa0
; CHECK32-NEXT:    feq.s a0, fa5, fa5
; CHECK32-NEXT:    neg a0, a0
; CHECK32-NEXT:    lui a1, %hi(.LCPI1_0)
; CHECK32-NEXT:    flw fa4, %lo(.LCPI1_0)(a1)
; CHECK32-NEXT:    lui a1, 815104
; CHECK32-NEXT:    fmv.w.x fa3, a1
; CHECK32-NEXT:    fmax.s fa5, fa5, fa3
; CHECK32-NEXT:    fmin.s fa5, fa5, fa4
; CHECK32-NEXT:    fcvt.w.s a1, fa5, rtz
; CHECK32-NEXT:    and a0, a0, a1
; CHECK32-NEXT:    ret
;
; CHECK64-LABEL: fcvt_si_bf16_sat:
; CHECK64:       # %bb.0: # %start
; CHECK64-NEXT:    fcvt.s.bf16 fa5, fa0
; CHECK64-NEXT:    feq.s a0, fa5, fa5
; CHECK64-NEXT:    lui a1, %hi(.LCPI1_0)
; CHECK64-NEXT:    flw fa4, %lo(.LCPI1_0)(a1)
; CHECK64-NEXT:    lui a1, 815104
; CHECK64-NEXT:    fmv.w.x fa3, a1
; CHECK64-NEXT:    fmax.s fa5, fa5, fa3
; CHECK64-NEXT:    neg a0, a0
; CHECK64-NEXT:    fmin.s fa5, fa5, fa4
; CHECK64-NEXT:    fcvt.l.s a1, fa5, rtz
; CHECK64-NEXT:    and a0, a0, a1
; CHECK64-NEXT:    ret
start:
  %0 = tail call i16 @llvm.fptosi.sat.i16.bf16(bfloat %a)
  ret i16 %0
}
declare i16 @llvm.fptosi.sat.i16.bf16(bfloat)

define i16 @fcvt_ui_bf16(bfloat %a) nounwind {
; CHECK32-LABEL: fcvt_ui_bf16:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    fcvt.s.bf16 fa5, fa0, rne
; CHECK32-NEXT:    fcvt.wu.s a0, fa5, rtz
; CHECK32-NEXT:    ret
;
; CHECK64-LABEL: fcvt_ui_bf16:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    fcvt.s.bf16 fa5, fa0, rne
; CHECK64-NEXT:    fcvt.lu.s a0, fa5, rtz
; CHECK64-NEXT:    ret
  %1 = fptoui bfloat %a to i16
  ret i16 %1
}

define i16 @fcvt_ui_bf16_sat(bfloat %a) nounwind {
; CHECK32-LABEL: fcvt_ui_bf16_sat:
; CHECK32:       # %bb.0: # %start
; CHECK32-NEXT:    lui a0, %hi(.LCPI3_0)
; CHECK32-NEXT:    flw fa5, %lo(.LCPI3_0)(a0)
; CHECK32-NEXT:    fcvt.s.bf16 fa4, fa0
; CHECK32-NEXT:    fmv.w.x fa3, zero
; CHECK32-NEXT:    fmax.s fa4, fa4, fa3
; CHECK32-NEXT:    fmin.s fa5, fa4, fa5
; CHECK32-NEXT:    fcvt.wu.s a0, fa5, rtz
; CHECK32-NEXT:    ret
;
; CHECK64-LABEL: fcvt_ui_bf16_sat:
; CHECK64:       # %bb.0: # %start
; CHECK64-NEXT:    lui a0, %hi(.LCPI3_0)
; CHECK64-NEXT:    flw fa5, %lo(.LCPI3_0)(a0)
; CHECK64-NEXT:    fcvt.s.bf16 fa4, fa0
; CHECK64-NEXT:    fmv.w.x fa3, zero
; CHECK64-NEXT:    fmax.s fa4, fa4, fa3
; CHECK64-NEXT:    fmin.s fa5, fa4, fa5
; CHECK64-NEXT:    fcvt.lu.s a0, fa5, rtz
; CHECK64-NEXT:    ret
start:
  %0 = tail call i16 @llvm.fptoui.sat.i16.bf16(bfloat %a)
  ret i16 %0
}
declare i16 @llvm.fptoui.sat.i16.bf16(bfloat)

define i32 @fcvt_w_bf16(bfloat %a) nounwind {
; CHECK32-LABEL: fcvt_w_bf16:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    fcvt.s.bf16 fa5, fa0, rne
; CHECK32-NEXT:    fcvt.w.s a0, fa5, rtz
; CHECK32-NEXT:    ret
;
; CHECK64-LABEL: fcvt_w_bf16:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    fcvt.s.bf16 fa5, fa0
; CHECK64-NEXT:    fcvt.w.s a0, fa5, rtz
; CHECK64-NEXT:    ret
  %1 = fptosi bfloat %a to i32
  ret i32 %1
}

define i32 @fcvt_w_bf16_sat(bfloat %a) nounwind {
; CHECK32-LABEL: fcvt_w_bf16_sat:
; CHECK32:       # %bb.0: # %start
; CHECK32-NEXT:    fcvt.s.bf16 fa5, fa0
; CHECK32-NEXT:    fcvt.w.s a0, fa5, rtz
; CHECK32-NEXT:    feq.s a1, fa5, fa5
; CHECK32-NEXT:    seqz a1, a1
; CHECK32-NEXT:    addi a1, a1, -1
; CHECK32-NEXT:    and a0, a1, a0
; CHECK32-NEXT:    ret
;
; CHECK64-LABEL: fcvt_w_bf16_sat:
; CHECK64:       # %bb.0: # %start
; CHECK64-NEXT:    fcvt.s.bf16 fa5, fa0
; CHECK64-NEXT:    fcvt.w.s a0, fa5, rtz
; CHECK64-NEXT:    feq.s a1, fa5, fa5
; CHECK64-NEXT:    seqz a1, a1
; CHECK64-NEXT:    addi a1, a1, -1
; CHECK64-NEXT:    and a0, a1, a0
; CHECK64-NEXT:    ret
start:
  %0 = tail call i32 @llvm.fptosi.sat.i32.bf16(bfloat %a)
  ret i32 %0
}
declare i32 @llvm.fptosi.sat.i32.bf16(bfloat)

define i32 @fcvt_wu_bf16(bfloat %a) nounwind {
; CHECK32-LABEL: fcvt_wu_bf16:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    fcvt.s.bf16 fa5, fa0, rne
; CHECK32-NEXT:    fcvt.wu.s a0, fa5, rtz
; CHECK32-NEXT:    ret
;
; CHECK64-LABEL: fcvt_wu_bf16:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    fcvt.s.bf16 fa5, fa0
; CHECK64-NEXT:    fcvt.wu.s a0, fa5, rtz
; CHECK64-NEXT:    ret
  %1 = fptoui bfloat %a to i32
  ret i32 %1
}

define i32 @fcvt_wu_bf16_multiple_use(bfloat %x, ptr %y) nounwind {
; CHECK32-LABEL: fcvt_wu_bf16_multiple_use:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    fcvt.s.bf16 fa5, fa0, rne
; CHECK32-NEXT:    fcvt.wu.s a0, fa5, rtz
; CHECK32-NEXT:    seqz a1, a0
; CHECK32-NEXT:    add a0, a0, a1
; CHECK32-NEXT:    ret
;
; CHECK64-LABEL: fcvt_wu_bf16_multiple_use:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    fcvt.s.bf16 fa5, fa0
; CHECK64-NEXT:    fcvt.wu.s a0, fa5, rtz
; CHECK64-NEXT:    seqz a1, a0
; CHECK64-NEXT:    add a0, a0, a1
; CHECK64-NEXT:    ret
  %a = fptoui bfloat %x to i32
  %b = icmp eq i32 %a, 0
  %c = select i1 %b, i32 1, i32 %a
  ret i32 %c
}

define i32 @fcvt_wu_bf16_sat(bfloat %a) nounwind {
; CHECK32-LABEL: fcvt_wu_bf16_sat:
; CHECK32:       # %bb.0: # %start
; CHECK32-NEXT:    fcvt.s.bf16 fa5, fa0
; CHECK32-NEXT:    fcvt.wu.s a0, fa5, rtz
; CHECK32-NEXT:    feq.s a1, fa5, fa5
; CHECK32-NEXT:    seqz a1, a1
; CHECK32-NEXT:    addi a1, a1, -1
; CHECK32-NEXT:    and a0, a1, a0
; CHECK32-NEXT:    ret
;
; CHECK64-LABEL: fcvt_wu_bf16_sat:
; CHECK64:       # %bb.0: # %start
; CHECK64-NEXT:    fcvt.s.bf16 fa5, fa0
; CHECK64-NEXT:    fcvt.wu.s a0, fa5, rtz
; CHECK64-NEXT:    feq.s a1, fa5, fa5
; CHECK64-NEXT:    seqz a1, a1
; CHECK64-NEXT:    addiw a1, a1, -1
; CHECK64-NEXT:    and a0, a0, a1
; CHECK64-NEXT:    slli a0, a0, 32
; CHECK64-NEXT:    srli a0, a0, 32
; CHECK64-NEXT:    ret
start:
  %0 = tail call i32 @llvm.fptoui.sat.i32.bf16(bfloat %a)
  ret i32 %0
}
declare i32 @llvm.fptoui.sat.i32.bf16(bfloat)

; TODO: The following tests error on rv32.

; define i64 @fcvt_l_bf16(bfloat %a) nounwind {
;   %1 = fptosi bfloat %a to i64
;   ret i64 %1
; }

; define i64 @fcvt_l_bf16_sat(bfloat %a) nounwind {
; start:
;   %0 = tail call i64 @llvm.fptosi.sat.i64.bf16(bfloat %a)
;   ret i64 %0
; }
; declare i64 @llvm.fptosi.sat.i64.bf16(bfloat)

; define i64 @fcvt_lu_bf16(bfloat %a) nounwind {
;   %1 = fptoui bfloat %a to i64
;   ret i64 %1
; }

; define i64 @fcvt_lu_bf16_sat(bfloat %a) nounwind {
; start:
;   %0 = tail call i64 @llvm.fptoui.sat.i64.bf16(bfloat %a)
;   ret i64 %0
; }
; declare i64 @llvm.fptoui.sat.i64.bf16(bfloat)

define bfloat @fcvt_bf16_si(i16 %a) nounwind {
; CHECK32-LABEL: fcvt_bf16_si:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    slli a0, a0, 16
; CHECK32-NEXT:    srai a0, a0, 16
; CHECK32-NEXT:    fcvt.s.w fa5, a0
; CHECK32-NEXT:    fcvt.bf16.s fa0, fa5
; CHECK32-NEXT:    ret
;
; CHECK64-LABEL: fcvt_bf16_si:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    slli a0, a0, 48
; CHECK64-NEXT:    srai a0, a0, 48
; CHECK64-NEXT:    fcvt.s.l fa5, a0
; CHECK64-NEXT:    fcvt.bf16.s fa0, fa5
; CHECK64-NEXT:    ret
  %1 = sitofp i16 %a to bfloat
  ret bfloat %1
}

define bfloat @fcvt_bf16_si_signext(i16 signext %a) nounwind {
; CHECK32-LABEL: fcvt_bf16_si_signext:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    fcvt.s.w fa5, a0
; CHECK32-NEXT:    fcvt.bf16.s fa0, fa5
; CHECK32-NEXT:    ret
;
; CHECK64-LABEL: fcvt_bf16_si_signext:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    fcvt.s.l fa5, a0
; CHECK64-NEXT:    fcvt.bf16.s fa0, fa5
; CHECK64-NEXT:    ret
  %1 = sitofp i16 %a to bfloat
  ret bfloat %1
}

define bfloat @fcvt_bf16_ui(i16 %a) nounwind {
; CHECK32-LABEL: fcvt_bf16_ui:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    slli a0, a0, 16
; CHECK32-NEXT:    srli a0, a0, 16
; CHECK32-NEXT:    fcvt.s.wu fa5, a0
; CHECK32-NEXT:    fcvt.bf16.s fa0, fa5
; CHECK32-NEXT:    ret
;
; CHECK64-LABEL: fcvt_bf16_ui:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    slli a0, a0, 48
; CHECK64-NEXT:    srli a0, a0, 48
; CHECK64-NEXT:    fcvt.s.lu fa5, a0
; CHECK64-NEXT:    fcvt.bf16.s fa0, fa5
; CHECK64-NEXT:    ret
  %1 = uitofp i16 %a to bfloat
  ret bfloat %1
}

define bfloat @fcvt_bf16_ui_zeroext(i16 zeroext %a) nounwind {
; CHECK32-LABEL: fcvt_bf16_ui_zeroext:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    fcvt.s.wu fa5, a0
; CHECK32-NEXT:    fcvt.bf16.s fa0, fa5
; CHECK32-NEXT:    ret
;
; CHECK64-LABEL: fcvt_bf16_ui_zeroext:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    fcvt.s.lu fa5, a0
; CHECK64-NEXT:    fcvt.bf16.s fa0, fa5
; CHECK64-NEXT:    ret
  %1 = uitofp i16 %a to bfloat
  ret bfloat %1
}

define bfloat @fcvt_bf16_w(i32 %a) nounwind {
; CHECK32-LABEL: fcvt_bf16_w:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    fcvt.s.w fa5, a0
; CHECK32-NEXT:    fcvt.bf16.s fa0, fa5
; CHECK32-NEXT:    ret
;
; CHECK64-LABEL: fcvt_bf16_w:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    sext.w a0, a0
; CHECK64-NEXT:    fcvt.s.l fa5, a0
; CHECK64-NEXT:    fcvt.bf16.s fa0, fa5
; CHECK64-NEXT:    ret
  %1 = sitofp i32 %a to bfloat
  ret bfloat %1
}

define bfloat @fcvt_bf16_w_load(ptr %p) nounwind {
; CHECK32-LABEL: fcvt_bf16_w_load:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    lw a0, 0(a0)
; CHECK32-NEXT:    fcvt.s.w fa5, a0
; CHECK32-NEXT:    fcvt.bf16.s fa0, fa5
; CHECK32-NEXT:    ret
;
; CHECK64-LABEL: fcvt_bf16_w_load:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    lw a0, 0(a0)
; CHECK64-NEXT:    fcvt.s.l fa5, a0
; CHECK64-NEXT:    fcvt.bf16.s fa0, fa5
; CHECK64-NEXT:    ret
  %a = load i32, ptr %p
  %1 = sitofp i32 %a to bfloat
  ret bfloat %1
}

define bfloat @fcvt_bf16_wu(i32 %a) nounwind {
; CHECK32-LABEL: fcvt_bf16_wu:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    fcvt.s.wu fa5, a0
; CHECK32-NEXT:    fcvt.bf16.s fa0, fa5
; CHECK32-NEXT:    ret
;
; CHECK64-LABEL: fcvt_bf16_wu:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    slli a0, a0, 32
; CHECK64-NEXT:    srli a0, a0, 32
; CHECK64-NEXT:    fcvt.s.lu fa5, a0
; CHECK64-NEXT:    fcvt.bf16.s fa0, fa5
; CHECK64-NEXT:    ret
  %1 = uitofp i32 %a to bfloat
  ret bfloat %1
}

define bfloat @fcvt_bf16_wu_load(ptr %p) nounwind {
; CHECK32-LABEL: fcvt_bf16_wu_load:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    lw a0, 0(a0)
; CHECK32-NEXT:    fcvt.s.wu fa5, a0
; CHECK32-NEXT:    fcvt.bf16.s fa0, fa5
; CHECK32-NEXT:    ret
;
; CHECK64-LABEL: fcvt_bf16_wu_load:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    lwu a0, 0(a0)
; CHECK64-NEXT:    fcvt.s.lu fa5, a0
; CHECK64-NEXT:    fcvt.bf16.s fa0, fa5
; CHECK64-NEXT:    ret
  %a = load i32, ptr %p
  %1 = uitofp i32 %a to bfloat
  ret bfloat %1
}

; TODO: The following tests error on rv32.

; define bfloat @fcvt_bf16_l(i64 %a) nounwind {
;   %1 = sitofp i64 %a to bfloat
;   ret bfloat %1
; }

; define bfloat @fcvt_bf16_lu(i64 %a) nounwind {
;   %1 = uitofp i64 %a to bfloat
;   ret bfloat %1
; }

define bfloat @fcvt_bf16_s(float %a) nounwind {
; CHECK32-LABEL: fcvt_bf16_s:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    fcvt.bf16.s fa0, fa0
; CHECK32-NEXT:    ret
;
; CHECK64-LABEL: fcvt_bf16_s:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    fcvt.bf16.s fa0, fa0
; CHECK64-NEXT:    ret
  %1 = fptrunc float %a to bfloat
  ret bfloat %1
}

define float @fcvt_s_bf16(bfloat %a) nounwind {
; CHECK32-LABEL: fcvt_s_bf16:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    fcvt.s.bf16 fa0, fa0
; CHECK32-NEXT:    ret
;
; CHECK64-LABEL: fcvt_s_bf16:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    fcvt.s.bf16 fa0, fa0
; CHECK64-NEXT:    ret
  %1 = fpext bfloat %a to float
  ret float %1
}

define bfloat @fcvt_bf16_d(double %a) nounwind {
; RV32IZFBFMIN-LABEL: fcvt_bf16_d:
; RV32IZFBFMIN:       # %bb.0:
; RV32IZFBFMIN-NEXT:    addi sp, sp, -16
; RV32IZFBFMIN-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IZFBFMIN-NEXT:    call __truncdfbf2@plt
; RV32IZFBFMIN-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32IZFBFMIN-NEXT:    addi sp, sp, 16
; RV32IZFBFMIN-NEXT:    ret
;
; R32IDZFBFMIN-LABEL: fcvt_bf16_d:
; R32IDZFBFMIN:       # %bb.0:
; R32IDZFBFMIN-NEXT:    fcvt.s.d fa5, fa0
; R32IDZFBFMIN-NEXT:    fcvt.bf16.s fa0, fa5
; R32IDZFBFMIN-NEXT:    ret
;
; RV64IZFBFMIN-LABEL: fcvt_bf16_d:
; RV64IZFBFMIN:       # %bb.0:
; RV64IZFBFMIN-NEXT:    addi sp, sp, -16
; RV64IZFBFMIN-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64IZFBFMIN-NEXT:    call __truncdfbf2@plt
; RV64IZFBFMIN-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64IZFBFMIN-NEXT:    addi sp, sp, 16
; RV64IZFBFMIN-NEXT:    ret
;
; RV64IDZFBFMIN-LABEL: fcvt_bf16_d:
; RV64IDZFBFMIN:       # %bb.0:
; RV64IDZFBFMIN-NEXT:    fmv.d.x fa5, a0
; RV64IDZFBFMIN-NEXT:    fcvt.s.d fa5, fa5
; RV64IDZFBFMIN-NEXT:    fcvt.bf16.s fa0, fa5
; RV64IDZFBFMIN-NEXT:    ret
  %1 = fptrunc double %a to bfloat
  ret bfloat %1
}

define double @fcvt_d_bf16(bfloat %a) nounwind {
; RV32IZFBFMIN-LABEL: fcvt_d_bf16:
; RV32IZFBFMIN:       # %bb.0:
; RV32IZFBFMIN-NEXT:    addi sp, sp, -16
; RV32IZFBFMIN-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IZFBFMIN-NEXT:    fcvt.s.bf16 fa0, fa0
; RV32IZFBFMIN-NEXT:    call __extendsfdf2@plt
; RV32IZFBFMIN-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32IZFBFMIN-NEXT:    addi sp, sp, 16
; RV32IZFBFMIN-NEXT:    ret
;
; R32IDZFBFMIN-LABEL: fcvt_d_bf16:
; R32IDZFBFMIN:       # %bb.0:
; R32IDZFBFMIN-NEXT:    fcvt.s.bf16 fa5, fa0
; R32IDZFBFMIN-NEXT:    fcvt.d.s fa0, fa5
; R32IDZFBFMIN-NEXT:    ret
;
; RV64IZFBFMIN-LABEL: fcvt_d_bf16:
; RV64IZFBFMIN:       # %bb.0:
; RV64IZFBFMIN-NEXT:    addi sp, sp, -16
; RV64IZFBFMIN-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64IZFBFMIN-NEXT:    fcvt.s.bf16 fa0, fa0
; RV64IZFBFMIN-NEXT:    call __extendsfdf2@plt
; RV64IZFBFMIN-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64IZFBFMIN-NEXT:    addi sp, sp, 16
; RV64IZFBFMIN-NEXT:    ret
;
; RV64IDZFBFMIN-LABEL: fcvt_d_bf16:
; RV64IDZFBFMIN:       # %bb.0:
; RV64IDZFBFMIN-NEXT:    fcvt.s.bf16 fa5, fa0
; RV64IDZFBFMIN-NEXT:    fcvt.d.s fa5, fa5
; RV64IDZFBFMIN-NEXT:    fmv.x.d a0, fa5
; RV64IDZFBFMIN-NEXT:    ret
  %1 = fpext bfloat %a to double
  ret double %1
}

define bfloat @bitcast_bf16_i16(i16 %a) nounwind {
; CHECK32-LABEL: bitcast_bf16_i16:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    fmv.h.x fa0, a0
; CHECK32-NEXT:    ret
;
; CHECK64-LABEL: bitcast_bf16_i16:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    fmv.h.x fa0, a0
; CHECK64-NEXT:    ret
  %1 = bitcast i16 %a to bfloat
  ret bfloat %1
}

define i16 @bitcast_i16_bf16(bfloat %a) nounwind {
; CHECK32-LABEL: bitcast_i16_bf16:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    fmv.x.h a0, fa0
; CHECK32-NEXT:    ret
;
; CHECK64-LABEL: bitcast_i16_bf16:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    fmv.x.h a0, fa0
; CHECK64-NEXT:    ret
  %1 = bitcast bfloat %a to i16
  ret i16 %1
}

define signext i32 @fcvt_bf16_w_demanded_bits(i32 signext %0, ptr %1) nounwind {
; CHECK32-LABEL: fcvt_bf16_w_demanded_bits:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    addi a0, a0, 1
; CHECK32-NEXT:    fcvt.s.w fa5, a0
; CHECK32-NEXT:    fcvt.bf16.s fa5, fa5
; CHECK32-NEXT:    fsh fa5, 0(a1)
; CHECK32-NEXT:    ret
;
; CHECK64-LABEL: fcvt_bf16_w_demanded_bits:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    addiw a0, a0, 1
; CHECK64-NEXT:    fcvt.s.l fa5, a0
; CHECK64-NEXT:    fcvt.bf16.s fa5, fa5
; CHECK64-NEXT:    fsh fa5, 0(a1)
; CHECK64-NEXT:    ret
  %3 = add i32 %0, 1
  %4 = sitofp i32 %3 to bfloat
  store bfloat %4, ptr %1, align 2
  ret i32 %3
}

define signext i32 @fcvt_bf16_wu_demanded_bits(i32 signext %0, ptr %1) nounwind {
; CHECK32-LABEL: fcvt_bf16_wu_demanded_bits:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    addi a0, a0, 1
; CHECK32-NEXT:    fcvt.s.wu fa5, a0
; CHECK32-NEXT:    fcvt.bf16.s fa5, fa5
; CHECK32-NEXT:    fsh fa5, 0(a1)
; CHECK32-NEXT:    ret
;
; CHECK64-LABEL: fcvt_bf16_wu_demanded_bits:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    addiw a0, a0, 1
; CHECK64-NEXT:    slli a2, a0, 32
; CHECK64-NEXT:    srli a2, a2, 32
; CHECK64-NEXT:    fcvt.s.lu fa5, a2
; CHECK64-NEXT:    fcvt.bf16.s fa5, fa5
; CHECK64-NEXT:    fsh fa5, 0(a1)
; CHECK64-NEXT:    ret
  %3 = add i32 %0, 1
  %4 = uitofp i32 %3 to bfloat
  store bfloat %4, ptr %1, align 2
  ret i32 %3
}

define signext i8 @fcvt_w_s_i8(bfloat %a) nounwind {
; CHECK32-LABEL: fcvt_w_s_i8:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    fcvt.s.bf16 fa5, fa0, rne
; CHECK32-NEXT:    fcvt.w.s a0, fa5, rtz
; CHECK32-NEXT:    ret
;
; CHECK64-LABEL: fcvt_w_s_i8:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    fcvt.s.bf16 fa5, fa0, rne
; CHECK64-NEXT:    fcvt.l.s a0, fa5, rtz
; CHECK64-NEXT:    ret
  %1 = fptosi bfloat %a to i8
  ret i8 %1
}

define signext i8 @fcvt_w_s_sat_i8(bfloat %a) nounwind {
; CHECK32-LABEL: fcvt_w_s_sat_i8:
; CHECK32:       # %bb.0: # %start
; CHECK32-NEXT:    fcvt.s.bf16 fa5, fa0
; CHECK32-NEXT:    feq.s a0, fa5, fa5
; CHECK32-NEXT:    neg a0, a0
; CHECK32-NEXT:    lui a1, 798720
; CHECK32-NEXT:    fmv.w.x fa4, a1
; CHECK32-NEXT:    fmax.s fa5, fa5, fa4
; CHECK32-NEXT:    lui a1, 274400
; CHECK32-NEXT:    fmv.w.x fa4, a1
; CHECK32-NEXT:    fmin.s fa5, fa5, fa4
; CHECK32-NEXT:    fcvt.w.s a1, fa5, rtz
; CHECK32-NEXT:    and a0, a0, a1
; CHECK32-NEXT:    ret
;
; CHECK64-LABEL: fcvt_w_s_sat_i8:
; CHECK64:       # %bb.0: # %start
; CHECK64-NEXT:    fcvt.s.bf16 fa5, fa0
; CHECK64-NEXT:    feq.s a0, fa5, fa5
; CHECK64-NEXT:    neg a0, a0
; CHECK64-NEXT:    lui a1, 798720
; CHECK64-NEXT:    fmv.w.x fa4, a1
; CHECK64-NEXT:    fmax.s fa5, fa5, fa4
; CHECK64-NEXT:    lui a1, 274400
; CHECK64-NEXT:    fmv.w.x fa4, a1
; CHECK64-NEXT:    fmin.s fa5, fa5, fa4
; CHECK64-NEXT:    fcvt.l.s a1, fa5, rtz
; CHECK64-NEXT:    and a0, a0, a1
; CHECK64-NEXT:    ret
start:
  %0 = tail call i8 @llvm.fptosi.sat.i8.bf16(bfloat %a)
  ret i8 %0
}
declare i8 @llvm.fptosi.sat.i8.bf16(bfloat)

define zeroext i8 @fcvt_wu_s_i8(bfloat %a) nounwind {
; CHECK32-LABEL: fcvt_wu_s_i8:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    fcvt.s.bf16 fa5, fa0, rne
; CHECK32-NEXT:    fcvt.wu.s a0, fa5, rtz
; CHECK32-NEXT:    ret
;
; CHECK64-LABEL: fcvt_wu_s_i8:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    fcvt.s.bf16 fa5, fa0, rne
; CHECK64-NEXT:    fcvt.lu.s a0, fa5, rtz
; CHECK64-NEXT:    ret
  %1 = fptoui bfloat %a to i8
  ret i8 %1
}

define zeroext i8 @fcvt_wu_s_sat_i8(bfloat %a) nounwind {
; CHECK32-LABEL: fcvt_wu_s_sat_i8:
; CHECK32:       # %bb.0: # %start
; CHECK32-NEXT:    fcvt.s.bf16 fa5, fa0
; CHECK32-NEXT:    fmv.w.x fa4, zero
; CHECK32-NEXT:    fmax.s fa5, fa5, fa4
; CHECK32-NEXT:    lui a0, 276464
; CHECK32-NEXT:    fmv.w.x fa4, a0
; CHECK32-NEXT:    fmin.s fa5, fa5, fa4
; CHECK32-NEXT:    fcvt.wu.s a0, fa5, rtz
; CHECK32-NEXT:    ret
;
; CHECK64-LABEL: fcvt_wu_s_sat_i8:
; CHECK64:       # %bb.0: # %start
; CHECK64-NEXT:    fcvt.s.bf16 fa5, fa0
; CHECK64-NEXT:    fmv.w.x fa4, zero
; CHECK64-NEXT:    fmax.s fa5, fa5, fa4
; CHECK64-NEXT:    lui a0, 276464
; CHECK64-NEXT:    fmv.w.x fa4, a0
; CHECK64-NEXT:    fmin.s fa5, fa5, fa4
; CHECK64-NEXT:    fcvt.lu.s a0, fa5, rtz
; CHECK64-NEXT:    ret
start:
  %0 = tail call i8 @llvm.fptoui.sat.i8.bf16(bfloat %a)
  ret i8 %0
}
declare i8 @llvm.fptoui.sat.i8.bf16(bfloat)

define zeroext i32 @fcvt_wu_bf16_sat_zext(bfloat %a) nounwind {
; CHECK32-LABEL: fcvt_wu_bf16_sat_zext:
; CHECK32:       # %bb.0: # %start
; CHECK32-NEXT:    fcvt.s.bf16 fa5, fa0
; CHECK32-NEXT:    fcvt.wu.s a0, fa5, rtz
; CHECK32-NEXT:    feq.s a1, fa5, fa5
; CHECK32-NEXT:    seqz a1, a1
; CHECK32-NEXT:    addi a1, a1, -1
; CHECK32-NEXT:    and a0, a1, a0
; CHECK32-NEXT:    ret
;
; CHECK64-LABEL: fcvt_wu_bf16_sat_zext:
; CHECK64:       # %bb.0: # %start
; CHECK64-NEXT:    fcvt.s.bf16 fa5, fa0
; CHECK64-NEXT:    fcvt.wu.s a0, fa5, rtz
; CHECK64-NEXT:    feq.s a1, fa5, fa5
; CHECK64-NEXT:    seqz a1, a1
; CHECK64-NEXT:    addiw a1, a1, -1
; CHECK64-NEXT:    and a0, a0, a1
; CHECK64-NEXT:    slli a0, a0, 32
; CHECK64-NEXT:    srli a0, a0, 32
; CHECK64-NEXT:    ret
start:
  %0 = tail call i32 @llvm.fptoui.sat.i32.bf16(bfloat %a)
  ret i32 %0
}

define signext i32 @fcvt_w_bf16_sat_sext(bfloat %a) nounwind {
; CHECK32-LABEL: fcvt_w_bf16_sat_sext:
; CHECK32:       # %bb.0: # %start
; CHECK32-NEXT:    fcvt.s.bf16 fa5, fa0
; CHECK32-NEXT:    fcvt.w.s a0, fa5, rtz
; CHECK32-NEXT:    feq.s a1, fa5, fa5
; CHECK32-NEXT:    seqz a1, a1
; CHECK32-NEXT:    addi a1, a1, -1
; CHECK32-NEXT:    and a0, a1, a0
; CHECK32-NEXT:    ret
;
; CHECK64-LABEL: fcvt_w_bf16_sat_sext:
; CHECK64:       # %bb.0: # %start
; CHECK64-NEXT:    fcvt.s.bf16 fa5, fa0
; CHECK64-NEXT:    fcvt.w.s a0, fa5, rtz
; CHECK64-NEXT:    feq.s a1, fa5, fa5
; CHECK64-NEXT:    seqz a1, a1
; CHECK64-NEXT:    addi a1, a1, -1
; CHECK64-NEXT:    and a0, a1, a0
; CHECK64-NEXT:    ret
start:
  %0 = tail call i32 @llvm.fptosi.sat.i32.bf16(bfloat %a)
  ret i32 %0
}

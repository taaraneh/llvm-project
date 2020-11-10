; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-- -mattr=sse2 | FileCheck %s
; RUN: llc < %s -mtriple=i686-- -mattr=sse2 -O0 | FileCheck %s

@x = external global double

define void @foo() nounwind  {
; CHECK-LABEL: foo:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    xorps %xmm0, %xmm0
; CHECK-NEXT:    movsd %xmm0, x
; CHECK-NEXT:    movsd %xmm0, x
; CHECK-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    retl
  %a = load volatile double, double* @x
  store volatile double 0.0, double* @x
  store volatile double 0.0, double* @x
  %b = load volatile double, double* @x
  ret void
}

define void @bar() nounwind  {
; CHECK-LABEL: bar:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    retl
  %c = load volatile double, double* @x
  ret void
}

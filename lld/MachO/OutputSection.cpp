//===- OutputSection.cpp --------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "OutputSection.h"
#include "OutputSegment.h"
#include "lld/Common/ErrorHandler.h"

using namespace llvm;
using namespace lld;
using namespace lld::macho;

uint64_t OutputSection::getSegmentOffset() const {
  return addr - parent->firstSection()->addr;
}

void OutputSection::mergeInput(InputSection *input) {
  llvm_unreachable("Cannot merge input section into unmergable output section");
}

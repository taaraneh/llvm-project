//===- DriverUtils.cpp ----------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "Driver.h"
#include "InputFiles.h"

#include "lld/Common/Args.h"
#include "lld/Common/ErrorHandler.h"
#include "lld/Common/Memory.h"
#include "lld/Common/Reproduce.h"
#include "llvm/Option/Arg.h"
#include "llvm/Option/ArgList.h"
#include "llvm/Option/Option.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Path.h"
#include "llvm/TextAPI/MachO/TextAPIReader.h"

using namespace llvm;
using namespace llvm::MachO;
using namespace llvm::opt;
using namespace llvm::sys;
using namespace lld;
using namespace lld::macho;

// Create prefix string literals used in Options.td
#define PREFIX(NAME, VALUE) const char *NAME[] = VALUE;
#include "Options.inc"
#undef PREFIX

// Create table mapping all options defined in Options.td
static const opt::OptTable::Info optInfo[] = {
#define OPTION(X1, X2, ID, KIND, GROUP, ALIAS, X7, X8, X9, X10, X11, X12)      \
  {X1, X2, X10,         X11,         OPT_##ID, opt::Option::KIND##Class,       \
   X9, X8, OPT_##GROUP, OPT_##ALIAS, X7,       X12},
#include "Options.inc"
#undef OPTION
};

MachOOptTable::MachOOptTable() : OptTable(optInfo) {}

// Set color diagnostics according to --color-diagnostics={auto,always,never}
// or --no-color-diagnostics flags.
static void handleColorDiagnostics(opt::InputArgList &args) {
  auto *arg = args.getLastArg(OPT_color_diagnostics, OPT_color_diagnostics_eq,
                              OPT_no_color_diagnostics);
  if (!arg)
    return;
  if (arg->getOption().getID() == OPT_color_diagnostics) {
    lld::errs().enable_colors(true);
  } else if (arg->getOption().getID() == OPT_no_color_diagnostics) {
    lld::errs().enable_colors(false);
  } else {
    StringRef s = arg->getValue();
    if (s == "always")
      lld::errs().enable_colors(true);
    else if (s == "never")
      lld::errs().enable_colors(false);
    else if (s != "auto")
      error("unknown option: --color-diagnostics=" + s);
  }
}

opt::InputArgList MachOOptTable::parse(ArrayRef<const char *> argv) {
  // Make InputArgList from string vectors.
  unsigned missingIndex;
  unsigned missingCount;
  SmallVector<const char *, 256> vec(argv.data(), argv.data() + argv.size());

  // Expand response files (arguments in the form of @<filename>)
  // and then parse the argument again.
  cl::ExpandResponseFiles(saver, cl::TokenizeGNUCommandLine, vec);
  opt::InputArgList args = ParseArgs(vec, missingIndex, missingCount);

  if (missingCount)
    error(Twine(args.getArgString(missingIndex)) + ": missing argument");

  handleColorDiagnostics(args);

  for (opt::Arg *arg : args.filtered(OPT_UNKNOWN)) {
    std::string nearest;
    if (findNearest(arg->getAsString(args), nearest) > 1)
      error("unknown argument '" + arg->getAsString(args) + "'");
    else
      error("unknown argument '" + arg->getAsString(args) +
            "', did you mean '" + nearest + "'");
  }
  return args;
}

void MachOOptTable::printHelp(const char *argv0, bool showHidden) const {
  PrintHelp(lld::outs(), (std::string(argv0) + " [options] file...").c_str(),
            "LLVM Linker", showHidden);
  lld::outs() << "\n";
}

static std::string rewritePath(StringRef s) {
  if (fs::exists(s))
    return relativeToRoot(s);
  return std::string(s);
}

// Reconstructs command line arguments so that so that you can re-run
// the same command with the same inputs. This is for --reproduce.
std::string macho::createResponseFile(const opt::InputArgList &args) {
  SmallString<0> data;
  raw_svector_ostream os(data);

  // Copy the command line to the output while rewriting paths.
  for (auto *arg : args) {
    switch (arg->getOption().getID()) {
    case OPT_reproduce:
      break;
    case OPT_INPUT:
      os << quote(rewritePath(arg->getValue())) << "\n";
      break;
    case OPT_o:
      os << "-o " << quote(path::filename(arg->getValue())) << "\n";
      break;
    case OPT_filelist:
      if (Optional<MemoryBufferRef> buffer = readFile(arg->getValue()))
        for (StringRef path : args::getLines(*buffer))
          os << quote(rewritePath(path)) << "\n";
      break;
    case OPT_force_load:
    case OPT_rpath:
    case OPT_syslibroot:
    case OPT_F:
    case OPT_L:
    case OPT_order_file:
      os << arg->getSpelling() << " " << quote(rewritePath(arg->getValue()))
         << "\n";
      break;
    case OPT_sectcreate:
      os << arg->getSpelling() << " " << quote(arg->getValue(0)) << " "
         << quote(arg->getValue(1)) << " "
         << quote(rewritePath(arg->getValue(2))) << "\n";
      break;
    default:
      os << toString(*arg) << "\n";
    }
  }
  return std::string(data.str());
}

Optional<std::string> macho::resolveDylibPath(StringRef path) {
  // TODO: if a tbd and dylib are both present, we should check to make sure
  // they are consistent.
  if (fs::exists(path))
    return std::string(path);

  SmallString<261> location = path;
  path::replace_extension(location, ".tbd");
  if (fs::exists(location))
    return std::string(location);

  return {};
}

Optional<DylibFile *> macho::makeDylibFromTAPI(MemoryBufferRef mbref,
                                               DylibFile *umbrella) {
  Expected<std::unique_ptr<InterfaceFile>> result = TextAPIReader::get(mbref);
  if (!result) {
    error("could not load TAPI file at " + mbref.getBufferIdentifier() + ": " +
          toString(result.takeError()));
    return {};
  }
  return make<DylibFile>(**result, umbrella);
}

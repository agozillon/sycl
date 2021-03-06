//===- SymbolTable.h --------------------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef LLD_ELF_SYMBOL_TABLE_H
#define LLD_ELF_SYMBOL_TABLE_H

#include "InputFiles.h"
#include "LTO.h"
#include "lld/Common/Strings.h"
#include "llvm/ADT/CachedHashString.h"
#include "llvm/ADT/DenseMap.h"

namespace lld {
namespace elf {

class CommonSymbol;
class Defined;
class LazyArchive;
class LazyObject;
class SectionBase;
class SharedSymbol;
class Undefined;

// SymbolTable is a bucket of all known symbols, including defined,
// undefined, or lazy symbols (the last one is symbols in archive
// files whose archive members are not yet loaded).
//
// We put all symbols of all files to a SymbolTable, and the
// SymbolTable selects the "best" symbols if there are name
// conflicts. For example, obviously, a defined symbol is better than
// an undefined symbol. Or, if there's a conflict between a lazy and a
// undefined, it'll read an archive member to read a real definition
// to replace the lazy symbol. The logic is implemented in the
// add*() functions, which are called by input files as they are parsed. There
// is one add* function per symbol type.
class SymbolTable {
public:
  template <class ELFT> void addCombinedLTOObject();
  void wrap(Symbol *Sym, Symbol *Real, Symbol *Wrap);

  ArrayRef<Symbol *> getSymbols() const { return SymVector; }

  Symbol *insert(StringRef Name);

  Symbol *addSymbol(const Symbol &New);

  void fetchLazy(Symbol *Sym);

  void scanVersionScript();

  Symbol *find(StringRef Name);

  void trace(StringRef Name);

  void handleDynamicList();

  // Set of .so files to not link the same shared object file more than once.
  llvm::DenseMap<StringRef, SharedFile *> SoNames;

  // Comdat groups define "link once" sections. If two comdat groups have the
  // same name, only one of them is linked, and the other is ignored. This map
  // is used to uniquify them.
  llvm::DenseMap<llvm::CachedHashStringRef, const InputFile *> ComdatGroups;

private:
  std::vector<Symbol *> findByVersion(SymbolVersion Ver);
  std::vector<Symbol *> findAllByVersion(SymbolVersion Ver);

  llvm::StringMap<std::vector<Symbol *>> &getDemangledSyms();
  void handleAnonymousVersion();
  void assignExactVersion(SymbolVersion Ver, uint16_t VersionId,
                          StringRef VersionName);
  void assignWildcardVersion(SymbolVersion Ver, uint16_t VersionId);

  // The order the global symbols are in is not defined. We can use an arbitrary
  // order, but it has to be reproducible. That is true even when cross linking.
  // The default hashing of StringRef produces different results on 32 and 64
  // bit systems so we use a map to a vector. That is arbitrary, deterministic
  // but a bit inefficient.
  // FIXME: Experiment with passing in a custom hashing or sorting the symbols
  // once symbol resolution is finished.
  llvm::DenseMap<llvm::CachedHashStringRef, int> SymMap;
  std::vector<Symbol *> SymVector;

  // A map from demangled symbol names to their symbol objects.
  // This mapping is 1:N because two symbols with different versions
  // can have the same name. We use this map to handle "extern C++ {}"
  // directive in version scripts.
  llvm::Optional<llvm::StringMap<std::vector<Symbol *>>> DemangledSyms;

  // For LTO.
  std::unique_ptr<BitcodeCompiler> LTO;
};

extern SymbolTable *Symtab;

void mergeSymbolProperties(Symbol *Old, const Symbol &New);
void resolveSymbol(Symbol *Old, const Symbol &New);

} // namespace elf
} // namespace lld

#endif

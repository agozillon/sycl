set(LLVM_EXPORTED_SYMBOL_FILE ${CMAKE_CURRENT_SOURCE_DIR}/CheckerOptionHandlingAnalyzerPlugin.exports)
add_llvm_library(CheckerOptionHandlingAnalyzerPlugin MODULE CheckerOptionHandling.cpp PLUGIN_TOOL clang)

if(LLVM_ENABLE_PLUGINS)
  target_link_libraries(CheckerOptionHandlingAnalyzerPlugin PRIVATE
    clangAnalysis
    clangAST
    clangStaticAnalyzerCore
    clangStaticAnalyzerFrontend
    LLVMSupport
    )
endif()

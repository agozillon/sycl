// RUN: %clang_cc1 -triple x86_64-unknown-unknown -fopenmp -ast-dump %s | FileCheck --match-full-lines -implicit-check-not=openmp_structured_block %s

void test() {
#pragma omp parallel
  {
#pragma omp cancellation point parallel
  }
}

// CHECK: TranslationUnitDecl {{.*}} <<invalid sloc>> <invalid sloc>
// CHECK: `-FunctionDecl {{.*}} <{{.*}}ast-dump-openmp-cancellation-point.c:3:1, line:8:1> line:3:6 test 'void ()'
// CHECK-NEXT:   `-CompoundStmt {{.*}} <col:13, line:8:1>
// CHECK-NEXT:     `-OMPParallelDirective {{.*}} <line:4:9, col:21>
// CHECK-NEXT:       `-CapturedStmt {{.*}} <line:5:3, line:7:3>
// CHECK-NEXT:         `-CapturedDecl {{.*}} <<invalid sloc>> <invalid sloc> nothrow
// CHECK-NEXT:           |-CompoundStmt {{.*}} <line:5:3, line:7:3> openmp_structured_block
// CHECK-NEXT:           | `-OMPCancellationPointDirective {{.*}} <line:6:9, col:40> openmp_standalone_directive
// CHECK-NEXT:           |-ImplicitParamDecl {{.*}} <line:4:9> col:9 implicit .global_tid. 'const int *const restrict'
// CHECK-NEXT:           |-ImplicitParamDecl {{.*}} <col:9> col:9 implicit .bound_tid. 'const int *const restrict'
// CHECK-NEXT:           `-ImplicitParamDecl {{.*}} <col:9> col:9 implicit __context 'struct (anonymous at {{.*}}ast-dump-openmp-cancellation-point.c:4:9) *const restrict'

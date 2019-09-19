// RUN: %clang_cc1 -triple spir64-unknown-linux-sycldevice -I %S/Inputs -std=c++11 -fsycl-is-device -disable-llvm-passes -S -emit-llvm -x c++ %s -o - | FileCheck %s

#include "sycl.hpp"

template <typename KernelName, typename KernelType>
__attribute__((sycl_kernel)) void
kernel_parallel_for_work_group(KernelType KernelFunc) {
  cl::sycl::group<1> G;
  KernelFunc(G);
}

int main() {

  kernel_parallel_for_work_group<class kernel>([=](cl::sycl::group<1> G) {
    const int WG_CONST = 10;
  });
// CHECK:  store i32 10, i32 addrspace(4)* addrspacecast (i32 addrspace(3)* @{{.*}}WG_CONST{{.*}} to i32 addrspace(4)*)
// CHECK:  %{{[0-9]+}} = call {}* @llvm.invariant.start.p4i8(i64 4, i8 addrspace(4)* addrspacecast (i8 addrspace(3)* bitcast (i32 addrspace(3)* @{{.*}}WG_CONST{{.*}} to i8 addrspace(3)*) to i8 addrspace(4)*))

  return 0;
}

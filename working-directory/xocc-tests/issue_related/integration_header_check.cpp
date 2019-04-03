/*
  The main point of the test is to check if you can name SYCL kernels in
  certain ways without the compiler or run-time breaking due to an
  incorrectly generated integration header.

  This test is checking if the alterations that were made to SemaSYCL to alter
  the integration header generation break any prior examples at run-time or
  compilation. The modification to SemaSYCL removed:
   global namespacing - KernelInfo<::kernel_name>
   inline class/struct keywords - KernelInfo<struct kernel_name>

  And instead replaced them with a fully qualified variant with the correct
  namespaces, so that they always have to refer to previous definitions in
  the header. This is currently an issue under review against the Intel SYCL
  implementation: https://github.com/intel/llvm/pull/46

  So there is a chance it will be altered again.

  The change broke the CodeGen tests:
  Clang :: CodeGenSYCL/integration_header.cpp
  Clang :: CodeGenSYCL/kernel_functor.cpp

  As they directly check against the generated integration header to make sure
  that it's correct and hasn't regressed.

  This test actually directly corresponds to sycl/test/regression/kernel_name_class.cpp
  I did not realize this before I wrote this! But this is also an executeable
  implementation of the CodeGen test integration_header.cpp, so somewhat useful
  I suppose.

  Intel command:
  $ISYCL_BIN_DIR/clang++ -std=c++11 -fsycl integration_header_check.cpp -o \
    integration_header_check -lsycl -lOpenCL

  Xilinx command:
  $ISYCL_BIN_DIR/clang++ -D__SYCL_SPIR_DEVICE__ -DXILINX -std=c++11 -fsycl \
    -fsycl-xocc-device integration_header_check.cpp \
    -o integration_header_check -lsycl -lOpenCL
*/

#include <CL/sycl.hpp>

#include "../utilities/device_selectors.hpp"

using namespace cl::sycl;

class kernel_1;

namespace second_namespace {
template <typename T = int>
class second_kernel;
}

template <int a, typename T1, typename T2>
class third_kernel;

struct x {};
template <typename T>
struct point {};

namespace template_arg_ns {
  template <int DimX>
  struct namespaced_arg {};
}

template <typename ...Ts>
class fourth_kernel;

namespace nm1 {
  namespace nm2 {

    template <int X> class fifth_kernel {};
  } // namespace nm2

template <typename... Ts> class sixth_kernel;
}

int main() {
#ifdef XILINX
 selector_defines::XOCLDeviceSelector selector;
#else
 selector_defines::IntelDeviceSelector selector;
#endif
  queue q {selector};
  buffer<int> ob(range<1>{1});

  q.submit([&](handler &cgh) {
    auto wb = ob.get_access<access::mode::write>(cgh);

    cgh.single_task<kernel_1>([=]() {
      wb[0] += 1;
    });
  });

  q.wait();

  auto rb = ob.get_access<access::mode::read>();
  assert(rb[0] == 1 && "kernel execution or assignment error");
  printf("%d \n", rb[0]);

  q.submit([&](handler &cgh) {
    auto wb = ob.get_access<access::mode::write>(cgh);

    cgh.single_task<class kernel_2>([=]() {
      wb[0] += 2;
    });
  });

  q.wait();

  rb = ob.get_access<access::mode::read>();
  assert(rb[0] == 3 && "kernel execution or assignment error");
  printf("%d \n", rb[0]);

  q.submit([&](handler &cgh) {
    auto wb = ob.get_access<access::mode::write>(cgh);

    cgh.single_task<second_namespace::second_kernel<char>>([=]() {
      wb[0] += 3;
    });
  });

  q.wait();

  rb = ob.get_access<access::mode::read>();
  assert(rb[0] == 6 && "kernel execution or assignment error");
  printf("%d \n", rb[0]);

  q.submit([&](handler &cgh) {
    auto wb = ob.get_access<access::mode::write>(cgh);

    // note: in the integration header specialization of this kernel it removes
    // the keyword struct from the struct X declaration, it works as it by
    // default re-declares it at the beginning of the header, is this ideal
    // behavior though?
    cgh.single_task<third_kernel<1, int,point<struct X>>>([=]() {
      wb[0] += 4;
    });
  });

  q.wait();

  rb = ob.get_access<access::mode::read>();
  assert(rb[0] == 10 && "kernel execution or assignment error");
  printf("%d \n", rb[0]);

  q.submit([&](handler &cgh) {
    auto wb = ob.get_access<access::mode::write>(cgh);
    cgh.single_task<fourth_kernel<template_arg_ns::namespaced_arg<1>>>([=]() {
      wb[0] += 5;
    });
  });

  q.wait();

  rb = ob.get_access<access::mode::read>();
  assert(rb[0] == 15 && "kernel execution or assignment error");
  printf("%d \n", rb[0]);

  q.submit([&](handler &cgh) {
    auto wb = ob.get_access<access::mode::write>(cgh);
    cgh.single_task<nm1::sixth_kernel<nm1::nm2::fifth_kernel<10>>>([=]() {
      wb[0] += 6;
    });
  });

  rb = ob.get_access<access::mode::read>();
  assert(rb[0] == 21 && "kernel execution or assignment error");
  printf("%d \n", rb[0]);

  return 0;
}

//==----------------------- kernel_desc.hpp --------------------------------==//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===////

#pragma once

#include <CL/sycl/access/access.hpp>
#include <CL/sycl/detail/os_util.hpp> // for DLL_LOCAL used in int. header

namespace cl {
namespace sycl {
namespace detail {

namespace half_impl {

class half;
// Half type is defined as _Float16 on device and as manually implemented half
// type on host. Integration header is generated by device compiler so it sees
// half type as _Float16 and it will add _Float16 to integration header if it
// is used in kernel name template parameters. To avoid errors in host
// compilation we remove _Float16 from integration header using following macro.
#ifndef __SYCL_DEVICE_ONLY__
#define _Float16 cl::sycl::detail::half_impl::half
#endif

} // namespace half_impl

// kernel parameter kinds
enum class kernel_param_kind_t {
  kind_accessor,
  kind_std_layout, // standard layout object parameters
  kind_sampler
};

// describes a kernel parameter
struct kernel_param_desc_t {
  // parameter kind
  kernel_param_kind_t kind;
  // kind == kind_std_layout
  //   parameter size in bytes (includes padding for structs)
  // kind == kind_accessor
  //   access target; possible access targets are defined in access/access.hpp
  int info;
  // offset of the captured value of the parameter in the lambda or function
  // object
  int offset;
};

template <class KernelNameType> struct KernelInfo {
  static constexpr unsigned getNumParams() { return 0; }
  static const kernel_param_desc_t &getParamDesc(int Idx) {
    static kernel_param_desc_t Dummy;
    return Dummy;
  }
  static constexpr const char *getName() { return ""; }
};

} // namespace detail
} // namespace sycl
} // namespace cl

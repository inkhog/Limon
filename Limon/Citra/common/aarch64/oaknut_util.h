//
//  oaknut_util.h
//  Limon
//
//  Created by Jarrod Norwell on 10/21/23.
//

#pragma once

#include "common/arch.h"
#if CITRA_ARCH(arm64)

#include <type_traits>
#include <oaknut/oaknut.hpp>
#include "common/aarch64/oaknut_abi.h"

namespace Common::A64 {

// BL can only reach targets within +-128MiB(24 bits)
inline bool IsWithin128M(uintptr_t ref, uintptr_t target) {
    const u64 distance = target - (ref + 4);
    return !(distance >= 0x800'0000ULL && distance <= ~0x800'0000ULL);
}

inline bool IsWithin128M(const oaknut::CodeGenerator& code, uintptr_t target) {
    return IsWithin128M(code.ptr<uintptr_t>(), target);
}

template <typename T>
inline void CallFarFunction(oaknut::CodeGenerator& code, const T f) {
    static_assert(std::is_pointer_v<T>, "Argument must be a (function) pointer.");
    const std::uintptr_t addr = reinterpret_cast<std::uintptr_t>(f);
    if (IsWithin128M(code, addr)) {
        code.BL(reinterpret_cast<const void*>(f));
    } else {
        // ABI_RETURN is a safe temp register to use before a call

        // oaknut does not support `const` arguments, needs a local copy
        oaknut::XReg local_return(ABI_RETURN.index());

        code.MOVP2R(local_return.toX(), reinterpret_cast<const void*>(f));
        code.BLR(local_return.toX());
    }
}

} // namespace Common::A64

#endif // CITRA_ARCH(arm64)

/*******************************************************
 * Copyright (c) 2014, ArrayFire
 * All rights reserved.
 *
 * This file is distributed under 3-clause BSD license.
 * The complete license agreement can be obtained at:
 * https://arrayfire.com/licenses/BSD-3-Clause
 ********************************************************/
/*
   monte-carlo estimation of PI
   algorithm:
   - generate random (x,y) samples uniformly
   - count what percent fell inside (top quarter) of unit circle
*/
#include <arrayfire.h>
#include <cstdio>

using namespace af;

int main(int argc, char** argv) {
    try {
      auto backends = getAvailableBackends();
      bool cpu    = backends & AF_BACKEND_CPU;
      bool cuda   = backends & AF_BACKEND_CUDA;
      bool opencl = backends & AF_BACKEND_OPENCL;
      fprintf(stdout, "cpu: %d, cuda: %d, opencl: %d\n", cpu, cuda, opencl);
    } catch (exception& e) {
        fprintf(stderr, "%s\n", e.what());
        throw;
    }
    return 0;
}

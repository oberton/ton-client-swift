#ifndef shim_h

    #define shim_h
    #include <stdbool.h>

    #if os(iOS)
        #include "tonclient.h"
    #else
        #include "../../dependencies/ton-sdk/include/tonclient.h"
    #endif
#endif

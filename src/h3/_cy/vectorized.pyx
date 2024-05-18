from libc.stdint cimport uint64_t

cimport h3lib
from h3lib cimport bool, H3int

from .util cimport deg2coord

from .error_system cimport check_for_error

import numpy as np
cimport numpy as np
import cython
cimport cython


@cython.boundscheck(False)
@cython.wraparound(False)
cpdef H3int[:] latlngs_to_cells(
    const double[:] lat,
    const double[:] lng,
    int res,
) noexcept:
    cdef:
        h3lib.LatLng c
        H3int temp
        H3int[:] out = np.empty(len(lat), dtype=np.uint64)  # Declare and initialize 'out'

    with nogil:
        for i in range(len(lat)):
            c = deg2coord(lat[i], lng[i])
            h3lib.latLngToCell(&c, res, &temp)
            out[i] = temp

        return out
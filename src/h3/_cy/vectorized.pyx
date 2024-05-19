from libc.stdint cimport uint64_t

cimport h3lib
from h3lib cimport bool, H3int

from .util cimport deg2coord

from .error_system cimport check_for_error

import numpy as np
cimport numpy as np
import cython
cimport cython
from cython.parallel import prange, parallel
from cython.view cimport array as cvarray


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
        # H3int[:] out = np.empty(len(lat), dtype=H3int)  # Declare and initialize 'out'
        H3int[:] out = cvarray(shape=(lat.shape[0], ), itemsize=cython.sizeof(H3int), format='L')
        int i

    with nogil:
        for i in range(lat.shape[0]):
            c = deg2coord(lat[i], lng[i])
            h3lib.latLngToCell(&c, res, &temp)
            out[i] = temp

    return out
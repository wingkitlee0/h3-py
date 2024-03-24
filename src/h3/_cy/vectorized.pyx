from libc.stdint cimport uint64_t

cimport h3lib
from h3lib cimport bool, H3int

from .util cimport deg2coord

from .error_system cimport check_for_error

import numpy as np
cimport numpy as np


cpdef np.ndarray[np.uint64_t, ndim=1] latlngs_to_cells(np.ndarray[np.double_t, ndim=1] lats, np.ndarray[np.double_t, ndim=1] lngs, int res):
    cdef:
        h3lib.LatLng c
        np.ndarray[H3int, ndim=1] out
        H3int temp

    out = np.full(lats.shape[0], 0, dtype=np.uint64)

    for i, (lat, lng) in enumerate(zip(lats, lngs)):
        c = deg2coord(lat, lng)
        check_for_error(h3lib.latLngToCell(&c, res, &temp))
        out[i] = temp

    return out
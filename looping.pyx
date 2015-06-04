#!/usr/bin/env python
# encoding: utf-8
# cython: boundscheck=False
# cython: wraparound=False

cimport cython
from cython.view cimport array as cvarray


ctypedef int DTYPE

# 2D point updater
cdef inline void _counter_2d(DTYPE[:, :] narr, int val) nogil:
    cdef:
        DTYPE count = 0
        DTYPE index = 0
        DTYPE x, y

    index = 0
    for x in range(val):
        for y in range(val):
            narr[index, 0] = x
            narr[index, 1] = y
            index += 1

# 3D point updater
cdef inline void _counter_3d(DTYPE[:, :] narr, int val) nogil:
    cdef:
        DTYPE count = 0
        DTYPE index = 0
        DTYPE x, y, z

    index = 0
    for x in range(val):
        for y in range(val):
            for z in range(val):
                narr[index, 0] = x
                narr[index, 1] = y
                narr[index, 2] = z
                index += 1


cpdef DTYPE[:, :] counter(int dim=2, int val=256):
    array_length = val**dim
    carr = cvarray(shape=(array_length, dim),
                   itemsize=sizeof(DTYPE),
                   format="i4")
    cdef DTYPE[:, :] narr = carr
    with nogil:
        if dim == 2:
            _counter_2d(narr, val)
        elif dim == 3:
            _counter_3d(narr, val)
    return narr


def pycounter(dim=2, val=256):
    vals = []
    for x in xrange(val):
        for y in xrange(val):
            vals.append((x, y))
    return vals


if __name__ == "__main__":
    from timeit import Timer

    tests = ['counter', 'pycounter']
    timing = {}
    for test in tests:
        code = "{}(dim=dim, val=val)".format(test)
        variables = "dim, val = (2, 256)"
        setup = "from __main__ import {}; {}".format(test, variables)
        t = Timer(code, setup=setup)
        timing[test] = t.timeit(10)

    import pprint
    print pprint.pformat(timing)

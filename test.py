#!/usr/bin/env python
"""
Usage:
    looping.py [options]
    looping.py [options] <val>
    looping.py [options] <dim> <val>

Options:
    -h --help       This Message
    -n              Number of loops [default: 10]
"""

if __name__ == "__main__":
    from docopt import docopt
    from timeit import Timer

    args = docopt(__doc__)
    dim = args.get("<dim>") or 2
    val = args.get("<val>") or 256
    n = args.get("-n") or 100
    dim = int(dim)
    val = int(val)
    n = int(n)

    tests = ['counter', 'pycounter', 'scounter']
    timing = {}
    for test in tests:
        code = "{}(dim=dim, val=val)".format(test)
        variables = "dim, val = ({}, {})".format(dim, val)
        setup = "from looping import {}; {}".format(test, variables)
        t = Timer(code, setup=setup)
        timing[test] = t.timeit(n) / n

    for test, val in timing.iteritems():
        percentage = timing.get(test, 1) / timing.get("pycounter", 1) * 100
        print "{:>20}: {} sec [{:>.3} %]".format(test, val, percentage)

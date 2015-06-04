from distutils.core import setup
from distutils.extension import Extension

from Cython.Build import cythonize

warnings = ["-Wno-" + flag
            for flag in [
                "unused-function",
                "unneeded-internal-declaration"
                ]
            ]

link_options = ["-O3", "-march=native"]
compile_options = link_options + warnings


extensions = [
    Extension("*", ["*.pyx"],
              extra_compile_args=compile_options,
              extra_link_args=link_options,
              )
]

setup(
    name="looping",
    ext_modules=cythonize(extensions),  # accepts a glob pattern
)

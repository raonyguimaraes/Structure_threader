#!/bin/bash

# Copyright 2015 Francisco Pina Martins <f.pinamartins@gmail.com>
# This file is part of structure_threader.
# structure_threader is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# structure_threader is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with structure_threader. If not, see <http://www.gnu.org/licenses/>.

set -e

# Define and create installation location:
install_dir=${HOME}/Software/faststructure
mkdir -p ${install_dir}

# Define temp dir
tempdir=/tmp

# Get LDFAGS
_OLD_LDFLAGS=$LDFLAGS


# Download faststructure and deps. sources into temp dir
# faststructure
wget -c https://github.com/rajanil/fastStructure/archive/v1.0.tar.gz -O ${tempdir}/fastStructure-1.0.tar.gz
# python-nose
wget -c http://pypi.python.org/packages/source/n/nose/nose-1.3.6.tar.gz -O ${tempdir}/nose-1.3.6.tar.gz
# numpy
wget -c https://github.com/numpy/numpy/archive/v1.9.2.tar.gz -O ${tempdir}/numpy.tar.gz
# scipy
wget -c https://github.com/scipy/scipy/archive/v0.16.0b2.tar.gz -O ${tempdir}/scipy.tar.gz
# cython
wget -c http://cython.org/release/Cython-0.22.zip -O ${tempdir}/Cython-0.22.zip
# GNU scientific library
wget -c http://gnu.mirror.vexxhost.com/gsl/gsl-latest.tar.gz -O  ${tempdir}/gsl-latest.tar.gz
# LAPACK (required for scipy)
wget -c http://www.netlib.org/lapack/lapack-3.5.0.tgz -O ${tempdir}/lapack-3.5.0.tgz


# Install dependencies
# LAPACK
cd ${tempdir}
tar xvfz lapack-3.5.0.tgz
mkdir -p build-lapack
cd build-lapack
cmake ../lapack-3.5.0
make
mkdir -p ${install_dir}/{bin,lib}
mv bin/* ${install_dir}/bin
mv lib/* ${install_dir}/lib

# cython
cd ${tempdir}
unzip Cython-0.22.zip
cd Cython-0.22
python2 setup.py install --user

# python-nose
cd ${tempdir}
tar xvfz nose-1.3.6.tar.gz
cd nose-1.3.6
python2 setup.py install --user

# numpy
cd ${tempdir}
tar xvfz numpy.tar.gz
cd numpy-1.9.2
sed -e "s|#![ ]*/usr/bin/python$|#!/usr/bin/python2|" \
    -e "s|#![ ]*/usr/bin/env python$|#!/usr/bin/env python2|" \
    -e "s|#![ ]*/bin/env python$|#!/usr/bin/env python2|" \
    -i $(find . -name '*.py')
export ATLAS=None
export LDFLAGS="$LDFLAGS -shared"
python2 setup.py install --user

# scipy
cd ${tempdir}
tar xvfz scipy.tar.gz
cd scipy-0.16.0b2
python2 setup.py install --user

# GNU scientific library
cd ${tempdir}
tar xvzf gsl-latest.tar.gz
cd gsl-1.16
export LDFLAGS=${_OLD_LDFLAGS}
./configure --prefix=${install_dir}
make
make install

# Extract tarball, enter src dir, build binary and place it in the install dir
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${install_dir}/lib
export CFLAGS="-I${install_dir}/include"
export LDFLAGS="-L${install_dir}/lib"
cd ${tempdir}
tar xvfz fastStructure-1.0.tar.gz
cd  fastStructure-1.0
cd vars
python2 setup.py build_ext --inplace
cd ..
python2 setup.py build_ext --inplace
cd ..
mv fastStructure-1.0 ${install_dir}
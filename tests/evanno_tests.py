#!/usr/bin/python3

# Copyright 2016 Francisco Pina Martins <f.pinamartins@gmail.com>
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


import glob

import structure_threader.evanno.fastChooseK as fc

def test_parse_logs():
    files = glob.glob("files/*.log")
    assert fc.parse_logs(files) == [-0.9875020559, -0.978009636, -0.9721792877,
                                    -0.9768312088, -0.9806135049, -0.9825775986]

def test_parse_varQs():
    files = glob.glob("files/*.meanQ")
    assert fc.parse_varQs(files) == [5, 2, 3, 1, 3, 3]

def test_main():
    indir = "files/"
    text = str(['Model complexity that maximizes marginal likelihood = 2\n',
                'Model components used to explain structure in data = 3\n'])
    outdir = "files/"
    assert fc.main(indir, outdir) == None
    outfile = open(outdir + "chooseK.txt", "r")
    test_text = str(outfile.readlines())
    assert test_text == text
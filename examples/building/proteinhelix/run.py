# PD is a free, modular C++ library for biomolecular simulation with a 
# flexible and scriptable Python interface. 
# Copyright (C) 2003-2013 Mike Tyka and Jon Rea
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

from pd import *
cseed(4)
info()
timer()

ffps = FFParamSet()

## Use that Charmm forcefield
ffps.readLib( after("-ff","charmm22.ff")  )

## test simple loading of PDB file
sim = System( ffps );

## Create a Protein helix using evry amino acid
sim.add( NewProteinHelix(ffps,"*P-(ACDEFGHIKLMNPQRSTVWY)-R*") );


# create workspace
wspace = WorkSpace( sim )

# print loaded system - this can be compared later
wspace.printPDB("built.pdb")

# create a few common forcefields
ff = Forcefield(wspace)

# set up a simple vaccuum forcefielid and calculate the energy
bonds = FF_Bonded(wspace)
nb    = FF_NonBonded(wspace)
nb.Cutoff = 12.0
nb.InnerCutoff =  9.0
ff.add( bonds )
ff.add( nb )

## print energies as summary
ff.printEnergySummary()
ff.printEnergyByAtom()
## also show parameters
ff.info()



#ifndef MYDEBUG_HH_
# define MYDEBUG_HH_

# include <iostream>
# include <string>

# include "FCALattice.hh"


void PrintLatticePresentation(FCALattice *Lattice);

void PrintLatticeObjects(FCALattice *Lattice);

void PrintLatticeAttributes(FCALattice *Lattice);

void PrintLatticeConcepts(FCALattice *Lattice);

void PrintLatticeHighestLowestParents(FCALattice *Lattice);

#endif /* !MYDEBUG_HH_ */

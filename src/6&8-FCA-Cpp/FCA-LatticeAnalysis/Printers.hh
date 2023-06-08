#ifndef PRINTERS_HH_
# define PRINTERS_HH_

# include <fstream>
# include <string>

# include "FCALattice.hh"
# include "FCALatticeStatistics.hh"

void PrintStatistics(FCALattice *Lattice, FCALatticeStatistics *Statistics);

#endif /* !PRINTERS_HH_ */

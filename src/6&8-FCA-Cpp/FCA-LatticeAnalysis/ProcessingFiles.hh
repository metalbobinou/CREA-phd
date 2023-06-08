#ifndef PROCESSINGFILES_HH_
# define PROCESSINGFILES_HH_

# include <stdio.h>

# include <string>
# include <vector>

# include "FCALattice.hh"
# include "FCALatticeStatistics.hh"
# include "ParseXML.hh"
# include "Printers.hh"
# include "Dirs.hh"
# include "Files.hh"

//  #ifdef MYDEBUG
# include "MyDebug.hh"
//  #endif

// Process the arguments given to the program, and write into the output dir
void ProcessingFiles(std::vector<std::string> ArgVect,
		     std::string OutputDirectory);

#endif /* !PROCESSINGFILES_HH_ */

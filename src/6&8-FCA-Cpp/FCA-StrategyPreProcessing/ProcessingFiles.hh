#ifndef PROCESSINGFILES_HH_
# define PROCESSINGFILES_HH_

# include <iostream>
# include <string>

# include "ParseCSV.hh"
# include "FormalContext.hh"
# include "FormalContextStrategies.hh"

// Write the calculted Formal Context into 3 files (function adds extension)
void WriteStrategyToFiles(std::string OutputFileName,
                          std::string OutputDirectory,
                          FormalContextStrategies *FCS);

void ProcessingFiles(char **InputFiles, const char *OutputDirectory);

#endif /* !PROCESSINGFILES_HH_ */

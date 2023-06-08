#ifndef MYDEBUGS_HH_
# define MYDEBUGS_HH_

# include <stdio.h>

# include <string>
# include <vector>

# include "FormalContext.hh"
# include "FormalContextStrategies.hh"

void PrintVectorVectorString(std::vector<std::vector<std::string> > matrix);

void TestMultipleTranslations(FormalContextStrategies *FCS);

#endif /* !MYDEBUGS_HH_ */

#ifndef PARSEXML_HH_
# define PARSEXML_HH_

# include "FCALattice.hh"

# include "FlatFileParseXML.h"
# include "TreeParseXML.hh"


void PrepareXMLParser(void);

void CleanXMLParser(void);

int MyXMLParse(const char *filename, FCALattice *Lattice);

#endif /* !PARSEXML_HH_ */

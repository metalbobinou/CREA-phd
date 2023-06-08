#ifndef TREEPARSEXML_HH_
# define TREEPARSEXML_HH_

# include <stdio.h>
# include <string.h>

# include <libxml/parser.h>
# include <libxml/tree.h>

# include "FCALattice.hh"
# include "XMLLatticeReading.hh"


xmlAttr *findAttributeFromNode(xmlNode *node, xmlChar *attribute);

int ReadTreeXMLParse(const char *filename, FCALattice *Lattice);

#endif /* !TREEPARSEXML_HH_ */

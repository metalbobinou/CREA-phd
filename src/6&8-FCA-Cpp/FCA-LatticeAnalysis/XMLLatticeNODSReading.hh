#ifndef XMLLATTICENODSREADING_HH_
# define XMLLATTICENODSREADING_HH_

# include <stdio.h>

# include <string>

# include <libxml/parser.h>

# include "FCALattice.hh"
# include "FCAConcept.hh"
# include "TreeParseXML.hh"


void NodeNODProcessing(xmlNode *obj_node, FCALattice *Lattice);

#endif /* !XMLLATTICENODSREADING_HH_ */

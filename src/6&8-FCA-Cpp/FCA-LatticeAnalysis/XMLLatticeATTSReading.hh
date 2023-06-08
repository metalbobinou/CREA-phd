#ifndef XMLLATTICEATTSREADING_HH_
# define XMLLATTICEATTSREADING_HH_

# include <stdio.h>

# include <iostream>
# include <string>
# include <map>

# include <libxml/parser.h>

# include "TreeParseXML.hh"
# include "FCALattice.hh"


void AttributeProcessing(xmlNode *att_node,
			 std::map<int, std::string> &Attributes);

void AttributeProcessing(xmlNode *att_node, FCALattice *Lattice);

#endif /* !XMLLATTICEATTSREADING_HH_ */

#ifndef XMLLATTICEOBJSREADING_HH_
# define XMLLATTICEOBJSREADING_HH_

# include <stdio.h>

# include <iostream>
# include <string>
# include <map>

# include <libxml/parser.h>

# include "TreeParseXML.hh"
# include "FCALattice.hh"


void ObjectProcessing(xmlNode *obj_node,
		      std::map<int, std::string> &Objects);

void ObjectProcessing(xmlNode *obj_node, FCALattice *Lattice);

#endif /* !XMLLATTICEOBJSREADING_HH_ */

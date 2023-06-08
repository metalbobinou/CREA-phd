#ifndef XMLLATTICELATREADING_HH_
# define XMLLATTICELATREADING_HH_

# include <stdio.h>

# include <iostream>
# include <string>

# include <libxml/parser.h>

# include "TreeParseXML.hh"
# include "FCALattice.hh"


void LATProcessing(xmlNode *lat_node, FCALattice *Lattice);

#endif /* !XMLLATTICELATREADING_HH_ */

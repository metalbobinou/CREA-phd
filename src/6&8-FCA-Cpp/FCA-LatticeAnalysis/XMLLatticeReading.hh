#ifndef XMLLATTICEREADING_HH_
# define XMLLATTICEREADING_HH_

# include <libxml/parser.h>

# include "TreeParseXML.hh"
# include "FCALattice.hh"
# include "XMLLatticeLATReading.hh"
# include "XMLLatticeOBJSReading.hh"
# include "XMLLatticeATTSReading.hh"
# include "XMLLatticeNODSReading.hh"


void NodeLATProcessing(xmlNode *lat_node, FCALattice *Lattice);

void NodeOBJSProcessing(xmlNode *objs_node, FCALattice *Lattice);

void NodeATTSProcessing(xmlNode *atts_node, FCALattice *Lattice);

void NodeNODSProcessing(xmlNode *nods_node, FCALattice *Lattice);

#endif /* !XMLLATTICEREADING_HH_ */

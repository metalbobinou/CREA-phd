#include "XMLLatticeReading.hh"

// Extract the filename from the LAT node
void NodeLATProcessing(xmlNode *lat_node, FCALattice *Lattice)
{
  LATProcessing(lat_node, Lattice);
}

// Extract all the possible objects
void NodeOBJSProcessing(xmlNode *objs_node, FCALattice *Lattice)
{
  xmlNode *c_node = objs_node->children;
  xmlChar *OBJ = xmlCharStrdup("OBJ");

  //printf("BEGIN node (%s) - content: %s\n", node->name, node->content);
  while (c_node != NULL)
  {
    //printf("c_node (%s) - content: %s\n", c_node->name, c_node->content);
    if (xmlStrEqual(c_node->name, OBJ) == 1)
    {
      ObjectProcessing(c_node, Lattice);
    }
    c_node = c_node->next;
  }

  xmlFree(OBJ);
}

// Extract all the possible attributes
void NodeATTSProcessing(xmlNode *atts_node, FCALattice *Lattice)
{
  xmlNode *c_node = atts_node->children;
  xmlChar *ATT = xmlCharStrdup("ATT");

  //printf("BEGIN node (%s) - content: %s\n", node->name, node->content);
  while (c_node != NULL)
  {
    //printf("c_node (%s) - content: %s\n", c_node->name, c_node->content);
    if (xmlStrEqual(c_node->name, ATT) == 1)
    {
      AttributeProcessing(c_node, Lattice);
    }
    c_node = c_node->next;
  }

  xmlFree(ATT);
}

// Process nodes of the lattice
void NodeNODSProcessing(xmlNode *nods_node, FCALattice *Lattice)
{
  xmlNode *c_node = nods_node->children;
  xmlChar *NOD = xmlCharStrdup("NOD");

  //printf("BEGIN NODS_node (%s) - content: %s\n", nods_node->name, nods_node->content);
  while (c_node != NULL)
  {
    // Process on each NOD node (one NODES contains multiple NOD)
    //printf("NODS LOOP - nod_node (%s) - content: %s\n", c_node->name, c_node->content);
    if (xmlStrEqual(c_node->name, NOD) == 1)
    {
      NodeNODProcessing(c_node, Lattice);
    }
    c_node = c_node->next;
  }

  xmlFree(NOD);
}

#include "XMLLatticeNODSReading.hh"

// Get ID of the concept
static int GetNodeID(xmlNode *nod_node)
{
  xmlAttr *x_attr;
  xmlChar *id_attr = xmlCharStrdup("id");
  int id = 0;

  x_attr = findAttributeFromNode(nod_node, id_attr);
  if ((x_attr != NULL) && (x_attr->children != NULL))
    id = strtol((char*) x_attr->children->content, NULL, 10);
  else
    std::cerr << "Can't find 'id' attribute in a NOD node" << std::endl;

 #ifdef MYDEBUG
  std::cout << "- NOD id : " << id << std::endl;
 #endif
  xmlFree(id_attr);
  return (id);
}

// Gather Objects from the concept (might be empty)
static void ProcessEXT(xmlNode *ext_node,
		       FCALattice *Lattice,
		       FCAConcept *Concept)
{
  xmlNode *c_node = ext_node->children;
  xmlChar *id_attr = xmlCharStrdup("id");
  xmlChar *OBJ = xmlCharStrdup("OBJ");

  while (c_node != NULL)
  {
    if (xmlStrEqual(c_node->name, OBJ) == 1)
    {
      xmlAttr *x_attr = findAttributeFromNode(c_node, id_attr);
      int id = 0;

      if ((x_attr != NULL) && (x_attr->children != NULL))
	id = strtol((char*) x_attr->children->content, NULL, 10);
      else
	std::cerr <<
	  "Can't find 'id' attribute in a EXT-OBJ node " <<
	  std::endl;

     #ifdef MYDEBUG
      std::cout << "-- EXT-OBJ id : " << id << std::endl;
     #endif
      Concept->AddObject(Lattice->GetObject(id));
    }
    c_node = c_node->next;
  }

  xmlFree(id_attr);
  xmlFree(OBJ);
}

// Gather Attributes from the concept (might be empty)
static void ProcessINT(xmlNode *int_node,
		       FCALattice *Lattice,
		       FCAConcept *Concept)
{
  xmlNode *c_node = int_node->children;
  xmlChar *id_attr = xmlCharStrdup("id");
  xmlChar *ATT = xmlCharStrdup("ATT");

  while (c_node != NULL)
  {
    if (xmlStrEqual(c_node->name, ATT) == 1)
    {
      xmlAttr *x_attr = findAttributeFromNode(c_node, id_attr);
      int id = 0;

      if ((x_attr != NULL) && (x_attr->children != NULL))
	id = strtol((char*) x_attr->children->content, NULL, 10);
      else
  	std::cerr <<
	  "Can't find 'id' attribute in a INT-ATT node " <<
	  std::endl;

     #ifdef MYDEBUG
      std::cout << "-- INT-ATT id : " << id << std::endl;
     #endif
      Concept->AddAttribute(Lattice->GetAttribute(id));
    }
    c_node = c_node->next;
  }

  xmlFree(id_attr);
  xmlFree(ATT);
}

// Get the parents concept ID
static void ProcessSUP_NOD(xmlNode *sup_node,
			   FCALattice *Lattice,
			   FCAConcept *Concept)
{
  xmlNode *c_node = sup_node->children;
  xmlChar *id_attr = xmlCharStrdup("id");
  xmlChar *PARENT = xmlCharStrdup("PARENT");

  while (c_node != NULL)
  {
    if (xmlStrEqual(c_node->name, PARENT) == 1)
    {
      xmlAttr *x_attr = findAttributeFromNode(c_node, id_attr);
      int id = 0;

      if ((x_attr != NULL) && (x_attr->children != NULL))
	id = strtol((char*) x_attr->children->content, NULL, 10);
      else
  	std::cerr <<
	  "Can't find 'id' attribute in a SUP_NOD-PARENT node " <<
	  std::endl;

     #ifdef MYDEBUG
      std::cout << "-- SUP_NOD-Concept id Found: " << id << std::endl;
     #endif
      Concept->AddParent(id);
    }
    c_node = c_node->next;
  }

  xmlFree(id_attr);
  xmlFree(PARENT);
  return ; // Reduce Warning
  Lattice->GetLatticeName();
}

// Process each Concept (which is a NOD)
void NodeNODProcessing(xmlNode *nod_node, FCALattice *Lattice)
{
  xmlNode *c_node = nod_node->children;
  xmlChar *EXT = xmlCharStrdup("EXT");
  xmlChar *INT = xmlCharStrdup("INT");
  xmlChar *SUP_NOD = xmlCharStrdup("SUP_NOD");
  FCAConcept *Concept;

  Concept = new FCAConcept(GetNodeID(nod_node)); // Get ID from the NOD node
  Lattice->AddConcept(Concept);

  // Find other concept properties in NOD childs
  while (c_node != NULL)
  {
    if (xmlStrEqual(c_node->name, EXT) == 1)
      ProcessEXT(c_node, Lattice, Concept);
    else if (xmlStrEqual(c_node->name, INT) == 1)
      ProcessINT(c_node, Lattice, Concept);
    else if (xmlStrEqual(c_node->name, SUP_NOD) == 1)
      ProcessSUP_NOD(c_node, Lattice, Concept);
    c_node = c_node->next;
  }

  xmlFree(EXT);
  xmlFree(INT);
  xmlFree(SUP_NOD);
}

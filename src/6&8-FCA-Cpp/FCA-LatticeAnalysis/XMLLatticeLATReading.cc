#include "XMLLatticeLATReading.hh"

static std::string GetFileNameFromXMLString(std::string Description)
{
  std::string str;
  size_t pos;

  pos = Description.find(std::string(" - #OfNodes ="));
  str = Description.substr(0, pos);
  return (str);
}

static std::string DescriptionProcessing(xmlAttr *x_attr, FCALattice *Lattice)
{
  std::string Description = std::string();

  if ((x_attr != NULL) && (x_attr->children != NULL))
  {
    #ifdef MYDEBUG
    printf("Node found - Attribute (%s) : %s\n",
	   x_attr->name,
	   x_attr->children->content);
    #endif
    Description = std::string((char*) x_attr->children->content);

    std::cout << GetFileNameFromXMLString(Description) << std::endl;
    Lattice->UpdateName(GetFileNameFromXMLString(Description));
  }
  else
  {
  #ifdef MYDEBUG
    printf("Node given is NULL :(\n");
  #endif
    std::cerr << "Can't find a 'Desc' attribute in a LAT node" << std::endl;
    Lattice->UpdateName("");
  }

  return (Description);
}

void LATProcessing(xmlNode *lat_node, FCALattice *Lattice)
{
  xmlAttr *x_attr; // XML Attribute
  xmlChar *Desc = xmlCharStrdup("Desc");

  x_attr = findAttributeFromNode(lat_node, Desc);
  DescriptionProcessing(x_attr, Lattice);
  xmlFree(Desc);
}

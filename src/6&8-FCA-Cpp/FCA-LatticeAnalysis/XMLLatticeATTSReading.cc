#include "XMLLatticeATTSReading.hh"

// Map of ID -> Attribute
void AttributeProcessing(xmlNode *att_node,
			 std::map<int, std::string> &Attributes)
{
  std::string AttributeName;
  int AttributeID;
  xmlChar *att_char;
  xmlAttr *att_attr;

  if (att_node != NULL)
  {
    att_char = att_node->children->content;
    AttributeName = std::string((char*) att_char);

    att_attr = att_node->properties;
    if (att_attr != NULL)
    {
      att_char = att_attr->children->content;
      AttributeID = strtol((char*) att_char, NULL, 10);
    }
    else
    {
      std::cerr << "Can't find 'id' attribute in a ATT node" << std::endl;
      AttributeID = 0;
    }

   #ifdef MYDEBUG
    std::cout << "Att (" << AttributeID << "): " << AttributeName << std::endl;
   #endif
    Attributes[AttributeID] = AttributeName;
  }
  #ifdef MYDEBUG
  else
    printf("Node given is NULL :(\n");
  #endif
}

// Full Lattice
void AttributeProcessing(xmlNode *att_node, FCALattice *Lattice)
{
  xmlChar *att_char, *id_attr = xmlCharStrdup("id");
  xmlAttr *att_attr = findAttributeFromNode(att_node, id_attr);
  FCAAttribute *Attribute;
  std::string AttributeName;
  int AttributeID = 0;

  if (att_node == NULL)
  {
   #ifdef MYDEBUG
    printf("Node given is NULL :(\n");
   #endif
    return ;
  }

  if ((att_attr != NULL) && (att_attr->children != NULL))
    AttributeID = strtol((char*) att_attr->children->content, NULL, 10);
  else
    std::cerr << "Can't find 'id' attribute in a ATT node" << std::endl;

  if (att_node->children != NULL)
  {
    att_char = att_node->children->content;
    AttributeName = std::string((char*) att_char);
  }
  else
    AttributeName = std::string();

 #ifdef MYDEBUG
  std::cout << "Att (" << AttributeID << "): " << AttributeName << std::endl;
 #endif
  Attribute = new FCAAttribute(AttributeID, AttributeName);
  Lattice->AddAttribute(Attribute);

  xmlFree(id_attr);
}

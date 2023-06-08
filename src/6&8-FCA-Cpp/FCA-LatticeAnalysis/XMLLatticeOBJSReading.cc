#include "XMLLatticeOBJSReading.hh"

// Map of ID -> Object
void ObjectProcessing(xmlNode *obj_node,
		      std::map<int, std::string> &Objects)
{
  std::string ObjectName;
  int ObjectID;
  xmlChar *obj_char;
  xmlAttr *obj_attr;

  if (obj_node != NULL)
  {
    obj_char = obj_node->children->content;
    ObjectName = std::string((char*) obj_char);

    obj_attr = obj_node->properties;
    if (obj_attr != NULL)
    {
      obj_char = obj_attr->children->content;
      ObjectID = strtol((char*) obj_char, NULL, 10);
    }
    else
    {
      std::cerr << "Can't find 'id' attribute in a OBJ node" << std::endl;
      ObjectID = 0;
    }

   #ifdef MYDEBUG
    std::cout << "Obj (" << ObjectID << "): " << ObjectName << std::endl;
   #endif
    Objects[ObjectID] = ObjectName;
  }
  #ifdef MYDEBUG
  else
    printf("Node given is NULL :(\n");
  #endif
}

// Full Lattice
void ObjectProcessing(xmlNode *obj_node, FCALattice *Lattice)
{
  xmlChar *obj_char, *id_attr = xmlCharStrdup("id");
  xmlAttr *obj_attr = findAttributeFromNode(obj_node, id_attr);
  FCAObject *Object;
  std::string ObjectName;
  int ObjectID = 0;

  if (obj_node == NULL)
  {
   #ifdef MYDEBUG
    printf("Node given is NULL :(\n");
   #endif
    return ;
  }

  if ((obj_attr != NULL) && (obj_attr->children != NULL))
    ObjectID = strtol((char*) obj_attr->children->content, NULL, 10);
  else
    std::cerr << "Can't find 'id' attribute in a OBJ node" << std::endl;

  if (obj_node->children != NULL)
  {
    obj_char = obj_node->children->content;
    ObjectName = std::string((char*) obj_char);
  }
  else
    ObjectName = std::string();

 #ifdef MYDEBUG
  std::cout << "Obj (" << ObjectID << "): " << ObjectName << std::endl;
 #endif
  Object = new FCAObject(ObjectID, ObjectName);
  Lattice->AddObject(Object);
  
  xmlFree(id_attr);
}

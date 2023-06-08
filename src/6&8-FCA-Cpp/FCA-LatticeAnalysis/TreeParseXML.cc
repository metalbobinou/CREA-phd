#include "TreeParseXML.hh"

// Find the requested attribute/property in a node
xmlAttr *findAttributeFromNode(xmlNode *node, xmlChar *attribute)
{
  xmlNode *c_node = node; // Child node
  xmlAttr *x_attr = NULL; // XML Attribute / Properties of the node

  if ((node == NULL) || (node->properties == NULL))
    return (NULL);
  x_attr = node->properties;

  //printf("BEGIN node (%s) - content: %s\n", c_node->name, c_node->content);
  while ((c_node != NULL) && (xmlStrEqual(x_attr->name, attribute) != 1))
  {
    x_attr = c_node->properties;
    //printf("- attr (%s) - content: %s\n", x_attr->name, x_attr->children->content);
    while ((x_attr != NULL) && (xmlStrEqual(x_attr->name, attribute) != 1))
    {
      c_node = x_attr->children;
      x_attr = x_attr->next;
    }
    c_node = c_node->children;
  }
  if ((x_attr == NULL) || (xmlStrEqual(x_attr->name, attribute) != 1))
    return (NULL);
  else
    return (x_attr);
}

static void ProcessElement(xmlNode *node, FCALattice *Lattice)
{
  xmlChar *LAT = xmlCharStrdup("LAT");
  xmlChar *OBJS = xmlCharStrdup("OBJS");
  xmlChar *ATTS = xmlCharStrdup("ATTS");
  xmlChar *NODS = xmlCharStrdup("NODS");

  // LAT NODE
  if (xmlStrEqual(node->name, LAT) == 1)
  {
  #ifdef MYDEBUG
    printf("LAT node found\n");
  #endif

    NodeLATProcessing(node, Lattice);
  }
  // OBJS NODE
  else if (xmlStrEqual(node->name, OBJS) == 1)
  {
  #ifdef MYDEBUG
    printf("OBJS node found\n");
  #endif

    NodeOBJSProcessing(node, Lattice);
  }
  // ATTS NODE
  else if (xmlStrEqual(node->name, ATTS) == 1)
  {
  #ifdef MYDEBUG
    printf("ATTS node found\n");
  #endif

    NodeATTSProcessing(node, Lattice);
  }
  // NODS NODE
  else if (xmlStrEqual(node->name, NODS) == 1)
  {
  #ifdef MYDEBUG
    printf("NODS node found\n");
  #endif

    NodeNODSProcessing(node, Lattice);
  }

  xmlFree(LAT);
  xmlFree(OBJS);
  xmlFree(ATTS);
  xmlFree(NODS);
}

static int IterateElements(xmlNode *a_node, FCALattice *Lattice)
{
  xmlNode *cur_node = NULL;
  int loop = 0;

  for (cur_node = a_node; cur_node; cur_node = cur_node->next)
  {
    // fprintf(stderr, "TOUR : %d\n", loop);
    if (cur_node->type == XML_ELEMENT_NODE)
    {
      // printf("node type: Element, name: %s\n", cur_node->name);
      ProcessElement(cur_node, Lattice);
    }
    IterateElements(cur_node->children, Lattice);
    loop++;
  }

  return (loop);
}

int ReadTreeXMLParse(const char *filename, FCALattice *Lattice)
{
  xmlDoc *doc = NULL;
  xmlNode *root_element = NULL;
  int NbElt = 0;

  doc = xmlReadFile(filename, NULL, 0);
  if (doc == NULL)
  {
    fprintf(stderr, "Error: could not parse file %s\n", filename);
    return (0);
  }

  /* Get the root element node */
  root_element = xmlDocGetRootElement(doc);

  NbElt = IterateElements(root_element, Lattice);

  /* Free the document */
  xmlFreeDoc(doc);

  /* Free the global variables that may have been allocated by the parser */
  xmlCleanupParser();

  return (NbElt);
}

#include "FlatFileParseXML.h"

#ifdef MYDEBUG
static void DebugReadFlatXMLPrintNode(xmlTextReaderPtr reader)
{
  const xmlChar *name, *value;

  name = xmlTextReaderConstName(reader);
  if (name == NULL)
    name = BAD_CAST "--";

  value = xmlTextReaderConstValue(reader);

  printf("%d %d %s %d %d",
	 xmlTextReaderDepth(reader),
	 xmlTextReaderNodeType(reader),
	 name,
	 xmlTextReaderIsEmptyElement(reader),
	 xmlTextReaderHasValue(reader));
  if (value == NULL)
    printf("\n");
  else
  {
    if (xmlStrlen(value) > 40)
      printf(" %.40s...\n", value);
    else
      printf(" %s\n", value);
  }
}
#endif

static void PrintMySelectedNode(xmlTextReaderPtr reader)
{
  const xmlChar *name, *value;
  xmlChar *LAT, *OBJ, *ATT;

  name = xmlTextReaderConstName(reader);
  if (name == NULL)
    return ;
  value = xmlTextReaderConstValue(reader);

  LAT = xmlCharStrdup("LAT");
  OBJ = xmlCharStrdup("OBJ");
  ATT = xmlCharStrdup("ATT");

  if (xmlStrEqual(name, LAT) == 1)
  {
    printf("LAT");
    if (value != NULL)
      printf("  %s\n", value);
    else
      printf("\n");
  }
  else if (xmlStrEqual(name, OBJ) == 1)
  {
    printf("OBJ");
    if (value != NULL)
      printf("  %s\n", value);
    else
      printf("\n");
  }
  else if (xmlStrEqual(name, ATT) == 1)
  {
    printf("ATT");
    if (value != NULL)
      printf("  %s\n", value);
    else
      printf("\n");
  }

}

void ReadFlatXMLParse(const char *filename)
{
  xmlTextReaderPtr reader;
  int ret;

  reader = xmlReaderForFile(filename, NULL, 0);
  if (reader != NULL)
  {
    ret = xmlTextReaderRead(reader);
    while (ret == 1)
    {
      # ifdef MYDEBUG
      DebugReadFlatXMLPrintNode(reader);
      # endif
      PrintMySelectedNode(reader);
      ret = xmlTextReaderRead(reader);
    }
    xmlFreeTextReader(reader);
    if (ret != 0)
    {
      fprintf(stderr, "%s : failed to parse\n", filename);
    }
  }
  else
  {
    fprintf(stderr, "Unable to open %s\n", filename);
  }
}

#include "ParseXML.hh"

void PrepareXMLParser(void)
{
  /*
   * this initialize the library and check potential ABI mismatches
   * between the version it was compiled for and the actual shared
   * library used.
   */
  LIBXML_TEST_VERSION
}

void CleanXMLParser(void)
{
  /* Cleanup function for the XML library */
  xmlCleanupParser();
  /* This is to debug memory for regression tests */
  xmlMemoryDump();
}

int MyXMLParse(const char *filename, FCALattice *Lattice)
{
  int NbElt;

  /* NbElt = ReadFlatXMLParse(filename); */
  NbElt = ReadTreeXMLParse(filename, Lattice);

  return (NbElt);
}

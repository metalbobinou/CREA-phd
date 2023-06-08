#include "ProcessingFiles.hh"

static void ProcessEachLattice(FCALattice *Lattice,
			       FCALatticeStatistics *Statistics,
			       std::string OutputDirectory)
{
  std::ofstream OFSConcepts, OFSOCW, OFSACW, OFSSimO, OFSSimA, OFSImpAbs, OFSImpRel;
  std::string OutConcepts, OutOCW, OutACW, OutSimO, OutSimA, OutImpAbs, OutImpRel;
  std::string BaseName = Lattice->GetLatticeName();

  // Print Lattice Concepts in a CSV format
  OutConcepts = BuildPath(OutputDirectory, BaseName + "-Concepts1L" + ".csv");
  OFSConcepts.open(OutConcepts.c_str(), std::ofstream::out | std::ofstream::trunc);
  Lattice->PrintLatticeConceptsCSV1Line(OFSConcepts, ";", ",");
  OFSConcepts.close();
  OutConcepts = BuildPath(OutputDirectory, BaseName + "-Concepts2L" + ".csv");
  OFSConcepts.open(OutConcepts.c_str(), std::ofstream::out | std::ofstream::trunc);
  Lattice->PrintLatticeConceptsCSV2Lines(OFSConcepts, ";");
  OFSConcepts.close();

  // Print Lattice Concepts in a readable format
  OutConcepts = BuildPath(OutputDirectory, BaseName + "-Concepts" + ".txt");
  OFSConcepts.open(OutConcepts.c_str(), std::ofstream::out | std::ofstream::trunc);
  Lattice->PrintLatticeConceptsContents(OFSConcepts);
  OFSConcepts.close();

  // Print Conceptual Weight of Objects and Attributes
  OutOCW = BuildPath(OutputDirectory, BaseName + "-ConWeiObj" + ".csv");
  OFSOCW.open(OutOCW.c_str(), std::ofstream::out | std::ofstream::trunc);
  Statistics->PrintObjectsConceptualWeight(OFSOCW);
  OFSOCW.close();
  OutACW = BuildPath(OutputDirectory, BaseName + "-ConWeiAtt" + ".csv");
  OFSACW.open(OutACW.c_str(), std::ofstream::out | std::ofstream::trunc);
  Statistics->PrintAttributesConceptualWeight(OFSACW);
  OFSACW.close();

  // Print Mutual Similarity of Objects and Attributes
  OutSimO = BuildPath(OutputDirectory, BaseName + "-SimObj" + ".csv");
  OFSSimO.open(OutSimO.c_str(), std::ofstream::out | std::ofstream::trunc);
  Statistics->PrintObjObjConceptualSimilarity(OFSSimO);
  OFSSimO.close();
  OutSimA = BuildPath(OutputDirectory, BaseName + "-SimAtt" + ".csv");
  OFSSimA.open(OutSimA.c_str(), std::ofstream::out | std::ofstream::trunc);
  Statistics->PrintAttAttConceptualSimilarity(OFSSimA);
  OFSSimA.close();

  // Print Mutual Impact and Relative Impact of Objects/Attributes
  OutImpAbs = BuildPath(OutputDirectory, BaseName + "-ImpMutAbs" + ".csv");
  OFSImpAbs.open(OutImpAbs.c_str(), std::ofstream::out | std::ofstream::trunc);
  Statistics->PrintObjAttAbsoluteImpact(OFSImpAbs);
  OFSImpAbs.close();
  OutImpRel = BuildPath(OutputDirectory, BaseName + "-ImpMutRel" + ".csv");
  OFSImpRel.open(OutImpRel.c_str(), std::ofstream::out | std::ofstream::trunc);
  Statistics->PrintObjAttRelativeImpact(OFSImpRel);
  OFSImpRel.close();
}

static void ProcessLattices(std::vector<FCALattice*> Lattices,
			    std::string OutputDirectory)
{
  std::vector<FCALattice*>::iterator iter;

  for (iter = Lattices.begin(); iter < Lattices.end(); iter++)
  {
    FCALattice *Lattice = (*iter);
    FCALatticeStatistics *Statistics = new FCALatticeStatistics(Lattice);

    #ifdef MYDEBUG
    std::cout << std::endl << "-------------------" << std::endl << std::endl;
    PrintLatticePresentation(Lattice);
    std::cout << std::endl << "-------------------" << std::endl << std::endl;
    PrintLatticeObjects(Lattice);
    std::cout << std::endl << "-------------------" << std::endl << std::endl;
    PrintLatticeAttributes(Lattice);
    std::cout << std::endl << "-------------------" << std::endl << std::endl;
    PrintLatticeConcepts(Lattice);
    std::cout << std::endl << "-------------------" << std::endl << std::endl;
    PrintLatticeHighestLowestParents(Lattice);
    std::cout << std::endl << "-------------------" << std::endl << std::endl;

    Statistics->PrintLatticeStatistics(std::cout);
    Lattice->PrintLatticeConceptsContents(std::cout);

    PrintStatistics(Lattice, Statistics);
    #endif

    ProcessEachLattice(Lattice, Statistics, OutputDirectory);

    delete (Statistics);
  }
}

static FCALattice *ReadLatticeFromXML(const char *filename)
{
  FCALattice *Lattice = new FCALattice();
  int NbElt;

  PrepareXMLParser();

  #ifdef MYDEBUG
  std::cout << "Read XML" << std::endl;
  #endif

  NbElt = MyXMLParse(filename, Lattice);

  if (NbElt != 0)
  {
   #ifdef MYDEBUG
    std::cout << "Recalculate links between childs and parents" << std::endl;
   #endif

    Lattice->CalculateConceptsLinks();
  }
  else
  {
    delete Lattice;
    Lattice = NULL;
  }

  CleanXMLParser();

  return (Lattice);
}

void ProcessingFiles(std::vector<std::string> ArgVect,
		     std::string OutputDirectory)
{
  std::vector<std::string>::iterator iArgv;
  std::vector<FCALattice*> Lattices;

  CreateSubPath(OutputDirectory.c_str());
  for (iArgv = ArgVect.begin(); iArgv < ArgVect.end(); iArgv++)
  {
    std::string Arg = (*iArgv);
    FCALattice *Lattice = NULL;
    FILE *F = NULL;

    if ((F = fopen(Arg.c_str(), "r")) == NULL)
      fprintf(stderr, "Can't open file %s\n", Arg.c_str());
    else
    {
      fclose(F);
      Lattice = ReadLatticeFromXML(Arg.c_str());
      if (Lattice != NULL)
	Lattices.push_back(Lattice);
    }
  }

  ProcessLattices(Lattices, OutputDirectory);

  ClearLatticeVector(Lattices);
  Lattices.clear();
}

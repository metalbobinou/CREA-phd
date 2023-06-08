#include "Printers.hh"

void PrintStatistics(FCALattice *Lattice, FCALatticeStatistics *Statistics)
{
  std::string InName;
  std::string OutNameObjCW, OutNameAttCW;
  std::string OutNameOOCS, OutNameAACS;
  std::string OutNameAI, OutNameRI;
  std::fstream fs;

  if ((Lattice == NULL) || (Statistics == NULL))
    return ;

  InName = Lattice->GetLatticeName();

  OutNameObjCW = InName + "-Objects-ConceptualWeight.csv";
  fs.open(OutNameObjCW.c_str(), std::fstream::out | std::fstream::trunc);
  Statistics->PrintObjectsConceptualWeight(fs);
  fs.close();

  OutNameAttCW = InName + "-Attributes-ConceptualWeight.csv";
  fs.open(OutNameAttCW.c_str(), std::fstream::out | std::fstream::trunc);
  Statistics->PrintAttributesConceptualWeight(fs);
  fs.close();

  OutNameOOCS = InName + "-ObjObj-ConceptualSimilarity.csv";
  fs.open(OutNameOOCS.c_str(), std::fstream::out | std::fstream::trunc);
  Statistics->PrintObjObjConceptualSimilarity(fs);
  fs.close();

  OutNameAACS = InName + "-AttAtt-ConceptualSimilarity.csv";
  fs.open(OutNameAACS.c_str(), std::fstream::out | std::fstream::trunc);
  Statistics->PrintAttAttConceptualSimilarity(fs);
  fs.close();

  OutNameAI = InName + "-ObjAtt-AbsoluteImpact.csv";
  fs.open(OutNameAI.c_str(), std::fstream::out | std::fstream::trunc);
  Statistics->PrintObjAttAbsoluteImpact(fs);
  fs.close();

  OutNameRI = InName + "-ObjAtt-RelativeImpact.csv";
  fs.open(OutNameRI.c_str(), std::fstream::out | std::fstream::trunc);
  Statistics->PrintObjAttRelativeImpact(fs);
  fs.close();
}

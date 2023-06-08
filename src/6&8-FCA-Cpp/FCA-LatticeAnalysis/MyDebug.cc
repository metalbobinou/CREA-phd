#include "MyDebug.hh"

void PrintLatticePresentation(FCALattice *Lattice)
{
  std::string name = Lattice->GetLatticeName();
  int NbObjects = Lattice->GetNbObjects();
  int NbAttributes = Lattice->GetNbAttributes();

  std::cout <<
    "Lattice (" << name << ")" << std::endl <<
    "Nb Objects : " << NbObjects << std::endl <<
    "Nb Attributes : " << NbAttributes << std::endl <<
    std::endl;
}

void PrintLatticeObjects(FCALattice *Lattice)
{
  std::string name = Lattice->GetLatticeName();
  int NbObjects = Lattice->GetNbObjects();

  std::cout <<
    "Printing " << NbObjects << " Objects of the Lattice " <<
    name << std::endl;
  std::cout << std::endl;

  Lattice->PrintLatticeObjects(std::cout);
}

void PrintLatticeAttributes(FCALattice *Lattice)
{
  std::string name = Lattice->GetLatticeName();
  int NbAttributes = Lattice->GetNbAttributes();

  std::cout <<
    "Printing " << NbAttributes << " Attributes of the Lattice (" <<
    name << ")" << std::endl;
  std::cout << std::endl;

  Lattice->PrintLatticeAttributes(std::cout);
}

void PrintLatticeConcepts(FCALattice *Lattice)
{
  std::string name = Lattice->GetLatticeName();
  int NbConcepts = Lattice->GetNbConcepts();

  std::cout <<
    "Printing " << NbConcepts << " Concepts of the Lattice (" <<
    name << ")" << std::endl;
  std::cout << std::endl;

  Lattice->PrintLatticeConcepts(std::cout);
}

void PrintLatticeHighestLowestParents(FCALattice *Lattice)
{
  std::string name = Lattice->GetLatticeName();
  int FirstParent = Lattice->GetHighestParentID();
  int LastChildren = Lattice->GetLowestChildID();

  std::cout <<
    "Lattice (" << name << ") has :" << std::endl <<
    " - Highest Parent : " << FirstParent << std::endl <<
    " - Lowest Children : " << LastChildren << std::endl;
}

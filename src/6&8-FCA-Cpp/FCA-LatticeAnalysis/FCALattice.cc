#include "FCALattice.hh"

// Clear a vector of pointers
void ClearLatticeVector(std::vector<FCALattice*> Lattices)
{
  for (std::vector<FCALattice*>::iterator iter = Lattices.begin();
       iter < Lattices.end();
       iter++)
  {
    FCALattice *Lattice = (*iter);

    delete (Lattice);
  }
}


// FCALattice class
FCALattice::FCALattice()
{
}

FCALattice::~FCALattice()
{
  ClearAll();
}

// Add one concept in the lattice
void FCALattice::AddConcept(FCAConcept *NewConcept)
{
  this->Concepts.push_back(NewConcept);
}

void FCALattice::AddObject(FCAObject *NewObject)
{
  this->Objects.push_back(NewObject);
}

void FCALattice::AddAttribute(FCAAttribute *NewAttribute)
{
  this->Attributes.push_back(NewAttribute);
}

void FCALattice::UpdateName(std::string NewLatticeName)
{
  this->LatticeName = NewLatticeName;
}

// Recalculate each concept childs/parents
// STILL NOT OPTIMIZED
void FCALattice::CalculateConceptsLinks()

{
  for (std::vector<FCAConcept*>::iterator iter = Concepts.begin();
       iter < Concepts.end();
       iter++)
    (*iter)->GenerateCloseConceptsPtrs(this);

  FCAConcept *FirstParent = this->GetHighestParentRef();
  if (FirstParent != NULL)
    FirstParent->UpdateAllLevels(0);

  int Max = 0;
  for (std::vector<FCAConcept*>::iterator iter = Concepts.begin();
       iter < Concepts.end();
       iter++)
    if ((*iter)->GetLevel() > Max)
      Max = (*iter)->GetLevel();

  this->MaxLevel = Max;
}

std::string FCALattice::GetLatticeName()
{
  return (this->LatticeName);
}

int FCALattice::GetNbLevel()
{
  return (this->MaxLevel);
}

// Get Concept
FCAConcept *FCALattice::GetConcept(int IDConcept)
{
  std::vector<FCAConcept*>::iterator iter = Concepts.begin();

  while ((iter < Concepts.end()) &&
	 ((*iter)->GetIDConcept() != IDConcept))
    iter++;

  if (iter == Concepts.end())
    return (NULL);
  else
    return (*iter);
}

std::vector<FCAConcept*> FCALattice::GetAllConcepts()
{
  std::vector<FCAConcept*> NewVect =
    std::vector<FCAConcept*>(this->Concepts);

  return (NewVect);
}

FCAObject *FCALattice::GetObject(int IDObject)
{
  std::vector<FCAObject*>::iterator iter = Objects.begin();

  while ((iter < Objects.end()) && ((*iter)->GetIDObject() != IDObject))
    iter++;

  return (*iter);
}

FCAObject *FCALattice::GetObject(std::string ObjectName)
{
  std::vector<FCAObject*>::iterator iter = Objects.begin();

  while ((iter < Objects.end()) &&
	 (ObjectName.compare((*iter)->GetNameObject()) != 0))
    iter++;

  return (*iter);
}

std::vector<FCAObject*> FCALattice::GetAllObjects()
{
  std::vector<FCAObject*> NewVect =
    std::vector<FCAObject*>(this->Objects);

  return (NewVect);
}

FCAAttribute *FCALattice::GetAttribute(int IDAttribute)
{
  std::vector<FCAAttribute*>::iterator iter = Attributes.begin();

  while ((iter < Attributes.end()) &&
	 ((*iter)->GetIDAttribute() != IDAttribute))
    iter++;

  return (*iter);
}

FCAAttribute *FCALattice::GetAttribute(std::string AttributeName)
{
  std::vector<FCAAttribute*>::iterator iter = Attributes.begin();

  while ((iter < Attributes.end()) &&
	 (AttributeName.compare((*iter)->GetNameAttribute()) != 0))
    iter++;

  return (*iter);
}

std::vector<FCAAttribute*> FCALattice::GetAllAttributes()
{
  std::vector<FCAAttribute*> NewVect =
    std::vector<FCAAttribute*>(this->Attributes);

  return (NewVect);
}


// Delete all the concepts stored in the lattice
void FCALattice::ClearAllConcepts()
{
  for (std::vector<FCAConcept*>::iterator iter = Concepts.begin();
       iter < Concepts.end();
       iter++)
    delete (*iter);
}

void FCALattice::ClearAllObjects()
{
  for (std::vector<FCAObject*>::iterator iter = Objects.begin();
       iter < Objects.end();
       iter++)
    delete (*iter);
}

void FCALattice::ClearAllAttributes()
{
  for (std::vector<FCAAttribute*>::iterator iter = Attributes.begin();
       iter < Attributes.end();
       iter++)
    delete (*iter);
}

void FCALattice::ClearAll()
{
  ClearAllConcepts();
  ClearAllObjects();
  ClearAllAttributes();
}

// Get statistics
int FCALattice::GetNbConcepts()
{
  return (this->Concepts.size());
}

int FCALattice::GetNbObjects()
{
  return (this->Objects.size());
}

int FCALattice::GetNbAttributes()
{
  return (this->Attributes.size());
}

// Get references on 1st parent and last child
FCAConcept *FCALattice::GetHighestParentRef()
{
  for (std::vector<FCAConcept*>::iterator iter = this->Concepts.begin();
       iter < this->Concepts.end();
       iter++)
  {
    FCAConcept *CurConcept = (*iter);

    if (CurConcept->GetNbOfParents() == 0)
      return (CurConcept);
  }
  return (NULL);
}

int FCALattice::GetHighestParentID()
{
  for (std::vector<FCAConcept*>::iterator iter = this->Concepts.begin();
       iter < this->Concepts.end();
       iter++)
  {
    FCAConcept *CurConcept = (*iter);

    if (CurConcept->GetNbOfParents() == 0)
      return (CurConcept->GetIDConcept());
  }
  return (INT_MAX);
}

FCAConcept *FCALattice::GetLowestChildRef()
{
  for (std::vector<FCAConcept*>::iterator iter = this->Concepts.begin();
       iter < this->Concepts.end();
       iter++)
  {
    FCAConcept *CurConcept = (*iter);

    if (CurConcept->GetNbOfChilds() == 0)
      return (CurConcept);
  }
  return (NULL);
}

int FCALattice::GetLowestChildID()
{
  for (std::vector<FCAConcept*>::iterator iter = this->Concepts.begin();
       iter < this->Concepts.end();
       iter++)
  {
    FCAConcept *CurConcept = (*iter);

    if (CurConcept->GetNbOfChilds() == 0)
      return (CurConcept->GetIDConcept());
  }
  return (INT_MAX);
}

// Print values

// Print one line with objects and attributes separated by a sub separator
void FCALattice::PrintLatticeConceptsCSV1Line(std::ostream& stream,
					      std::string MainSeparator,
					      std::string SubSeparator)
{
  std::vector<FCAConcept*>::iterator iConcept;

  stream << "Concept ID" << MainSeparator;
  stream << "Level" << MainSeparator;
  stream << "Nb Obj" << MainSeparator;
  stream << "Nb Att" << MainSeparator;
  stream << "Objects" << MainSeparator;
  stream << "Attributes" << MainSeparator;
  stream << std::endl;

  for (iConcept = Concepts.begin(); iConcept < Concepts.end(); iConcept++)
  {
    FCAConcept *Concept = (*iConcept);

    // Print a line with objects and attributes
    stream << Concept->GetIDConcept() << MainSeparator;
    stream << Concept->GetLevel() << MainSeparator;
    stream << Concept->GetNbObjects() << MainSeparator;
    stream << Concept->GetNbAttributes() << MainSeparator;
    Concept->PrintObjectsNameCSV(stream, SubSeparator);
    stream << MainSeparator;
    Concept->PrintAttributesNameCSV(stream, SubSeparator);
    stream << MainSeparator;
    stream << std::endl;
  }
}

// Print one line with objects, and one line with attributes
void FCALattice::PrintLatticeConceptsCSV2Lines(std::ostream& stream,
					       std::string separator)
{
  std::vector<FCAConcept*>::iterator iConcept;

  stream << "Concept ID" << separator;
  stream << "Level" << separator;
  stream << "Type Obj/Att" << separator;
  stream << "Nb Obj" << separator;
  stream << "Nb Att" << separator;
  stream << "Objects/Attributes" << separator;
  stream << std::endl;

  for (iConcept = Concepts.begin(); iConcept < Concepts.end(); iConcept++)
  {
    FCAConcept *Concept = (*iConcept);

    // Print first a line with objects
    stream << Concept->GetIDConcept() << separator;
    stream << Concept->GetLevel() << separator;
    stream << "Objects" << separator;
    stream << Concept->GetNbObjects() << separator;
    stream << Concept->GetNbAttributes() << separator;
    Concept->PrintObjectsNameCSV(stream, separator);
    stream << std::endl;

    // Print then a line with attributes
    stream << Concept->GetIDConcept() << separator;
    stream << Concept->GetLevel() << separator;
    stream << "Attributes" << separator;
    stream << Concept->GetNbObjects() << separator;
    stream << Concept->GetNbAttributes() << separator;
    Concept->PrintAttributesNameCSV(stream, separator);
    stream << std::endl;
  }
}

// Print values
void FCALattice::PrintLatticeConceptsContents(std::ostream& stream)
{
  std::vector<FCAConcept*>::iterator iConcept;

  for (iConcept = Concepts.begin(); iConcept < Concepts.end(); iConcept++)
  {
    FCAConcept *Concept = (*iConcept);

    stream << "Concept " << "(" << Concept->GetIDConcept() << ") : " << std::endl;

    stream << "  level : " << Concept->GetLevel() << std::endl;

    stream << "  objects (" << Concept->GetNbObjects()  << ") : ";
    Concept->PrintObjectsName(stream);

    stream << "  attributes (" << Concept->GetNbAttributes() << ") : ";
    Concept->PrintAttributesName(stream);

    stream << "  parents concepts (" << Concept->GetNbOfParents() << ") : ";
    Concept->PrintParentsID(stream);

    stream << "  childs concepts (" << Concept->GetNbOfChilds() << ") : ";
    Concept->PrintChildsID(stream);

    stream << std::endl;
  }
}

void FCALattice::PrintLatticeConcepts(std::ostream& stream)
{
  std::vector<FCAConcept*>::iterator iter;

  for (iter = Concepts.begin(); iter < Concepts.end(); iter++)
  {
    stream << "Concept " <<
      "(" << (*iter)->GetIDConcept() << ") parents : " <<
      std::endl;
    (*iter)->PrintParentsID(stream);

    stream << "Concept " <<
      "(" << (*iter)->GetIDConcept() << ") childs : " <<
      std::endl;
    (*iter)->PrintChildsID(stream);

    stream << std::endl;
  }
}

void FCALattice::PrintLatticeObjects(std::ostream& stream)
{
  std::vector<FCAObject*>::iterator iter;

  for (iter = Objects.begin(); iter < Objects.end(); iter++)
  {
    stream << (*iter)->GetNameObject() <<
      " (" << (*iter)->GetIDObject() << ")" <<
      std::endl;
  }
}

void FCALattice::PrintLatticeAttributes(std::ostream& stream)
{
  std::vector<FCAAttribute*>::iterator iter;

  for (iter = Attributes.begin(); iter < Attributes.end(); iter++)
  {
    stream << (*iter)->GetNameAttribute() <<
      " (" << (*iter)->GetIDAttribute() << ")" <<
      std::endl;
  }
}

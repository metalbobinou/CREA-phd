#include "FCAConcept.hh"

FCAConcept::FCAConcept(int NewIDConcept)
{
  this->IDConcept = NewIDConcept;
  this->Level = INT_MAX;
}

FCAConcept::~FCAConcept()
{
}


void FCAConcept::AddParent(int Parent)
{
  this->ParentIDs.push_back(Parent);
}

void FCAConcept::AddObject(FCAObject *Object)
{
  this->Objects.push_back(Object);
}

void FCAConcept::AddAttribute(FCAAttribute *Attribute)
{
  this->Attributes.push_back(Attribute);
}

void FCAConcept::UpdateLevel(int NewLevel)
{
  this->Level = NewLevel;
}


int FCAConcept::GetIDConcept()
{
  return (this->IDConcept);
}

int FCAConcept::GetLevel()
{
  return (this->Level);
}

int FCAConcept::GetNbObjects()
{
  return (this->Objects.size());
}

int FCAConcept::GetNbAttributes()
{
  return (this->Attributes.size());
}

// Search for a precise object in the Concept
bool FCAConcept::HasObject(int ObjectID)
{
  std::vector<FCAObject*>::iterator iter;

  for (iter = this->Objects.begin(); iter < this->Objects.end(); iter++)
  {
    if ((*iter)->GetIDObject() == ObjectID)
      return (true);
  }
  return (false);
}

bool FCAConcept::HasObject(std::string ObjectName)
{
  std::vector<FCAObject*>::iterator iter;

  for (iter = this->Objects.begin(); iter < this->Objects.end(); iter++)
  {
    if ((*iter)->GetNameObject() == ObjectName)
      return (true);
  }
  return (false);
}

// Search for a precise attribute in the Concept
bool FCAConcept::HasAttribute(int AttributeID)
{
  std::vector<FCAAttribute*>::iterator iter;

  for (iter = this->Attributes.begin(); iter < this->Attributes.end(); iter++)
  {
    if ((*iter)->GetIDAttribute() == AttributeID)
      return (true);
  }
  return (false);
}

bool FCAConcept::HasAttribute(std::string AttributeName)
{
  std::vector<FCAAttribute*>::iterator iter;

  for (iter = this->Attributes.begin(); iter < this->Attributes.end(); iter++)
  {
    if ((*iter)->GetNameAttribute() == AttributeName)
      return (true);
  }
  return (false);
}

// Test if the current Concept is the child of the concept given in parameter
bool FCAConcept::HasParent(int ConceptID)
{
  for (std::vector<int>::iterator iter = this->ParentIDs.begin();
       iter < this->ParentIDs.end();
       iter++)
  {
    if ((*iter) == ConceptID)
      return (true);
  }
  return (false);
}

// Get copy of Objects and Attributes vectors
std::vector<FCAObject*> FCAConcept::GetAllObjects()
{
  std::vector<FCAObject*> NewVect =
    std::vector<FCAObject*>(this->Objects);

  return (NewVect);
}

std::vector<FCAAttribute*> FCAConcept::GetAllAttributes()
{
  std::vector<FCAAttribute*> NewVect =
    std::vector<FCAAttribute*>(this->Attributes);

  return (NewVect);
}


// OBTAINED AFTER THE CLOSE PARENTS POINTERS HAVE BEEN UPDATED
// Get information on Parents and Childs vector size
int FCAConcept::GetNbOfParents()
{
  return (ParentIDs.size());
}

// OBTAINED AFTER THE CLOSE PARENTS POINTERS HAVE BEEN UPDATED
int FCAConcept::GetNbOfChilds()
{
  return (ChildConcepts.size());
}

// OBTAINED AFTER THE CLOSE PARENTS POINTERS HAVE BEEN UPDATED
std::vector<FCAConcept*> FCAConcept::GetParents()
{
  std::vector<FCAConcept*> NewVect =
    std::vector<FCAConcept*>(this->ParentConcepts);

  return (NewVect);
}

// OBTAINED AFTER THE CLOSE PARENTS POINTERS HAVE BEEN UPDATED
std::vector<FCAConcept*> FCAConcept::GetChilds()
{
  std::vector<FCAConcept*> NewVect =
    std::vector<FCAConcept*>(this->ChildConcepts);

  return (NewVect);
}


// Generate from the ParentIDs, and the Lattice, the two vectors of pointers
// STILL NOT OPTIMIZED
void FCAConcept::GenerateCloseConceptsPtrs(FCALattice *Lattice)
{
  #ifdef MYDEBUG
  std::cout << "* Concept (" << this->IDConcept << ")" << std::endl;
  std::cout << "Calculate Parent Concepts Pointers" << std::endl;
  #endif
  GenerateParentConceptsPtrs(Lattice);

  #ifdef MYDEBUG
  std::cout << "Calculate Child Concepts Pointers" << std::endl;
  #endif
  GenerateChildConceptsPtrs(Lattice);
}

// Update the level of the current Concept and its child
void FCAConcept::UpdateAllLevels(int NewLevel)
{
  this->Level = NewLevel;

  for (std::vector<FCAConcept*>::iterator iter =
         this->ChildConcepts.begin();
       iter < this->ChildConcepts.end();
       iter++)
    (*iter)->UpdateAllLevels(NewLevel + 1);
}

// Print Names of Objects contained
void FCAConcept::PrintObjectsNameCSV(std::ostream& stream,
				     std::string separator)
{
  for (std::vector<FCAObject*>::iterator iObject = Objects.begin();
       iObject < Objects.end();
       iObject++)
    stream << (*iObject)->GetNameObject() << separator;
}

void FCAConcept::PrintAttributesNameCSV(std::ostream& stream,
					std::string separator)
{
  for (std::vector<FCAAttribute*>::iterator iAttribute = Attributes.begin();
       iAttribute < Attributes.end();
       iAttribute++)
    stream << (*iAttribute)->GetNameAttribute() << separator;
}

void FCAConcept::PrintObjectsName(std::ostream& stream)
{
  this->PrintObjectsNameCSV(stream, " ");
  stream << std::endl;
}

void FCAConcept::PrintAttributesName(std::ostream& stream)
{
  this->PrintAttributesNameCSV(stream, " ");
  stream << std::endl;
}

// Print IDs of parents and childs
void FCAConcept::PrintParentsID(std::ostream& stream)
{
  for (std::vector<FCAConcept*>::iterator iter =
         this->ParentConcepts.begin();
       iter < this->ParentConcepts.end();
       iter++)
    stream << (*iter)->GetIDConcept() << " ";
  stream << std::endl;
}

void FCAConcept::PrintChildsID(std::ostream& stream)
{
  for (std::vector<FCAConcept*>::iterator iter =
         this->ChildConcepts.begin();
       iter < this->ChildConcepts.end();
       iter++)
    stream << (*iter)->GetIDConcept() << " ";
  stream << std::endl;
}


/*****************************************************************************/
/********************************* PRIVATE ***********************************/
/*****************************************************************************/

// We search all of the parents declared in the XML
void FCAConcept::GenerateParentConceptsPtrs(FCALattice *Lattice)
{
  this->ParentConcepts.clear();

  for (std::vector<int>::iterator iter = this->ParentIDs.begin();
       iter < this->ParentIDs.end();
       iter++)
  {
    int ParentID = (*iter);

    this->ParentConcepts.push_back(Lattice->GetConcept(ParentID));
  }
}

// We search in the whole possible Concepts which one are parents of current
void FCAConcept::GenerateChildConceptsPtrs(FCALattice *Lattice)
{
  std::vector<FCAConcept*> ConceptsVector = Lattice->GetAllConcepts();
  int MyID = this->IDConcept;

  this->ChildConcepts.clear();

  for (std::vector<FCAConcept*>::iterator iter = ConceptsVector.begin();
       iter < ConceptsVector.end();
       iter++)
  {
    FCAConcept *CurConcept = (*iter);
    int CurConceptID = CurConcept->GetIDConcept();

    if (CurConcept->HasParent(MyID))
      this->ChildConcepts.push_back(Lattice->GetConcept(CurConceptID));
  }
}

/*****************************************************************************/
/********************************* FUNCTIONS *********************************/
/*****************************************************************************/

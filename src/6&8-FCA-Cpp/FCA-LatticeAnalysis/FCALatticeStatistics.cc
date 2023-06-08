#include "FCALatticeStatistics.hh"

FCALatticeStatistics::FCALatticeStatistics(FCALattice *StudiedLattice)
{
  if (StudiedLattice == NULL)
    throw std::runtime_error("Lattice cannot be NULL");

  this->Lattice = StudiedLattice;
  this->LatticeName = StudiedLattice->GetLatticeName();

  BuildBasicStatistics();
  BuildNbLinks();

  BuildNbObjectApparition();
  BuildNbAttributeApparition();

  BuildObjectsConceptualWeight();
  BuildAttributesConceptualWeight();

  BuildObjObjConceptualSimilarity();
  BuildAttAttConceptualSimilarity();

  BuildObjAttImpacts();
}

FCALatticeStatistics::~FCALatticeStatistics()
{
}

/*****************************************************************************/
/****************************** SIMPLE STATISTICS ****************************/
/*****************************************************************************/

// Get statistics
int FCALatticeStatistics::GetNbObjects()
{
  return (this->NbObjects);
}

int FCALatticeStatistics::GetNbAttributes()
{
  return (this->NbAttributes);
}

int FCALatticeStatistics::GetNbConcepts()
{
  return (this->NbConcepts);
}

int FCALatticeStatistics::GetNbLinks()
{
  return (this->NbLinks);
}

int FCALatticeStatistics::GetObjectApparition(int ObjectID)
{
  return (this->ObjectsApparition[ObjectID]);
}

int FCALatticeStatistics::GetObjectsApparition(FCAObject *Object)
{
  return (this->ObjectsApparition[Object->GetIDObject()]);
}

int FCALatticeStatistics::GetObjectsApparition(std::string ObjectName)
{
  FCAObject *Object = this->Lattice->GetObject(ObjectName);
  return (this->ObjectsApparition[Object->GetIDObject()]);
}

int FCALatticeStatistics::GetAttributeApparition(int AttributeID)
{
  return (this->AttributesApparition[AttributeID]);
}

int FCALatticeStatistics::GetAttributeApparition(FCAAttribute *Attribute)
{
  return (this->AttributesApparition[Attribute->GetIDAttribute()]);
}

int FCALatticeStatistics::GetAttributeApparition(std::string AttributeName)
{
  FCAAttribute *Attribute = this->Lattice->GetAttribute(AttributeName);
  return (this->AttributesApparition[Attribute->GetIDAttribute()]);
}

/*****************************************************************************/
/*************************** BUILD COMPLEX STATISTICS ************************/
/*****************************************************************************/

/* Build Lattice Statistics */

// Get basic infos from the Lattice
void FCALatticeStatistics::BuildBasicStatistics()
{
  this->NbObjects = Lattice->GetNbObjects();
  this->NbAttributes = Lattice->GetNbAttributes();
  this->NbConcepts = Lattice->GetNbConcepts();
  this->NbLevels = Lattice->GetNbLevel();
  this->HighestParentRef = Lattice->GetHighestParentRef();
  this->HighestParentID = Lattice->GetHighestParentID();
  this->LowestChildRef = Lattice->GetLowestChildRef();
  this->LowestChildID = Lattice->GetLowestChildID();

  this->BuildAverages();
}

// Calculate the number of links in the Lattice
void FCALatticeStatistics::BuildNbLinks()
{
  std::vector<FCAConcept*>::iterator iter;
  int NbParents = 0;

  for (iter = this->Lattice->Concepts.begin();
       iter < this->Lattice->Concepts.end();
       iter++)
  {
    FCAConcept *Concept = (*iter);
    NbParents += Concept->GetNbOfParents();
  }

  this->NbLinks = NbParents;
}

// Build multiple averages
void FCALatticeStatistics::BuildAverages()
{
  std::vector<FCAConcept*>::iterator iConcept;
  int CntObj = 0, CntAtt = 0, CntPar = 0, CntChd = 0;

  for (iConcept = this->Lattice->Concepts.begin();
       iConcept < this->Lattice->Concepts.end();
       iConcept++)
  {
    FCAConcept *Concept = (*iConcept);
    CntObj += Concept->GetNbObjects();
    CntAtt += Concept->GetNbAttributes();
    CntPar += Concept->GetNbOfParents();
    CntChd += Concept->GetNbOfChilds();
  }
  this->AvgNbObjects = (double) CntObj / (double) this->NbConcepts;
  this->AvgNbAttributes = (double) CntAtt / (double) this->NbConcepts;
  this->AvgNbParents = (double) CntPar / (double) this->NbConcepts;
  this->AvgNbChilds = (double) CntChd / (double) this->NbConcepts;
  this->AvgSizConcepts = this->AvgNbObjects + this->AvgNbAttributes;
}

// Calculate ALL the objects
// STILL NOT OPTIMIZED
void FCALatticeStatistics::BuildNbObjectApparition()
{
  std::vector<FCAObject*>::iterator iObject;
  for (iObject = this->Lattice->Objects.begin();
       iObject < this->Lattice->Objects.end();
       iObject++)
    this->BuildNbObjectApparition(*iObject);
}

// Calculate the apparition of one object in the whole Lattice
void FCALatticeStatistics::BuildNbObjectApparition(FCAObject *Object)
{
  std::vector<FCAConcept*>::iterator iConcept;
  int ObjectID = Object->GetIDObject();
  int NbApparitions = 0;

  for (iConcept = this->Lattice->Concepts.begin();
       iConcept < this->Lattice->Concepts.end();
       iConcept++)
  {
    FCAConcept *Concept = (*iConcept);
    if (Concept->HasObject(ObjectID))
      NbApparitions++;
  }

  this->ObjectsApparition[ObjectID] = NbApparitions;
}

// Calculate ALL the attributes
// STILL NOT OPTIMIZED
void FCALatticeStatistics::BuildNbAttributeApparition()
{
  std::vector<FCAAttribute*>::iterator iAttribute;
  for (iAttribute = this->Lattice->Attributes.begin();
       iAttribute < this->Lattice->Attributes.end();
       iAttribute++)
    this->BuildNbAttributeApparition(*iAttribute);
}

// Calculate the apparition of one attribute in the whole Lattice
void FCALatticeStatistics::BuildNbAttributeApparition(FCAAttribute *Attribute)
{
  std::vector<FCAConcept*>::iterator iConcept;
  int AttributeID = Attribute->GetIDAttribute();
  int NbApparitions = 0;

  for (iConcept = this->Lattice->Concepts.begin();
       iConcept < this->Lattice->Concepts.end();
       iConcept++)
  {
    FCAConcept *Concept = (*iConcept);
    if (Concept->HasAttribute(AttributeID))
      NbApparitions++;
  }

  this->AttributesApparition[AttributeID] = NbApparitions;
}

// Calculate the Conceptual Weight of Objects and Attributes
void FCALatticeStatistics::BuildObjectsConceptualWeight()
{
  std::vector<FCAObject*>::iterator iObject;

  for (iObject = this->Lattice->Objects.begin();
       iObject < this->Lattice->Objects.end();
       iObject++)
  {
    FCAObject *Object = (*iObject);
    this->BuildObjectsConceptualWeight(Object);
  }
}

void FCALatticeStatistics::BuildObjectsConceptualWeight(FCAObject *Object)
{
  int ObjectID = Object->GetIDObject();
  int NbApparitions = ObjectsApparition[ObjectID];
  double ConceptualWeight;

  ConceptualWeight = (double) NbApparitions / (double) this->NbConcepts;
  this->ObjectsConceptualWeight[ObjectID] = ConceptualWeight;
}

// NOT OPTIMIZED
void FCALatticeStatistics::BuildAttributesConceptualWeight()
{
  std::vector<FCAAttribute*>::iterator iAttribute;

  for (iAttribute = this->Lattice->Attributes.begin();
       iAttribute < this->Lattice->Attributes.end();
       iAttribute++)
  {
    FCAAttribute *Attribute = (*iAttribute);
    this->BuildAttributesConceptualWeight(Attribute);
  }
}

// NOT OPTIMIZED
void FCALatticeStatistics::BuildAttributesConceptualWeight(FCAAttribute *Attribute)
{
  int AttributeID = Attribute->GetIDAttribute();
  int NbApparitions = this->AttributesApparition[AttributeID];
  double ConceptualWeight;

  ConceptualWeight = (double) NbApparitions / (double) this->NbConcepts;
  this->AttributesConceptualWeight[AttributeID] = ConceptualWeight;
}

// Calculate the Conceptual Weight of 2 object(s)/attribute(s)
// NOT OPTIMIZED
void FCALatticeStatistics::BuildObjObjConceptualSimilarity()
{
  std::vector<FCAObject*>::iterator iObject1;
  for (iObject1 = this->Lattice->Objects.begin();
       iObject1 < this->Lattice->Objects.end();
       iObject1++)
  {
    FCAObject *Object1 = (*iObject1);

    std::vector<FCAObject*>::iterator iObject2;
    for (iObject2 = this->Lattice->Objects.begin();
	 iObject2 < this->Lattice->Objects.end();
	 iObject2++)
    {
      FCAObject *Object2 = (*iObject2);
      this->BuildObjObjConceptualSimilarity(Object1, Object2);
    }
  }
}

// NOT OPTIMIZED
void FCALatticeStatistics::BuildObjObjConceptualSimilarity(FCAObject *Obj1,
							   FCAObject *Obj2)
{
  int Obj1ID = Obj1->GetIDObject();
  int Obj2ID = Obj2->GetIDObject();
  int Obj1And2 = 0, Obj1Or2 = 0;
  double ConceptualWeight;

  for (std::vector<FCAConcept*>::iterator iConcept =
	 this->Lattice->Concepts.begin();
       iConcept < this->Lattice->Concepts.end();
       iConcept++)
  {
    FCAConcept *Concept = (*iConcept);

    if ((Concept->HasObject(Obj1ID)) && (Concept->HasObject(Obj2ID)))
      Obj1And2++;
    if ((Concept->HasObject(Obj1ID)) || (Concept->HasObject(Obj2ID)))
      Obj1Or2++;
  }
  ConceptualWeight = (double) Obj1And2 / (double) Obj1Or2;
  this->ObjectObjectConceptualSimilarity.insert(std::make_pair(
		   (std::make_pair(Obj1ID, Obj2ID)), ConceptualWeight));
}

// NOT OPTIMIZED
void FCALatticeStatistics::BuildAttAttConceptualSimilarity()
{
  std::vector<FCAAttribute*>::iterator iAttribute1;
  for (iAttribute1 = this->Lattice->Attributes.begin();
       iAttribute1 < this->Lattice->Attributes.end();
       iAttribute1++)
  {
    FCAAttribute *Attribute1 = (*iAttribute1);

    std::vector<FCAAttribute*>::iterator iAttribute2;
    for (iAttribute2 = this->Lattice->Attributes.begin();
	 iAttribute2 < this->Lattice->Attributes.end();
	 iAttribute2++)
    {
      FCAAttribute *Attribute2 = (*iAttribute2);
      this->BuildAttAttConceptualSimilarity(Attribute1, Attribute2);
    }
  }
}

// NOT OPTIMIZED
void FCALatticeStatistics::BuildAttAttConceptualSimilarity(FCAAttribute *Att1,
							   FCAAttribute *Att2)
{
  int Att1ID = Att1->GetIDAttribute();
  int Att2ID = Att2->GetIDAttribute();
  int Att1And2 = 0, Att1Or2 = 0;
  double ConceptualWeight;

  for (std::vector<FCAConcept*>::iterator iConcept =
	 this->Lattice->Concepts.begin();
       iConcept < this->Lattice->Concepts.end();
       iConcept++)
  {
    FCAConcept *Concept = (*iConcept);

    if ((Concept->HasAttribute(Att1ID)) && (Concept->HasAttribute(Att2ID)))
      Att1And2++;
    if ((Concept->HasAttribute(Att1ID)) || (Concept->HasAttribute(Att2ID)))
      Att1Or2++;
  }
  ConceptualWeight = (double) Att1And2 / (double) Att1Or2;
  this->AttributeAttributeConceptualSimilarity.insert(std::make_pair(
		   (std::make_pair(Att1ID, Att2ID)), ConceptualWeight));
}

// NOT OPTIMIZED
void FCALatticeStatistics::BuildObjAttImpacts()
{
  std::vector<FCAObject*>::iterator iObject;
  for (iObject = this->Lattice->Objects.begin();
       iObject < this->Lattice->Objects.end();
       iObject++)
  {
    FCAObject *Object = (*iObject);

    std::vector<FCAAttribute*>::iterator iAttribute;
    for (iAttribute = this->Lattice->Attributes.begin();
	 iAttribute < this->Lattice->Attributes.end();
	 iAttribute++)
    {
      FCAAttribute *Attribute = (*iAttribute);
      this->BuildObjAttImpacts(Object, Attribute);
    }
  }
}

// NOT OPTIMIZED
void FCALatticeStatistics::BuildObjAttImpacts(FCAObject *Obj,
					      FCAAttribute *Att)
{
  int ObjID = Obj->GetIDObject();
  int AttID = Att->GetIDAttribute();
  int ObjAndAtt = 0, ObjOrAtt = 0;
  double AbsoluteImpact, RelativeImpact;

  for (std::vector<FCAConcept*>::iterator iConcept =
	 this->Lattice->Concepts.begin();
       iConcept < this->Lattice->Concepts.end();
       iConcept++)
  {
    FCAConcept *Concept = (*iConcept);

    if ((Concept->HasObject(ObjID)) && (Concept->HasAttribute(AttID)))
      ObjAndAtt++;
    if ((Concept->HasObject(ObjID)) || (Concept->HasAttribute(AttID)))
      ObjOrAtt++;
  }
  AbsoluteImpact = (double) ObjAndAtt / (double) this->NbConcepts;
  RelativeImpact = (double) ObjAndAtt / (double) ObjOrAtt;
  this->ObjectAttributeAbsoluteImpact.insert(std::make_pair(
		   (std::make_pair(ObjID, AttID)), AbsoluteImpact));
  this->ObjectAttributeRelativeImpact.insert(std::make_pair(
		   (std::make_pair(ObjID, AttID)), RelativeImpact));
}


/*****************************************************************************/
/********************************** PRINTERS *********************************/
/*****************************************************************************/

void FCALatticeStatistics::PrintLatticeStatistics(std::ostream& stream)
{
  stream << "Lattice (" << this->LatticeName << ") statistics :" << std::endl;
  stream << "Nb Objects : " << this->NbObjects << std::endl;
  stream << "Nb Attributes : " << this->NbAttributes << std::endl;
  stream << "Nb Concepts : " << this->NbConcepts << std::endl;
  stream << "Nb Links : " << this->NbLinks << std::endl;
  stream << "Nb Levels : " << this->NbLevels << std::endl;
  stream << "Avg Nb Objects : " << this->AvgNbObjects << std::endl;
  stream << "Avg Nb Attributes : " << this->AvgNbAttributes << std::endl;
  stream << "Avg Nb Parents : " << this->AvgNbParents << std::endl;
  stream << "Avg Nb Childs : " << this->AvgNbChilds << std::endl;
  stream << "Avg Size Concepts : " << this->AvgSizConcepts << std::endl;
  stream << std::endl;
}

void FCALatticeStatistics::PrintObjectsApparition(std::ostream& stream)
{
  stream << "Apparitions of each Object : " << std::endl;
  for (std::vector<FCAObject*>::iterator iter = Lattice->Objects.begin();
       iter < Lattice->Objects.end();
       iter++)
    stream << "- " << (*iter)->GetNameObject() << " : " <<
      this->ObjectsApparition[(*iter)->GetIDObject()] << std::endl;
}

void FCALatticeStatistics::PrintAttributesApparition(std::ostream& stream)
{
  stream << "Apparitions of each Attribute : " << std::endl;
  for (std::vector<FCAAttribute*>::iterator iter = Lattice->Attributes.begin();
       iter < Lattice->Attributes.end();
       iter++)
    stream << "- " << (*iter)->GetNameAttribute() << " : " <<
      this->AttributesApparition[(*iter)->GetIDAttribute()] << std::endl;
}

// Conceptual Weight
void FCALatticeStatistics::PrintObjectsConceptualWeight(std::ostream& stream)
{
  PrintObjectsConceptualWeight(stream, ";");
}

void FCALatticeStatistics::PrintAttributesConceptualWeight(std::ostream& stream)
{
  PrintAttributesConceptualWeight(stream, ";");
}

void FCALatticeStatistics::PrintObjectsConceptualWeight(std::ostream& stream,
							std::string separator)
{
  #ifdef MYDEBUG
  stream << "Conceptual Weight of each Object : " << std::endl;
  #endif

  stream << "Objects" << separator << "Weight" << std::endl;
  for (std::vector<FCAObject*>::iterator iter = Lattice->Objects.begin();
       iter < Lattice->Objects.end();
       iter++)
    stream << (*iter)->GetNameObject() << separator <<
      this->ObjectsConceptualWeight[(*iter)->GetIDObject()] << std::endl;
}

void FCALatticeStatistics::PrintAttributesConceptualWeight(
							 std::ostream& stream,
							 std::string separator)
{
  #ifdef MYDEBUG
  stream << "Conceptual Weight of each Attribute : " << std::endl;
  #endif

  stream << "Attributes" << separator << "Weight" << std::endl;
  for (std::vector<FCAAttribute*>::iterator iter = Lattice->Attributes.begin();
       iter < Lattice->Attributes.end();
       iter++)
    stream << (*iter)->GetNameAttribute() << separator <<
      this->AttributesConceptualWeight[(*iter)->GetIDAttribute()] << std::endl;
}

// Conceptual Similarity
void FCALatticeStatistics::PrintObjObjConceptualSimilarity(std::ostream& stream)
{
  PrintObjObjConceptualSimilarity(stream, ";");
}

void FCALatticeStatistics::PrintAttAttConceptualSimilarity(std::ostream& stream)
{
  PrintAttAttConceptualSimilarity(stream, ";");
}

void FCALatticeStatistics::PrintObjObjConceptualSimilarity(std::ostream& stream,
							   std::string separator)
{
  #ifdef MYDEBUG
  stream << "Conceptual Similarity of Object and Object : " << std::endl;
  #endif

  stream << "X";
  std::vector<FCAObject*>::iterator iObject;
  for (iObject = this->Lattice->Objects.begin();
       iObject < this->Lattice->Objects.end();
       iObject++)
  {
    FCAObject *Object = (*iObject);
    stream << " " << separator << " " << Object->GetNameObject();
  }
  stream << std::endl;

  std::vector<FCAObject*>::iterator iObject1;
  for (iObject1 = this->Lattice->Objects.begin();
       iObject1 < this->Lattice->Objects.end();
       iObject1++)
  {
    FCAObject *Object1 = (*iObject1);
    int Obj1ID = Object1->GetIDObject();

    stream << Object1->GetNameObject();
    std::vector<FCAObject*>::iterator iObject2;
    for (iObject2 = this->Lattice->Objects.begin();
	 iObject2 < this->Lattice->Objects.end();
	 iObject2++)
    {
      FCAObject *Object2 = (*iObject2);
      int Obj2ID = Object2->GetIDObject();
      double value =
	this->ObjectObjectConceptualSimilarity[std::make_pair(Obj1ID, Obj2ID)];
      stream << " " << separator << " " << value;
    }
    stream << std::endl;
  }
}

void FCALatticeStatistics::PrintAttAttConceptualSimilarity(std::ostream& stream,
							   std::string separator)
{
  #ifdef MYDEBUG
  stream << "Conceptual Similarity of Attribute and Attribute : " << std::endl;
  #endif

  stream << "X";
  std::vector<FCAAttribute*>::iterator iAttribute;
  for (iAttribute = this->Lattice->Attributes.begin();
       iAttribute < this->Lattice->Attributes.end();
       iAttribute++)
  {
    FCAAttribute *Attribute = (*iAttribute);
    stream << " " << separator << " " << Attribute->GetNameAttribute();
  }
  stream << std::endl;

  std::vector<FCAAttribute*>::iterator iAttribute1;
  for (iAttribute1 = this->Lattice->Attributes.begin();
       iAttribute1 < this->Lattice->Attributes.end();
       iAttribute1++)
  {
    FCAAttribute *Attribute1 = (*iAttribute1);
    int Att1ID = Attribute1->GetIDAttribute();

    stream << Attribute1->GetNameAttribute();
    std::vector<FCAAttribute*>::iterator iAttribute2;
    for (iAttribute2 = this->Lattice->Attributes.begin();
	 iAttribute2 < this->Lattice->Attributes.end();
	 iAttribute2++)
    {
      FCAAttribute *Attribute2 = (*iAttribute2);
      int Att2ID = Attribute2->GetIDAttribute();
      double value =
	this->AttributeAttributeConceptualSimilarity[std::make_pair(Att1ID,
								    Att2ID)];
      stream << " " << separator << " " << value;
    }
    stream << std::endl;
  }
}


void FCALatticeStatistics::PrintObjAttAbsoluteImpact(std::ostream& stream)
{
  PrintObjAttAbsoluteImpact(stream, ";");
}

void FCALatticeStatistics::PrintObjAttRelativeImpact(std::ostream& stream)
{
  PrintObjAttRelativeImpact(stream, ";");
}

void FCALatticeStatistics::PrintObjAttAbsoluteImpact(std::ostream& stream,
						     std::string separator)
{
  #ifdef MYDEBUG
  stream << "Absolute Impact of Object and Attribute : " << std::endl;
  #endif

  stream << "X";
  std::vector<FCAAttribute*>::iterator iAttribute;
  for (iAttribute = this->Lattice->Attributes.begin();
       iAttribute < this->Lattice->Attributes.end();
       iAttribute++)
  {
    FCAAttribute *Attribute = (*iAttribute);
    stream << " " << separator << " " << Attribute->GetNameAttribute();
  }
  stream << std::endl;

  std::vector<FCAObject*>::iterator iObject;
  for (iObject = this->Lattice->Objects.begin();
       iObject < this->Lattice->Objects.end();
       iObject++)
  {
    FCAObject *Object = (*iObject);
    int ObjID = Object->GetIDObject();

    stream << Object->GetNameObject();
    std::vector<FCAAttribute*>::iterator iAttribute;
    for (iAttribute = this->Lattice->Attributes.begin();
	 iAttribute < this->Lattice->Attributes.end();
	 iAttribute++)
    {
      FCAAttribute *Attribute = (*iAttribute);
      int AttID = Attribute->GetIDAttribute();
      double value =
	this->ObjectAttributeAbsoluteImpact[std::make_pair(ObjID, AttID)];
      stream << " " << separator << " " << value;
    }
    stream << std::endl;
  }
}

void FCALatticeStatistics::PrintObjAttRelativeImpact(std::ostream& stream,
						     std::string separator)
{
  #ifdef MYDEBUG
  stream << "Relative Impact of Object and Attribute : " << std::endl;
  #endif

  stream << "X";
  std::vector<FCAAttribute*>::iterator iAttribute;
  for (iAttribute = this->Lattice->Attributes.begin();
       iAttribute < this->Lattice->Attributes.end();
       iAttribute++)
  {
    FCAAttribute *Attribute = (*iAttribute);
    stream << " " << separator << " " << Attribute->GetNameAttribute();
  }
  stream << std::endl;

  std::vector<FCAObject*>::iterator iObject;
  for (iObject = this->Lattice->Objects.begin();
       iObject < this->Lattice->Objects.end();
       iObject++)
  {
    FCAObject *Object = (*iObject);
    int ObjID = Object->GetIDObject();

    stream << Object->GetNameObject();
    std::vector<FCAAttribute*>::iterator iAttribute;
    for (iAttribute = this->Lattice->Attributes.begin();
	 iAttribute < this->Lattice->Attributes.end();
	 iAttribute++)
    {
      FCAAttribute *Attribute = (*iAttribute);
      int AttID = Attribute->GetIDAttribute();
      double value =
	this->ObjectAttributeRelativeImpact[std::make_pair(ObjID, AttID)];
      stream << " " << separator << " " << value;
    }
    stream << std::endl;
  }
}

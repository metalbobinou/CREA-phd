#ifndef FCACONCEPT_HH_
# define FCACONCEPT_HH_

# include <iostream>
# include <vector>
# include <climits>

# include "FCAObject.hh"
# include "FCAAttribute.hh"

// Avoid circular definitions
class FCAConcept;
# include "FCALattice.hh"

class FCAConcept
{
public :
  FCAConcept(int NewIDConcept);
  ~FCAConcept();

  void AddParent(int Parent);
  void AddObject(FCAObject *Object);
  void AddAttribute(FCAAttribute *Attribute);
  void UpdateLevel(int NewLevel);

  // Basic Getters
  int GetIDConcept();
  int GetLevel();
  int GetNbObjects();
  int GetNbAttributes();
  // Get a copy of all the objects and attributes vector
  std::vector<FCAObject*> GetAllObjects();
  std::vector<FCAAttribute*> GetAllAttributes();
  // Get information on Parents and Childs vector size
  // !!!! CAN BE OBTAINED AFTER A CALL ON GenerateCloseConceptsPtrs !!!!
  int GetNbOfParents();
  int GetNbOfChilds();
  std::vector<FCAConcept*> GetParents();
  std::vector<FCAConcept*> GetChilds();

  // Search if an object or an attribute is present in the Concept
  bool HasObject(int ObjectID);
  bool HasObject(std::string ObjectName);
  bool HasAttribute(int AttributeID);
  bool HasAttribute(std::string AttributeName);

  // Test if the current Concept is a child of the Concept in parameter
  bool HasParent(int ConceptID);

  // Generate from the ParentIDs, and the Lattice, the two vectors of pointers
  void GenerateCloseConceptsPtrs(FCALattice *Lattice);
  // Update the level of the current Concept and its child
  void UpdateAllLevels(int NewLevel);

  // Print Names of Objects contained
  void PrintObjectsNameCSV(std::ostream& stream, std::string separator);
  void PrintAttributesNameCSV(std::ostream& stream, std::string separator);
  void PrintObjectsName(std::ostream& stream);
  void PrintAttributesName(std::ostream& stream);

  // Print IDs of parents and childs
  void PrintParentsID(std::ostream& stream);
  void PrintChildsID(std::ostream& stream);

private :
  int IDConcept;
  int Level;
  std::vector<int> ParentIDs; // IDs of the parents of this Concept
  std::vector<FCAConcept*> ParentConcepts;
  std::vector<FCAConcept*> ChildConcepts;
  std::vector<FCAObject*> Objects;
  std::vector<FCAAttribute*> Attributes;

  void GenerateParentConceptsPtrs(FCALattice *Lattice);
  void GenerateChildConceptsPtrs(FCALattice *Lattice);
};

#endif /* !FCACONCEPT_HH_ */

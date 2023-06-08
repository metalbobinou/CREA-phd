#ifndef FCALATTICE_HH_
# define FCALATTICE_HH_

# include <ostream>
# include <string>
# include <vector>
# include <climits>

# include "FCAObject.hh"
# include "FCAAttribute.hh"

// Avoid circular definitions
class FCALatticeStatistics;
class FCALattice;
# include "FCAConcept.hh"

void ClearLatticeVector(std::vector<FCALattice*> Lattices);

class FCALattice
{
  friend class FCALatticeStatistics;

public :
  FCALattice();
  ~FCALattice();

  // Build Lattice
  void AddConcept(FCAConcept *NewConcept);
  void AddObject(FCAObject *NewObject);
  void AddAttribute(FCAAttribute *NewAttribute);
  void UpdateName(std::string NewLatticeName);
  void CalculateConceptsLinks(); // Recalculated each concept childs/parents

  // Get basic informations
  std::string GetLatticeName();
  FCAConcept *GetConcept(int IDConcept);
  std::vector<FCAConcept*> GetAllConcepts();
  FCAObject *GetObject(int IDObject);
  FCAObject *GetObject(std::string ObjectName);
  std::vector<FCAObject*> GetAllObjects();
  FCAAttribute *GetAttribute(int IDAttribute);
  FCAAttribute *GetAttribute(std::string AttributeName);
  std::vector<FCAAttribute*> GetAllAttributes();

  // Get useful informations for statistics
  int GetNbObjects();
  int GetNbAttributes();
  int GetNbConcepts();
  int GetNbLevel();

  // Get reference to the Concept with only Objects/Attributes (highest/lowest)
  FCAConcept *GetHighestParentRef(); // Deduce one of the 2 entrance
  int GetHighestParentID();
  FCAConcept *GetLowestChildRef(); // Deduce the other entrance
  int GetLowestChildID();

  // Print content of the Lattice
  void PrintLatticeConceptsCSV1Line(std::ostream& stream,
				    std::string MainSeparator,
				    std::string SubSeparator);
  void PrintLatticeConceptsCSV2Lines(std::ostream& stream,
				     std::string separator);
  void PrintLatticeConceptsContents(std::ostream& stream);
  void PrintLatticeConcepts(std::ostream& stream);
  void PrintLatticeObjects(std::ostream& stream);
  void PrintLatticeAttributes(std::ostream& stream);

  // Clear before deleting
  void ClearAllConcepts();
  void ClearAllObjects();
  void ClearAllAttributes();
  void ClearAll();

private :
  std::string LatticeName;
  int MaxLevel;
  std::vector<FCAConcept*> Concepts;
  std::vector<FCAObject*> Objects;
  std::vector<FCAAttribute*> Attributes;
};

#endif /* !FCALATTICE_HH_ */

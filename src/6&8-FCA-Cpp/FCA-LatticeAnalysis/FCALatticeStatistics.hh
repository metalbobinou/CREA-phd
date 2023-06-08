#ifndef FCALATTICESTATISTICS_HH_
# define FCALATTICESTATISTICS_HH_

# include <exception>
# include <stdexcept>
# include <string>
# include <utility>
# include <vector>
# include <map>

# include "FCALattice.hh"

class FCALatticeStatistics
{
public:
  FCALatticeStatistics(FCALattice *StudiedLattice);
  ~FCALatticeStatistics();

  // Get statistics
  int GetNbObjects();
  int GetNbAttributes();
  int GetNbConcepts();
  int GetNbLinks();
  int GetObjectsApparition(FCAObject *Object);
  int GetObjectsApparition(std::string ObjectName);
  int GetObjectApparition(int ObjectID);
  int GetAttributeApparition(FCAAttribute *Attribute);
  int GetAttributeApparition(std::string AttributeName);
  int GetAttributeApparition(int AttributeID);

  // Printers
  void PrintLatticeStatistics(std::ostream& stream);
  void PrintObjectsApparition(std::ostream& stream);
  void PrintAttributesApparition(std::ostream& stream);
  void PrintObjectsConceptualWeight(std::ostream& stream);
  void PrintAttributesConceptualWeight(std::ostream& stream);
  void PrintObjectsConceptualWeight(std::ostream& stream,
				    std::string separator);
  void PrintAttributesConceptualWeight(std::ostream& stream,
				       std::string separator);
  void PrintObjObjConceptualSimilarity(std::ostream& stream);
  void PrintObjObjConceptualSimilarity(std::ostream& stream,
				       std::string separator);
  void PrintAttAttConceptualSimilarity(std::ostream& stream);
  void PrintAttAttConceptualSimilarity(std::ostream& stream,
				       std::string separator);
  void PrintObjAttAbsoluteImpact(std::ostream& stream);
  void PrintObjAttAbsoluteImpact(std::ostream& stream,
				 std::string separator);
  void PrintObjAttRelativeImpact(std::ostream& stream);
  void PrintObjAttRelativeImpact(std::ostream& stream,
				 std::string separator);


private:
  FCALattice *Lattice;
  std::string LatticeName;
  FCAConcept *HighestParentRef;
  FCAConcept *LowestChildRef;
  int HighestParentID;
  int LowestChildID;
  int NbObjects;
  int NbAttributes;
  int NbConcepts;
  int NbLinks;
  int NbLevels;
  double AvgNbObjects;
  double AvgNbAttributes;
  double AvgNbParents;
  double AvgNbChilds;
  double AvgSizConcepts;
  std::map<int, int> ObjectsApparition;
  std::map<int, int> AttributesApparition;
  std::map<int, double> ObjectsConceptualWeight;
  std::map<int, double> AttributesConceptualWeight;
  std::map<std::pair<int, int>, double> ObjectObjectConceptualSimilarity;
  std::map<std::pair<int, int>, double> AttributeAttributeConceptualSimilarity;
  std::map<std::pair<int, int>, double> ObjectAttributeAbsoluteImpact;
  std::map<std::pair<int, int>, double> ObjectAttributeRelativeImpact;

  // Build statistics (called by constructor)
  void BuildBasicStatistics(); // Get basic infos from the Lattice
  void BuildNbLinks(); // Calculate the number of links between concepts
  void BuildAverages(); // Build multiple averages

  // Calculate in how many concepts the objects/attributes appear
  void BuildNbObjectApparition(); // Calculate ALL the objects
  void BuildNbAttributeApparition(); // Calculate ALL the attributes

  // Calculate the Conceptual Weight of Objects and Attributes
  // Number of Concepts that contains the Object/Attribute divided by the
  //  total number of Concepts
  // !! Require "apparition" to be calculated !!
  void BuildObjectsConceptualWeight();
  void BuildAttributesConceptualWeight();

  // Calculate the Conceptual Similarity of 2 Objects / Attributes
  // Number of Concepts that contain O/A 1 AND O/A 2 divided by the number of
  //  Concepts that contain O/A 1 OR O/A 2
  void BuildObjObjConceptualSimilarity();
  void BuildAttAttConceptualSimilarity();

  // Calculate the Relative and Absolute Impacts of 1 Object and 1 Attribute
  // Relative Impact : Number of Concepts that contain the O AND A divided by
  //  the number of Concepts that contain the O OR A
  // Absolute Impact : Number of Concepts that contain the O AND A divided by
  //  the total number of Concepts
  void BuildObjAttImpacts();

  // Building of metrics for each object/attribute...
  void BuildNbObjectApparition(FCAObject *Object);
  void BuildNbAttributeApparition(FCAAttribute *Attribute);
  void BuildObjectsConceptualWeight(FCAObject *Object);
  void BuildAttributesConceptualWeight(FCAAttribute *Attribute);
  void BuildObjObjConceptualSimilarity(FCAObject *Obj1, FCAObject *Obj2);
  void BuildAttAttConceptualSimilarity(FCAAttribute *Att1, FCAAttribute *Att2);
  void BuildObjAttImpacts(FCAObject *Obj, FCAAttribute *Att);
};

#endif /* !FCALATTICESTATISTICS_HH_ */

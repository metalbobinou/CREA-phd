#ifndef FORMALCONTEXT_HH_
# define FORMALCONTEXT_HH_

# include <iostream>
# include <string>
# include <vector>

# include "Dirs.hh"
# include "Files.hh"
# include "ParseCSV.hh"

// Avoid circular references
class FormalContext;

#ifdef MYDEBUG
  # include "MyDebugs.hh"
#endif

# define READFORMALCONCEPT_BUFFER 1024

// A function to open a CSV file and get a FormalContext instance from it
FormalContext *GetFormalContext(std::string InputFileName);

// Definition of the class FormalContext
class FormalContext
{
  friend class FormalContextStrategies;

public:
  FormalContext();
  FormalContext(FILE *file);
  FormalContext(FormalContext *FC);
  ~FormalContext();

  // Simple getters
  int GetNbObjects();
  int GetNbAttributes();
  std::vector<std::string> GetObjects();
  std::vector<std::string> GetAttributes();
  std::vector<std::vector<int> > GetMatrix();

  // Import a FormalContext from a CSV
  void ImportFormalContextFromCSV(FILE *file);

  // Delete useless lines and columns (lines and columns full of 0)
  void DeleteRowsColumnsAt0();

  // Replace the matrix with its transposed
  void TransposeMatrix();

  // Copy the FormalContext
  FormalContext *CopyFormalContext();

  // Print the FormalContext to the console
  void PrintFormalContext();
  void PrettyPrintFormalContext();

  // Export the FormalContext into various formats
  void WriteFormalContextSLF(FILE *file);
  void WriteFormalContextTXT(FILE *file);
  void WriteFormalContextCSV(FILE *file);

private:
  int NbObjects;
  int NbAttributes;
  std::vector<std::string> Objects;
  std::vector<std::string> Attributes;
  std::vector<std::vector<int> > Matrix;

  // Read the CSV file and create a first structure with a matrix of string
  static void ImportCSVFile(FILE *file, struct csv_struct *csv_struct);
  // Copy the CSV content (std::string) into the FormalContext structure (int)
  void CopyCSVToMatrix(struct csv_struct *csv_struct);

  // Delete a row or a column in the Matrix
  void DeleteRow(unsigned int Row);
  void DeleteColumn(unsigned int Column);
  void DeleteLinesAt0();
  void DeleteColumnsAt0();
};

#endif /* !FORMALCONTEXT_HH_ */

#ifndef FORMALCONTEXTSTRATEGIES_HH_
# define FORMALCONTEXTSTRATEGIES_HH_

# include <stdlib.h>
# include <stdio.h>
# include <string.h>
# include <math.h>

# include <iostream>
# include <exception>
# include <stdexcept>
# include <string>
# include <utility>

// Avoid circular references
class FormalContextStrategies;

# include "FormalContext.hh"

#ifdef MYDEBUG
  # include "MyDebugs.hh"
#endif

class FormalContextStrategies
{
public:
  FormalContextStrategies(FormalContext *StudiedFC);
  ~FormalContextStrategies();

  // Getters
  FormalContext *GetOriginalFormalContext();
  FormalContext *GetStrategyFormalContext();

  // Reload the Strategy Formal Context from the Original one
  void ReloadFormalContext();

  // Printer for the Formal Context Strategy
  void PrintFormalContext();
  void PrettyPrintFormalContext();

  // Write the Strategy Formal Context to files
  void WriteFormalContextSLF(FILE *file);
  void WriteFormalContextTXT(FILE *file);
  void WriteFormalContextCSV(FILE *file);

  // Delete the lines and columns full of 0 in the Strategy Formal Context
  void DeleteRowsColumnsAt0();

  // Replace the Formal Context Strategy matrix with its transposed
  void TransposeMatrix();

  // Normalize the lines proportions (if a line has thousand, and another has
  //  hundreds, and a last one has units... it might alter results...)
  //  Let's put a proportion per Object or per Attribute
  void NormalizePerObjects(); // Normalize per line
  void NormalizePerAttributes(); // Normalize per column

  //////////////// SIMPLE STRATEGIES ////////////////
  void FillWithNumber(int n); // Fill the matrix with the value N
  void SimpleBinarize(); // Binarize : 0 stays 0, non-0 become 1
  void SimpleReverse(); // Reverse : 0 become 1, non-0 become 0

  //////////////// COMPLEX STRATEGIES ////////////////
  // Beta based strategies : B separates in 3 slices by growing the middle one
  // Beta 0 : 2 slices (hi/lo, mid at 0) ; Beta 1 : 1 slice (mid, hi/lo out)
  void StrongRelationsNoOnto(double Beta); // Put 1 for values in higher slice
  void MediumRelationsNoOnto(double Beta); // Put 1 for values in middle slice
  void WeakRelationsNoOnto(double Beta); // Put 1 for values in lower slice

private:
  /* Original Formal Context */
  FormalContext *OriginalFC;

  /* Formal Context modified by strategies */
  FormalContext *StrategyFC;
};

#endif /* !FORMALCONTEXTSTRATEGIES_HH_ */

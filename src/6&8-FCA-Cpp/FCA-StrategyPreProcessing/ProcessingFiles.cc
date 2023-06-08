#include "ProcessingFiles.hh"

static void StrategyReload(FormalContextStrategies *FCS)
{
  // Reload "at least" the matrix
  FCS->ReloadFormalContext();

  /* Let's make other modifications */

  // Transpose
  FCS->TransposeMatrix();

  // Normalizations
  //FCS->NormalizePerObjects(); // Per lines/objects
  FCS->NormalizePerAttributes(); // Per columns/attributes
}

// Write the calculted Formal Context into 3 files (function adds extension)
void WriteStrategyToFiles(std::string OutputFileName,
			  std::string OutputDirectory,
			  FormalContextStrategies *FCS)
{
  std::string OutNameSLF, OutNameTXT, OutNameCSV;
  std::string TmpNameSLF, TmpNameTXT, TmpNameCSV;
  FILE *OutFileSLF, *OutFileTXT, *OutFileCSV;

  TmpNameSLF = OutputFileName + ".slf";
  TmpNameTXT = OutputFileName + ".txt";
  TmpNameCSV = OutputFileName + ".csv";

  OutNameSLF = BuildPath(OutputDirectory, TmpNameSLF);
  OutNameTXT = BuildPath(OutputDirectory, TmpNameTXT);
  OutNameCSV = BuildPath(OutputDirectory, TmpNameCSV);

  OutFileSLF = fopen(OutNameSLF.c_str(), "w");
  OutFileTXT = fopen(OutNameTXT.c_str(), "w");
  OutFileCSV = fopen(OutNameCSV.c_str(), "w");

  FCS->WriteFormalContextSLF(OutFileSLF);
  FCS->WriteFormalContextTXT(OutFileTXT);
  FCS->WriteFormalContextCSV(OutFileCSV);

  fclose(OutFileSLF);
  fclose(OutFileTXT);
  fclose(OutFileCSV);
}

static void ProcessBetaStrategies(std::string InputBaseName,
				  std::string OutputDirectory,
				  FormalContextStrategies *FCS,
				  double BetaStep,
				  double BetaMax)
{
  double Beta = 0;
  std::string B;

  while (Beta < BetaMax)
  {
    std::string OutFileNoOntoHigh, OutFileNoOntoMid, OutFileNoOntoLow;

    B = double_to_string(Beta, 2);
   #ifdef MYDEBUG
    printf("Process Beta (%s) : %f\n", B.c_str(), Beta);
   #endif

    StrategyReload(FCS);
    OutFileNoOntoHigh = InputBaseName + "-O=N-S=H-B=" + B;
    FCS->StrongRelationsNoOnto(Beta); // Relations in the up third are kept
    FCS->DeleteRowsColumnsAt0();
    WriteStrategyToFiles(OutFileNoOntoHigh, OutputDirectory, FCS);

    StrategyReload(FCS);
    OutFileNoOntoMid = InputBaseName + "-O=N-S=M-B=" + B;
    FCS->MediumRelationsNoOnto(Beta); // Relations in the middle third are kept
    FCS->DeleteRowsColumnsAt0();
    WriteStrategyToFiles(OutFileNoOntoMid, OutputDirectory, FCS);

    StrategyReload(FCS);
    OutFileNoOntoLow = InputBaseName + "-O=N-S=B-B=" + B;
    FCS->WeakRelationsNoOnto(Beta); // Relations in the low third are kept
    FCS->DeleteRowsColumnsAt0();
    WriteStrategyToFiles(OutFileNoOntoLow, OutputDirectory, FCS);

    Beta = Beta + BetaStep;
  }

  FCS->ReloadFormalContext();
}

static void ProcessSimpleStrategies(std::string InputBaseName,
				    std::string OutputDirectory,
				    FormalContextStrategies *FCS)
{
  std::string OutFileDirectNoFreq, OutFileNullRelations;

  StrategyReload(FCS);
  OutFileDirectNoFreq = InputBaseName + "-Directe"; // Binarization
  FCS->SimpleBinarize();
  FCS->DeleteRowsColumnsAt0();
  WriteStrategyToFiles(OutFileDirectNoFreq, OutputDirectory, FCS);

  StrategyReload(FCS);
  OutFileNullRelations = InputBaseName + "-Inverse"; // Reverse
  FCS->SimpleReverse();
  FCS->DeleteRowsColumnsAt0();
  WriteStrategyToFiles(OutFileNullRelations, OutputDirectory, FCS);
}

static void ProcessingOutFile(std::string InputFileName,
			      std::string OutputDirectory,
			      FormalContextStrategies *FCS)
{
  std::string InputBaseName = my_basename(InputFileName);

  // Process Simple Strategies : binarization and reverse
  ProcessSimpleStrategies(InputBaseName, OutputDirectory, FCS);

  // Process Strategies High, Mid, Low with Beta up to 1.25 with a +0.25 each
  ProcessBetaStrategies(InputBaseName, OutputDirectory, FCS, 0.25, 1.25);
}

void ProcessingFiles(char **InputFiles, const char *OutputDirectory)
{
  CreateSubPath(OutputDirectory);
  for (int IterFile = 0; InputFiles[IterFile] != NULL; IterFile++)
  {
    std::string InputFileName = std::string(InputFiles[IterFile]);
    FormalContextStrategies *FCS;
    FormalContext *FC;

    FC = GetFormalContext(InputFileName);

   #ifdef MYDEBUG
    //FC->DeleteRowsColumnsAt0();
    FC->PrettyPrintFormalContext();
   #endif

    FCS = new FormalContextStrategies(FC);

    if ((FC != NULL) && (FCS != NULL))
    {
      ProcessingOutFile(InputFileName, std::string(OutputDirectory), FCS);
    }
    else
    {
      std::cerr << "Error: Studied Formal Context or Strategies is/are NULL" <<
	std::endl;
    }

    delete (FCS);
    delete (FC);
  }
}

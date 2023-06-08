#include "FormalContextStrategies.hh"

FormalContextStrategies::FormalContextStrategies(FormalContext *StudiedFC)
{
  if (StudiedFC == NULL)
    throw std::runtime_error("Formal Concept cannot be NULL");

  this->OriginalFC = StudiedFC;
  this->StrategyFC = StudiedFC->CopyFormalContext();
}

FormalContextStrategies::~FormalContextStrategies()
{
  delete (this->StrategyFC);
}

// Simple Getters
FormalContext *FormalContextStrategies::GetOriginalFormalContext()
{
  return (this->OriginalFC);
}

FormalContext *FormalContextStrategies::GetStrategyFormalContext()
{
  return (this->StrategyFC);
}

// Renew the Strategy Formal Context
void FormalContextStrategies::ReloadFormalContext()
{
  delete (this->StrategyFC);
  this->StrategyFC = this->OriginalFC->CopyFormalContext();
}

// Printers
void FormalContextStrategies::PrintFormalContext()
{
  this->StrategyFC->PrintFormalContext();
}

void FormalContextStrategies::PrettyPrintFormalContext()
{
  this->StrategyFC->PrettyPrintFormalContext();
}

// Writes Strategy Formal Context into files
void FormalContextStrategies::WriteFormalContextSLF(FILE *file)
{
  this->StrategyFC->WriteFormalContextSLF(file);
}

void FormalContextStrategies::WriteFormalContextTXT(FILE *file)
{
  this->StrategyFC->WriteFormalContextTXT(file);
}

void FormalContextStrategies::WriteFormalContextCSV(FILE *file)
{
  this->StrategyFC->WriteFormalContextCSV(file);
}

/*****************************************************************************/
/********************************** DELETER **********************************/
/*****************************************************************************/

// Delete the lines and columns full of 0 in the StrategyFC
void FormalContextStrategies::DeleteRowsColumnsAt0()
{
  this->StrategyFC->DeleteRowsColumnsAt0();
}

/*****************************************************************************/
/********************************* TRANSPOSE *********************************/
/*****************************************************************************/

// Transpose the FCS matrix
void FormalContextStrategies::TransposeMatrix()
{
  this->StrategyFC->TransposeMatrix();
}

/*****************************************************************************/
/******************************* NORMALIZATION *******************************/
/*****************************************************************************/

// Normalize per line (objects)
void FormalContextStrategies::NormalizePerObjects()
{
  for (int obj = 0; obj < this->StrategyFC->NbObjects; obj++)
  {
    int total = 0;
    for (int att = 0; att < this->StrategyFC->NbAttributes; att++)
      total += (this->StrategyFC->Matrix[obj][att]);

    if (total == 0)
      continue ;

    for (int att = 0; att < this->StrategyFC->NbAttributes; att++)
    {
      int CurAtt = this->StrategyFC->Matrix[obj][att];
      double Value = (double) (CurAtt * 100) / ((double) total);
      this->StrategyFC->Matrix[obj][att] = ceil(Value); // ceil or floor
    }
  }
}

// Normalize per column (attributes)
void FormalContextStrategies::NormalizePerAttributes()
{
  for (int att = 0; att < this->StrategyFC->NbAttributes; att++)
  {
    int total = 0;
    for (int obj = 0; obj < this->StrategyFC->NbObjects; obj++)
      total += (this->StrategyFC->Matrix[obj][att]);

    if (total == 0)
      continue ;

    for (int obj = 0; obj < this->StrategyFC->NbObjects; obj++)
    {
      int CurAtt = this->StrategyFC->Matrix[obj][att];
      double Value = (double) (CurAtt * 100) / ((double) total);
      this->StrategyFC->Matrix[obj][att] = ceil(Value); // ceil or floor
    }
  }
}

/*****************************************************************************/
/***************************** SIMPLE STRATEGIES *****************************/
/*****************************************************************************/

// Fill the whole matrix with the same value given in parameter
void FormalContextStrategies::FillWithNumber(int n)
{
  for (int i = 0; i < this->StrategyFC->NbObjects; i++)
    for (int j = 0; j < this->StrategyFC->NbAttributes; j++)
      this->StrategyFC->Matrix[i][j] = n;
}

// Binarize : 0 stays 0, non-0 become 1
void FormalContextStrategies::SimpleBinarize()
{
  for (int i = 0; i < this->StrategyFC->NbObjects; i++)
    for (int j = 0; j < this->StrategyFC->NbAttributes; j++)
      if (this->StrategyFC->Matrix[i][j] == 0)
	this->StrategyFC->Matrix[i][j] = 0;
      else
	this->StrategyFC->Matrix[i][j] = 1;
}

// Reverse : 0 become 1, non-0 become 0
void FormalContextStrategies::SimpleReverse()
{
  for (int i = 0; i < this->StrategyFC->NbObjects; i++)
    for (int j = 0; j < this->StrategyFC->NbAttributes; j++)
      if (this->StrategyFC->Matrix[i][j] == 0)
	this->StrategyFC->Matrix[i][j] = 1;
      else
	this->StrategyFC->Matrix[i][j] = 0;
}

/*****************************************************************************/
/***************************** COMPLEX STRATEGIES ****************************/
/*****************************************************************************/

// Keep the value in the higher slice (beta separates in 3 slices)
void FormalContextStrategies::StrongRelationsNoOnto(double Beta)
{
  double Moyenne = 0;
  double EcartType = 0;
  double SeuilHaut;
  double *Diff;
  int T;

  Diff = new double[this->StrategyFC->NbAttributes];
  for (int i = 0; i < this->StrategyFC->NbObjects; i++)
  {
    T = 0;
    for (int j = 0; j < this->StrategyFC->NbAttributes; j++)
    {
      if (this->StrategyFC->Matrix[i][j] != 0)
      {
	T++;
	Moyenne = Moyenne + this->StrategyFC->Matrix[i][j];
      }
    }
    if (T != 0)
      Moyenne = Moyenne / T;

    for (int j = 0; j < this->StrategyFC->NbAttributes; j++)
    {
      if (this->StrategyFC->Matrix[i][j] != 0)
      {
	Diff[j] = pow(this->StrategyFC->Matrix[i][j] - Moyenne, 2);
	EcartType = EcartType + Diff[j];
      }
    }
    if (T != 0)
      EcartType = sqrt(EcartType / T);

    SeuilHaut = Moyenne + (Beta * EcartType);

    for (int j = 0; j < this->StrategyFC->NbAttributes; j++)
    {
      if (this->StrategyFC->Matrix[i][j] > SeuilHaut)
	this->StrategyFC->Matrix[i][j] = 1;
      else
	this->StrategyFC->Matrix[i][j] = 0;
    }
    EcartType = 0;
    Moyenne = 0;
  }
  delete[] Diff;
}

// Keep the value in the lower slice (beta separates in 3 slices)
void FormalContextStrategies::WeakRelationsNoOnto(double Beta)
{
  double Moyenne = 0;
  double EcartType = 0;
  double SeuilBas;
  double *Diff;
  int T;

  Diff = new double[this->StrategyFC->NbAttributes];
  for (int i = 0; i < this->StrategyFC->NbObjects; i++)
  {
    T = 0;
    for (int j = 0; j < this->StrategyFC->NbAttributes; j++)
    {
      if (this->StrategyFC->Matrix[i][j] != 0)
      {
	T++;
	Moyenne = Moyenne + this->StrategyFC->Matrix[i][j];
      }
    }
    if (T != 0)
      Moyenne = Moyenne / T;

    for (int j = 0; j < this->StrategyFC->NbAttributes; j++)
    {
      if (this->StrategyFC->Matrix[i][j] != 0)
      {
	Diff[j] = pow(this->StrategyFC->Matrix[i][j] - Moyenne, 2);
	EcartType = EcartType + Diff[j];
      }
    }
    if (T != 0)
      EcartType = sqrt(EcartType / T);
    SeuilBas = Moyenne - (Beta * EcartType);
    if (SeuilBas < 0)
      SeuilBas = 0;

    for (int j = 0; j < this->StrategyFC->NbAttributes; j++)
    {
      if ((0 < this->StrategyFC->Matrix[i][j]) &&
	  (this->StrategyFC->Matrix[i][j] < SeuilBas))
	this->StrategyFC->Matrix[i][j] = 1;
      else
	this->StrategyFC->Matrix[i][j] = 0;
    }
    EcartType = 0;
    Moyenne = 0;
  }
  delete[] Diff;
}

// Keep the value in the middle slice (beta separates in 3 slices)
void FormalContextStrategies::MediumRelationsNoOnto(double Beta)
{
  double Moyenne = 0;
  double EcartType = 0;
  double SeuilBas;
  double SeuilHaut;
  double *Diff;
  int T;

  Diff = new double[this->StrategyFC->NbAttributes];
  for (int i = 0; i < this->StrategyFC->NbObjects; i++)
  {
    T = 0;
    for (int j = 0; j < this->StrategyFC->NbAttributes; j++)
    {
      if (this->StrategyFC->Matrix[i][j] != 0)
      {
	T++;
	Moyenne = Moyenne + this->StrategyFC->Matrix[i][j];
      }
    }
    if (T != 0)
      Moyenne = Moyenne / T;

    for (int j = 0; j < this->StrategyFC->NbAttributes; j++)
    {
      if (this->StrategyFC->Matrix[i][j] != 0)
      {
	Diff[j] = pow(this->StrategyFC->Matrix[i][j] - Moyenne, 2);
	EcartType = EcartType + Diff[j];
      }
    }
    if (T != 0)
      EcartType = sqrt(EcartType / T);
    SeuilBas = Moyenne - (Beta * EcartType);
    SeuilHaut = Moyenne + (Beta * EcartType);
    if (SeuilBas < 0)
      SeuilBas = 0;

    for (int j = 0; j < this->StrategyFC->NbAttributes; j++)
    {
      if ((0 < this->StrategyFC->Matrix[i][j]) &&
	  (SeuilBas <= this->StrategyFC->Matrix[i][j]) &&
	  (this->StrategyFC->Matrix[i][j] <= SeuilHaut))
	this->StrategyFC->Matrix[i][j] = 1;
      else
	this->StrategyFC->Matrix[i][j] = 0;
    }
    EcartType = 0;
    Moyenne = 0;
  }
  delete[] Diff;
}

#include "FormalContext.hh"

// Read the Formal Concept from a CSV file
FormalContext *GetFormalContext(std::string InputFileName)
{
  FILE *InFile = NULL;

 #ifdef MYDEBUG
  std::cout << InputFileName << std::endl;
 #endif

  InFile = fopen(InputFileName.c_str(), "r");
  if (InFile == NULL)
    {
      std::cerr << "Impossible d'ouvrir le fichier " << InputFileName <<
	std::endl;
      return (NULL);
    }

  FormalContext *FC = new FormalContext(InFile);

  fclose(InFile);
  return (FC);
}

/*****************************************************************************/
/*********************************** CLASS ***********************************/
/*****************************************************************************/

FormalContext::FormalContext()
{
  this->NbObjects = 0;
  this->NbAttributes = 0;
}

FormalContext::FormalContext(FILE *file)
{
  this->NbObjects = 0;
  this->NbAttributes = 0;
  this->ImportFormalContextFromCSV(file);
}

FormalContext::FormalContext(FormalContext *FC)
{
  this->NbObjects = FC->GetNbObjects();
  this->NbAttributes = FC->GetNbAttributes();
  this->Objects = std::vector<std::string>(FC->GetObjects());
  this->Attributes = std::vector<std::string>(FC->GetAttributes());
  this->Matrix = std::vector<std::vector<int> >(FC->GetMatrix());
}

FormalContext::~FormalContext()
{
}

// Simple getters
int FormalContext::GetNbObjects()
{
  return (this->NbObjects);
}

int FormalContext::GetNbAttributes()
{
  return (this->NbAttributes);
}

std::vector<std::string> FormalContext::GetObjects()
{
  return (this->Objects);
}

std::vector<std::string> FormalContext::GetAttributes()
{
  return (this->Attributes);
}

std::vector<std::vector<int> > FormalContext::GetMatrix()
{
  return (this->Matrix);
}


/*****************************************************************************/
/*********************************** READER **********************************/
/*****************************************************************************/

// Read the CSV file and create a first structure with a matrix of std::string
void FormalContext::ImportCSVFile(FILE *file, struct csv_struct *csv_struct)
{
  struct csv_parser parser;
  char buf[READFORMALCONCEPT_BUFFER];
  size_t buf_i;

  csv_init(&parser, 0);
  init_csv_struct(csv_struct);
  csv_set_delim(&parser, ';'); // Au cas ou ca n'est pas ,
 #ifdef MYDEBUG
  printf("-- Init OK\n");
 #endif
  while ((buf_i = fread(buf, 1, sizeof(buf), file)) > 0)
  {
   #ifdef MYDEBUG
    printf("- Read\n");
   #endif
    if (csv_parse(&parser, buf, buf_i,
		  csv_column, csv_line, csv_struct) != buf_i)
    {
      fprintf(stderr, "Error parsing file at [%d][%d] : %s\n",
	      csv_struct->fields,
	      csv_struct->rows,
	      csv_strerror(csv_error(&parser)));
    }
  }
 #ifdef MYDEBUG
  printf("-- Parse OK\n");
 #endif
  //csv_fini(&parser, csv_column, csv_line, OtherF);
  csv_free(&parser);
}

// Copy the CSV content (std::string) into the FormalContext structure (int)
void FormalContext::CopyCSVToMatrix(struct csv_struct *csv_struct)
{
  int lines, cols;
  int NbObj = 0, NbAtt = 0;

  // Copy Attributes
  cols = 0;
  for (std::vector<std::string>::iterator cols_it = csv_struct->CSV[0].begin();
       cols_it != csv_struct->CSV[0].end();
       ++cols_it)
  {
    if (cols == 0) // Do not copy the first column (it is useless : X)
    {
      cols++;
      continue ;
    }
    std::string str = std::string (*cols_it);
    this->Attributes.push_back(str);
    NbAtt++;
  }
  this->NbAttributes = NbAtt;

  // Copy Objects
  lines = 0; // Avoid first line
  for (std::vector<std::vector<std::string> >::iterator lines_it =
	 csv_struct->CSV.begin();
       lines_it != csv_struct->CSV.end();
       ++lines_it)
  {
    if (lines == 0) // Do not copy the first line (it is useless : X, attr)
    {
      lines++;
      continue ;
    }

    cols = 0;
    this->Matrix.push_back(std::vector<int>()); // Insert new line
    for (std::vector<std::string>::iterator cols_it = lines_it->begin();
	 cols_it != lines_it->end();
	 ++cols_it)
    {
      std::string str = std::string (*cols_it);
      char *ptr = NULL;

      if (cols == 0) 	// Copy the first column / name to Objects array
	this->Objects.push_back(str);
      else
	this->Matrix[lines - 1].push_back(strtol(str.c_str(), &ptr, 10));
	//this->Matrix[lines][cols - 1] = strtol(str.c_str(), &ptr, 10);
      cols++;
    }
    lines++;
    NbObj++;
  }
  this->NbObjects = NbObj;
}

// Import a Formal Context from a CSV
void FormalContext::ImportFormalContextFromCSV(FILE *file)
{
  struct csv_struct csv_struct;

  //csv_struct = (struct csv_struct*) malloc(sizeof (csv_struct));
  ImportCSVFile(file, &csv_struct);

 #ifdef MYDEBUG
  // Print in case of debug
  printf("-- Reading OK\n");
  PrintVectorVectorString(csv_struct.CSV);
 #endif

  this->CopyCSVToMatrix(&csv_struct);

 #ifdef MYDEBUG
  printf("-- Formal Context OK\n");
  this->PrintFormalContext();
 #endif

  clear_csv_struct(&csv_struct); // Clear the std::vector
  //free(csv_struct);
}

/*****************************************************************************/
/********************************** DELETERS *********************************/
/*****************************************************************************/

void FormalContext::DeleteRow(unsigned int Row)
{
  if (this->Matrix.size() > Row)
  {
    this->Matrix.erase(this->Matrix.begin() + Row);
    this->Objects.erase(this->Objects.begin() + Row);
    this->NbObjects--;
  }
}

void FormalContext::DeleteColumn(unsigned int Column)
{
  for (unsigned int i = 0; i < this->Matrix.size(); ++i)
  {
    if (Matrix[i].size() > Column)
    {
      this->Matrix[i].erase(this->Matrix[i].begin() + Column);
    }
  }
  this->Attributes.erase(this->Attributes.begin() + Column);
  this->NbAttributes--;
}

void FormalContext::DeleteLinesAt0()
{
  for (int line = 0; line < this->NbObjects; line++)
  {
    int col = 0;
    for (col = 0; col < this->NbAttributes; col++)
      if (this->Matrix[line][col] != 0)
	break ;

    if (col == this->NbAttributes)
    {
      this->DeleteRow(line);
      line--;
    }
  }
}

void FormalContext::DeleteColumnsAt0()
{
  for (int col = 0; col < this->NbAttributes; col++)
  {
    int line = 0;
    for (line = 0; line < this->NbObjects; line++)
      if (this->Matrix[line][col] != 0)
	break ;

    if (line == this->NbObjects)
    {
      this->DeleteColumn(col);
      col--;
    }
  }
}

void FormalContext::DeleteRowsColumnsAt0()
{
  this->DeleteLinesAt0();
  this->DeleteColumnsAt0();
}

/*****************************************************************************/
/******************************** TRANSPOSE **********************************/
/*****************************************************************************/

void FormalContext::TransposeMatrix()
{
  if (this->Matrix.size() != 0)
  {
    // Transpose Matrix
    std::vector<std::vector<int> > Transpose
      (this->Matrix[0].size(), std::vector<int>());

    for (unsigned int i = 0; i < this->Matrix.size(); i++)
      for (unsigned int j = 0; j < this->Matrix[0].size(); j++)
	Transpose[j].push_back(this->Matrix[i][j]);

    this->Matrix = Transpose;

    // Transpose Objects and Attributes
    std::vector<std::string> TmpVect = this->Objects;
    this->Objects = this->Attributes;
    this->Attributes = TmpVect;
    int TmpInt = NbObjects;
    this->NbObjects = this->NbAttributes;
    this->NbAttributes = TmpInt;
  }
}

/*****************************************************************************/
/*********************************** COPY ************************************/
/*****************************************************************************/

// Copy the FormalContext
FormalContext *FormalContext::CopyFormalContext()
{
  FormalContext *NewFC = new FormalContext(this);

  return (NewFC);
}

/*****************************************************************************/
/*********************************** PRINTERS ********************************/
/*****************************************************************************/

void FormalContext::PrintFormalContext()
{
  printf("Objects from Formal Context :\n");
  for(int i = 0; i < this->NbObjects; i++)
    printf("%s \n", this->Objects[i].c_str());

  printf("Attributes from Formal Context :\n");
  for(int i = 0; i < this->NbAttributes; i++)
    printf("%s \n", this->Attributes[i].c_str());

  printf("Matrix from Formal Context :\n");
  for(int obj = 0; obj < this->NbObjects; obj++)
  {
    for(int att = 0; att < this->NbAttributes; att++)
      printf("%d  ", this->Matrix[obj][att]);
    printf("\n");
  }
}

void FormalContext::PrettyPrintFormalContext()
{
  printf("Pretty Matrix from Formal Context :\n");

  for(int att = 0; att < this->NbAttributes; att++)
    printf(" %s ", this->Attributes[att].c_str());
  printf("\n");
  for(int obj = 0; obj < this->NbObjects; obj++)
  {
    printf("%s ", this->Objects[obj].c_str());
    for(int att = 0; att < this->NbAttributes; att++)
      printf("%d  ", this->Matrix[obj][att]);
    printf("\n");
  }
}

/*****************************************************************************/
/*********************************** WRITERS *********************************/
/*****************************************************************************/

// SLF format:
/*
[Lattice]
4
4
[Objects]
Gmail
Telephone
VDM
Youtube
[Attributes]
University
Home
3G
Morning
[relation]
1 0 1 0
0 0 1 0
0 0 1 0
0 1 1 1
*/
void FormalContext::WriteFormalContextSLF(FILE *file) //slf
{
  int i, j;

  fprintf(file, "[Lattice]\n");
  fprintf(file, "%d\n", this->NbObjects);
  fprintf(file, "%d\n", this->NbAttributes);

  fprintf(file, "[Objects]\n");
  for (i = 0; i < this->NbObjects; i++)
    fprintf(file, "%s\n", this->Objects[i].c_str());

  fprintf(file, "[Attributes]\n");
  for (i = 0; i < this->NbAttributes; i++)
    fprintf(file, "%s\n", this->Attributes[i].c_str());

  fprintf(file, "[relation]\n");
  for (i = 0; i < this->NbObjects; i++)
  {
    for (j = 0; j < this->NbAttributes; j++)
      fprintf(file, "%d ", this->Matrix[i][j]);
    fprintf(file, "\n");
  }
}


// TXT format:
/*
B

6
11

Youtube
SMS
Telephone
Flappy Bird
VDM
Gmail
university
restaurant
parents_home
home
transportation
_3G
morning
coffee_break
lunch_break
afternoon
evening
XXX.X..XXXX
.XXX..XXX.X
XXX...XXX.X
.XX...XXXXX
XXX....XXX.
.XXX...XX.X
*/
void FormalContext::WriteFormalContextTXT(FILE *file) // txt
{
  int i, j;

  fprintf(file, "B\n\n");
  fprintf(file, "%d\n", this->NbObjects);
  fprintf(file, "%d\n", this->NbAttributes);
  fprintf(file, "\n");

  for (i = 0; i < this->NbObjects; i++)
    fprintf(file, "%s\n", this->Objects[i].c_str());

  for (i = 0; i < this->NbAttributes; i++)
    fprintf(file, "%s\n", this->Attributes[i].c_str());

  for (i = 0; i < this->NbObjects; i++)
  {
    for (j = 0; j < this->NbAttributes; j++)
    {
      if ((this->Matrix[i][j]) == 1)
	fprintf(file, "X");
      else
	fprintf(file, ".");
    }
    fprintf(file, "\n");
  }
}

// CSV format:
/*
X;Att1;Att3;Att4;
Obj1;0; 1; 0;
Obj2;1; 0; 1;
Obj4;1; 1; 1;
*/
void FormalContext::WriteFormalContextCSV(FILE *file) // csv
{
  int i, j;

  //fprintf(file, "X;"); // First corner

  for (i = 0; i < this->NbAttributes; i++)
    fprintf(file, ";%s", this->Attributes[i].c_str());
  fprintf(file, "\n");

  for (i = 0; i < this->NbObjects; i++)
  {
    fprintf(file, "%s;", this->Objects[i].c_str());

    for (j = 0; j < this->NbAttributes; j++)
      fprintf(file, "%d; ", this->Matrix[i][j]);
    fprintf(file, "\n");
  }
}

#include "MyDebugs.hh"

void PrintVectorVectorString(std::vector<std::vector<std::string> > matrix)
{
  int line_i = 0;
  for (std::vector<std::vector<std::string> >::iterator line = matrix.begin();
       line != matrix.end();
       ++line)
  {
    int col_i = 0;
    printf("[%d] ", line_i);
    for (std::vector<std::string>::iterator col = line->begin();
	 col != line->end();
	 ++col)
    {
      printf("[%d] %s ; ", col_i, col->c_str());
      col_i++;
    }
    printf("\n");
    line_i++;
  }
}

void TestMultipleTranslations(FormalContextStrategies *FCS)
{
 std::cout << "Initial Matrix : " << std::endl;
 FCS->PrettyPrintFormalContext();

 std::cout << std::endl << "Cleaned of 0 : " << std::endl;
 FCS->DeleteRowsColumnsAt0();
 FCS->PrettyPrintFormalContext();

 FCS->ReloadFormalContext();
 std::cout << std::endl << "Transposed : " << std::endl;
 FCS->TransposeMatrix();
 FCS->PrettyPrintFormalContext();

 FCS->ReloadFormalContext();
 std::cout << std::endl << "Normalized By Objects : " << std::endl;
 FCS->NormalizePerObjects();
 FCS->PrettyPrintFormalContext();

 FCS->ReloadFormalContext();
 std::cout << std::endl << "Normalized By Attributes : " << std::endl;
 FCS->NormalizePerAttributes();
 FCS->PrettyPrintFormalContext();
}

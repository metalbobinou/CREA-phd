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

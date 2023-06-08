#ifndef MYANSI_HH_
# define MYANSI_HH_

#include <stdlib.h>
#include <string.h>

#include <iomanip>
#include <sstream>


char *my_strdup(const char *str);

std::string double_to_string(double number, int precision);

#endif /* !MYANSI_HH_ */

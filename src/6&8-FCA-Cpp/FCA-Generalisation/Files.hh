#ifndef FILES_HH_
# define FILES_HH_

#include <stdlib.h>
#include <string.h>

#include <string>
#include <vector>
#include <set>

# ifdef _WIN32

# define MY_SEPARATOR_CHARACTER '\\'

# else

# define MY_SEPARATOR_CHARACTER '/'

# endif /* WIN_32 */

char *BuildPath(char *Dirname, char *Filename);

std::string BuildPath(std::string Dirname, std::string Filename);

std::string my_basename(const std::string path);

std::vector<std::string> splitpath(const std::string& str,
				   const std::set<char> delimiters);

#endif /* !FILES_HH_ */

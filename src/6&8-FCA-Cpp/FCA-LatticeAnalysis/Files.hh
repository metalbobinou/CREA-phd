#ifndef FILES_HH_
# define FILES_HH_

#include <stdlib.h>
#include <string.h>

#include <string>
#include <vector>
#include <set>

#include "MyAnsi.hh"


# ifdef _WIN32

# define MY_SEPARATOR_CHARACTER '\\'

# else

# define MY_SEPARATOR_CHARACTER '/'

# endif /* WIN_32 */


// Take a Directory string, and a Filename string, and concatenate them by adding a '/'
char *BuildPath(const char *Dirname, const char *Filename);
std::string BuildPath(const std::string Dirname, const std::string Filename);

// Take two strings, and merge them into one, AND delete the exceeding dots
char *AddExtension(const char *Filename, const char *Extension);
std::string AddExtension(const std::string Filename, const std::string Extension);

std::string my_basename(const std::string path);

std::vector<std::string> splitpath(const std::string& str,
				   const std::set<char> delimiters);

#endif /* !FILES_HH_ */

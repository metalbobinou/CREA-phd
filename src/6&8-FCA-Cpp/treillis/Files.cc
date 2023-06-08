#include "Files.hh"

char *BuildPath(char *Dirname, char *Filename)
{
  char *path;
  int len, len1, len2;
  int i, j = 0;

  len1 = strlen(Dirname);
  len2 = strlen(Filename);
  len = len1 + len2;
  path = (char*) malloc((len + 2) * sizeof (char));
  for (i = 0; i < len1; i++)
  {
    path[j] = Dirname[i];
    j++;
  }
  path[j++] = '/';
  for (i = 0; i < len2; i++)
  {
    path[j] = Filename[i];
    j++;
  }
  path[j] = '\0';
  return (path);
}

std::string BuildPath(std::string Dirname, std::string Filename)
{
  std::string path;

  path = Dirname + std::string("/") + Filename;
  return (path);
}


// Found on Stackoverflow from Anders

std::string my_basename(const std::string path)
{
  std::vector<std::string> path_vect;
  //std::set<char> delims{'\\'}; // C++11 only
  std::set<char> delims;
  std::string basename;

  //delims.insert('\\');
  //delims.insert('/');
  delims.insert(MY_SEPARATOR_CHARACTER);
  path_vect = splitpath(path, delims);
  basename = std::string(path_vect.back());
  return (basename);
}

// Found on Stackoverflow from Anders

std::vector<std::string> splitpath(const std::string& str,
				   const std::set<char> delimiters)
{
  std::vector<std::string> result;

  char const* pch = str.c_str();
  char const* start = pch;

  for(; *pch; ++pch)
  {
    if (delimiters.find(*pch) != delimiters.end())
    {
      if (start != pch)
      {
        std::string str(start, pch);
        result.push_back(str);
      }
      else
      {
        result.push_back("");
      }
      start = pch + 1;
    }
  }
  result.push_back(start);

  return (result);
}

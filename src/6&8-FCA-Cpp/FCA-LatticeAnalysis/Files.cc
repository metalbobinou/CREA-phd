#include "Files.hh"

// Take a Directory string, and a Filename string, and concatenate them by adding a '/'
char *BuildPath(const char *Dirname, const char *Filename)
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

// Take a Directory string, and a Filename string, and concatenate them by adding a '/'
std::string BuildPath(const std::string Dirname, const std::string Filename)
{
  std::string path;

  path = Dirname + std::string("/") + Filename;
  return (path);
}


// Take two strings, and merge them into one, AND delete the exceeding dots
char *AddExtension(const char *Filename, const char *Extension)
{
  char *OutName, *Prefix, *Suffix;
  int PrefixLen, SuffixLen;

  if (Filename != NULL)
  {
    Prefix = my_strdup(Filename);
    if (Filename[strlen(Filename)] == '.')
    {
      Prefix[strlen(Filename)] = '\0';
    }
  }
  else
    Prefix = NULL;
  PrefixLen = strlen(Prefix);

  if (Extension != NULL)
  {
    Suffix = my_strdup(Extension);
    if (Extension[0] == '.')
    {
      for (unsigned int i = 0; i < strlen(Suffix); i++)
	Suffix[i] = Suffix[i + 1];
    }
  }
  else
    Suffix = NULL;
  SuffixLen = strlen(Suffix);

  OutName = (char*) malloc((PrefixLen + SuffixLen + 1) * sizeof (char));
  for (int i = 0; i < PrefixLen; i++)
    OutName[i] = Prefix[i];
  OutName[PrefixLen] = '.';
  for (int i = PrefixLen + 1; i < (PrefixLen + SuffixLen + 1); i++)
    OutName[i] = Suffix[i - PrefixLen - 1];
  OutName[PrefixLen + SuffixLen + 1] = '\0';

  free(Prefix);
  free(Suffix);
  return (OutName);
}

// Take two strings, and merge them into one, AND delete the exceeding dots
std::string AddExtension(const std::string Filename, const std::string Extension)
{
  std::string OutName, Prefix, Suffix;

  if (! Filename.empty())
  {
    //if (Filename.back() != '.') // C++11
    if (Filename[Filename.size() - 1] != '.')
      Prefix = Filename;
    else
      Prefix = Filename.substr(0, (Filename.size() - 2));
  }
  else
    Prefix = Filename;

  if (! Extension.empty())
  {
    //if (Extension.front() != '.') // C++11
    if (Extension[0] != '.')
      Suffix = Extension;
    else
      Suffix = Extension.substr(1, Extension.size());
  }
  else
    Suffix = Extension;


  OutName = Prefix + std::string(".") + Suffix;
  return OutName;
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

#include "Args.hh"

char **duplicate_argv(int argc, char **argv)
{
  char **out = (char**) malloc(argc * sizeof (char*));
  int i = 0;

  for (i = 1; i < argc; i++)
  {
    out[i - 1] = my_strdup(argv[i]);
  }
  out[i - 1] = NULL;
  return (out);
}

std::vector<std::string> VectorizeArgv(int argc, char**argv)
{
  std::vector<std::string> vect;
  std::string str;
  int i = 0;

  for (i = 1; i < argc; i++)
  {
    str = std::string(argv[i]);
    vect.push_back(str);
  }
  return (vect);
}

void deep_free_args(char **args)
{
  if (args != NULL)
  {
    for (int i = 0; args[i] != NULL; i++)
    {
      free(args[i]);
    }
    free(args);
  }
}

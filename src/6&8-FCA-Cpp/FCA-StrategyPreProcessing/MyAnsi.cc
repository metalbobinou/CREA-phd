#include "MyAnsi.hh"

char *my_strdup(const char *str)
{
  int i, len = strlen(str);
  char *out = (char*) malloc((len + 1) * sizeof (char));

  for (i = 0; i < len; i++)
    out[i] = str[i];
  out[i] = '\0';
  return (out);
}

std::string double_to_string(double number, int precision)
{
  std::stringstream stream;
  std::string s;

  stream << std::fixed << std::setprecision(precision) << number;
  s = stream.str();
  return (s);
}

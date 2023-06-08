#ifndef ARGS_HH_
# define ARGS_HH_

#include <string>
#include <vector>

#include "MyAnsi.hh"


char **duplicate_argv(int argc, char **argv);

std::vector<std::string> VectorizeArgv(int argc, char**argv);

void deep_free_args(char **args);

#endif /* !ARGS_HH_ */

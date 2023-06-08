#include "main.hh"

int main(int argc, char **argv)
{
  if (argc > 1)
  {
    std::vector<std::string> vect;
    char **args;

    args = duplicate_argv(argc, argv);
    vect = VectorizeArgv(argc, argv);

    ProcessingFiles(args, "FichiersStrategies");

    deep_free_args(args);

    return 0;
  }
  else
  {
    std::cerr << "You must give at least 1 argument" << std::endl;

    std::cout << "Usage: " << std::endl;
    std::cout << argv[0] << " file1 [file2 file3 ...]" << std::endl;
    std::cout << std::endl;
    std::cout << "Example:" << std::endl;
    std::cout << argv[0] << " matrix1.txt matrix2.csv" << std::endl;

    return -1;
  }
}

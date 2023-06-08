#include "main.hh"

int main(int argc, char **argv)
{
  if (argc <= 1)
  {
    fprintf(stderr, "Not enough parameters\n");
    fprintf(stderr, "\n");
    fprintf(stderr, "Usage:\n");
    fprintf(stderr, "%s file1 ...\n", argv[0]);
    return (-1);
  }

  std::vector<std::string> ArgVect = VectorizeArgv(argc, argv);

  ProcessingFiles(ArgVect, "MesuresTreillis");

  return (0);
}

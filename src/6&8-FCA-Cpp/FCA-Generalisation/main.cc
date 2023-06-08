#include "main.hh"


#ifdef MULTIPLE_ARGS

int main(int argc, char **argv)
{
  if (argc > 1)
  {
    std::vector<std::string> vect;
    char **args;

    args = duplicate_argv(argc, argv);
    vect = vectorize_argv(argc, argv);


    //printf("Imapct******************************************************\n");
    setlocale(LC_NUMERIC, "French_Canada.1252");
    // ".OCP" if you want to use system settings

    GeneralisationMesureImpact();

    //printf("SimApp******************************************************\n");
    GeneralisationMesureSimApp();

    //printf("SimContex***************************************************\n");
    GeneralisationMesureSimContex();

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

    getc(stdin);
    return -1;
  }
}


#else


int main()
{
    //printf("Imapct******************************************************\n");
    setlocale(LC_NUMERIC, "French_Canada.1252");
    // ".OCP" if you want to use system settings

    GeneralisationMesureImpact();

    //printf("SimApp******************************************************\n");
    GeneralisationMesureSimApp();

    //printf("SimContex***************************************************\n");
    GeneralisationMesureSimContex();

    getc(stdin);
    return 0;
}

#endif

#include "TreillisStructs.hh"

#include "Args.hh"
#include "LireEtInterpTreillis.hh"
#include "ContextFormelStrategies.hh"
#include "AppliqueLesMesures.hh"
#include "GeneralisationSimContex.hh"
#include "GeneralisationImpact.hh"
#include "GeneralisationSimApp.hh"
#include "DSPLs.hh"


#ifdef MULTIPLE_ARGS

int main(int argc, char **argv)
{
  if (argc > 1)
  {
    std::vector<std::string> vect;
    char **args;

    args = duplicate_argv(argc, argv);
    vect = vectorize_argv(argc, argv);

    //PercentageDSPLs();

    //ContextFormelStrategies(); // <= step 1
    ContextFormelStrategies(args, "FichiersStrategies");

    //AppliqueLesMesures(); // <= step 2

    //printf("Imapct****************************************************************\n");

    //setlocale(LC_NUMERIC, "French_Canada.1252"); // ".OCP" if you want to use system settings

    //GeneralisationMesureImpact();


    //printf("SimApp****************************************************************\n");


    //GeneralisationMesureSimApp();

    //printf("SimContex*************************************************************\n");

    //GeneralisationMesureSimContex();

    deep_free_args(args);
    getc(stdin);
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
    //PercentageDSPLs();

    ContextFormelStrategies(); // <= step 1
    //ContextFormelStrategies(args, "FichiersStrategies");
    //AppliqueLesMesures(); // <= step 2

    //printf("Imapct****************************************************************\n");

    //setlocale(LC_NUMERIC, "French_Canada.1252"); // ".OCP" if you want to use system settings

    //GeneralisationMesureImpact();


    //printf("SimApp****************************************************************\n");


    //GeneralisationMesureSimApp();

    //printf("SimContex*************************************************************\n");

    //GeneralisationMesureSimContex();

    getc(stdin);
    return 0;
}

    /*
       float test[33][33];
       int i,j;
       FILE* F = fopen("matr.txt", "w");

       ReadMatrix(82,8,21,2,test);

       for(i=0;i<8;i++)
       {
          for(j=0;j<8;j++)
	  {
	     fprintf(F,"%f\t",test[i][j]);
	  }
	  fprintf(F,"\n");
       }
       fclose(F);
    */


#endif

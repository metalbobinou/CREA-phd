#include "ContextFormelStrategies.hh"

void CopieContextFormel (ContextFormel * CFbis, ContextFormel * CF)
{
	int i,j;
	(*CFbis).NbrA=(*CF).NbrA;
	(*CFbis).NbrO=(*CF).NbrO;
	for(i=0;i<(*CF).NbrO;i++) strcpy((*CFbis).Objet[i],(*CF).Objet[i]);
	for(i=0;i<(*CF).NbrA;i++) strcpy((*CFbis).Attribut[i],(*CF).Attribut[i]);
	for(i=0;i<(*CF).NbrO;i++)
		for(j=0;j<(*CF).NbrA;j++)
			(*CFbis).Matrice[i][j]=(*CF).Matrice[i][j];


}

void LireContexteFormelle(FILE *F,ContextFormel *CF)
{
  char *ptr;
  int o = 0, a = 0;

     #ifdef WITH_CSV_PARSER
  struct csv_parser parser;
  struct csv_struct csv_struct;
  char buf[LIRECONTEXTEFORMEL_BUFFER];
  size_t buf_i;

	csv_init(&parser, 0);
	init_csv_struct(&csv_struct);
	csv_set_delim(&parser, ';'); // Au cas ou ca n'est pas ,
	printf("-- Init OK\n");
	while ((buf_i = fread(buf, 1, sizeof(buf), F)) > 0)
	{
	  printf("- Read\n");
	  if (csv_parse(&parser, buf, buf_i,
			csv_column, csv_line, &csv_struct) != buf_i)
	  {
	    fprintf(stderr, "Error parsing file at [%d][%d] : %s\n",
		    csv_struct.fields,
		    csv_struct.rows,
		    csv_strerror(csv_error(&parser)));
	  }
	}
	printf("-- Parse OK\n");
	//csv_fini(&parser, csv_column, csv_line, OtherF);
	csv_free(&parser);
	// Everything has been put in memory

	printf("-- Reading OK\n");
	// Get the first line (description of the CSV array)
	for (std::vector<std::string>::iterator it = csv_struct.CSV[0].begin();
	     it != csv_struct.CSV[0].end();
	     ++it)
	{
	  //CF->Attribut[a] = my_strdup((*it).c_str());
	  {
	    char *str = my_strdup(it->c_str());
	    strncpy(CF->Attribut[a], str, 30);
	    free(str);
	  }
	  a++;
	}
	CF->NbrA = a;

	printf("-- 1st line OK\n");
	for (std::vector<std::vector<std::string> >::iterator l = csv_struct.CSV.begin();
	     l != csv_struct.CSV.end();
	     ++l)
	{
	  a = 0;
	  for (std::vector<std::string>::iterator r = l->begin();
	     r != l->end();
	     ++r)
	  {
	    if (a == 0)
	    {
	      //CF->Objet[o] = my_strdup(r->c_str()); // Copy the first column / name
	      char *str = my_strdup(r->c_str());
	      strncpy(CF->Objet[o], str, 20);
	      free(str);
	    }
	    else
	    {
	      CF->Matrice[o][a - 1] = strtol(r->c_str(), &ptr, 10);
	    }
	    a++;
	  }
	  o++;
	}
	CF->NbrO = o;

	printf("-- Full OK\n");

	clear_csv_struct(&csv_struct);

     #else /* ELSE */
	char ligne[200] = "";
	char n[3];
	int i = 0, j = 0;


	fgets(ligne, 190, F);

	while (ligne[i]!='\n')
	{
		while(ligne[i]!=';' && ligne[i]!='\n')
		{
			(*CF).Attribut[a][j]=ligne[i];
			j++;i++;
		}
		(*CF).Attribut[a][j]='\0';
		j=0;
		if(ligne[i]!='\n') i++;
		a++;
	}

	(*CF).NbrA=a;
	while (fgets(ligne, 190, F)!=NULL)
	{
		i=0;
		j=0;
		while(ligne[i]!=';')
		{
			(*CF).Objet[o][j]=ligne[i];
			j++;i++;
		}
		(*CF).Objet[o][j]='\0';
		j=0;
		i++;
		n[0]='\0';n[1]='\0'; n[2]='\0';
		a=0;
		while(ligne[i]!='\n' )
		{
			while(ligne[i]!=';' && ligne[i]!='\n')
			{
				n[j]=ligne[i];
				j++;
				i++;
			}
			(*CF).Matrice[o][a]=strtol(n, &ptr,10);
			n[0]='\0';n[1]='\0'; n[2]='\0';j=0;
			if(ligne[i]!='\n') i++;
			a++;
		}
		o++;
	}
	(*CF).NbrO=o;
    #endif
}

/*
void ImprimerContextFormel(ContextFormel CF)
{
	int i,j;
	for(i=0;i<CF.NbrO;i++) printf("%s \n",CF.Objet[i]);
	for(i=0;i<CF.NbrA;i++) printf("%s \n",CF.Attribut[i]);
	for(i=0;i<CF.NbrO;i++)
	{
		for(j=0;j<CF.NbrA;j++)
			printf("%d  ",int(CF.Matrice[i][j]));
		printf("\n");
	}
}
*/

void ConstruirefichierContextFormel (ContextFormel * CF, FILE* F)
{
	int i,j;
	fprintf(F,"[Lattice]\n");
	fprintf(F,"%d\n",(*CF).NbrO);
	fprintf(F,"%d\n",(*CF).NbrA);
	fprintf(F,"[Objects]\n");
	for(i=0;i<(*CF).NbrO;i++) fprintf(F,"%s\n",(*CF).Objet[i]);
	fprintf(F,"[Attributes]\n");
	for(i=0;i<(*CF).NbrA;i++) fprintf(F,"%s\n",(*CF).Attribut[i]);
	fprintf(F,"[relation]\n");
	for(i=0;i<(*CF).NbrO;i++)
	{
		for(j=0;j<(*CF).NbrA;j++)
			fprintf(F,"%d ",int((*CF).Matrice[i][j]));
		fprintf(F,"\n");
	}

}



/*
[Lattice]
4
4
[Objects]
Gmail
Telephone
VDM
Youtube
[Attributes]
University
Home
3G
Morning
[relation]
1 0 1 0
0 0 1 0
0 0 1 0
0 1 1 1
*/

void ConstruirefichierContextFormelBis (ContextFormel * CF, FILE* F)
{
	int i,j;
	fprintf(F,"B\n\n");
	fprintf(F,"%d\n",(*CF).NbrO);
	fprintf(F,"%d\n",(*CF).NbrA);
	fprintf(F,"\n");
	for(i=0;i<(*CF).NbrO;i++) fprintf(F,"%s\n",(*CF).Objet[i]);
	for(i=0;i<(*CF).NbrA;i++) fprintf(F,"%s\n",(*CF).Attribut[i]);
	for(i=0;i<(*CF).NbrO;i++)
	{
		for(j=0;j<(*CF).NbrA;j++)
		{
			if(int((*CF).Matrice[i][j])==1)
				fprintf(F,"X");
			else
				fprintf(F,".");
		}
		fprintf(F,"\n");
	}

}

/*
B

6
11

Youtube
SMS
Telephone
Flappy Bird
VDM
Gmail
university
restaurant
parents_home
home
transportation
_3G
morning
coffee_break
lunch_break
afternoon
evening
XXX.X..XXXX
.XXX..XXX.X
XXX...XXX.X
.XX...XXXXX
XXX....XXX.
.XXX...XX.X
*/

void ConstruirefichierContextFormelBis2 (ContextFormel * CF, FILE* F)   // .csv
{
	int i,j;
	for(i=0;i<(*CF).NbrA;i++) fprintf(F,";%s",(*CF).Attribut[i]);
	fprintf(F,"\n");
	for(i=0;i<(*CF).NbrO;i++)
	{
		fprintf(F,"%s;",(*CF).Objet[i]);
		for(j=0;j<(*CF).NbrA;j++)
			fprintf(F,"%d; ",int((*CF).Matrice[i][j]));
		fprintf(F,"\n");
	}
}

void SupprimerLignesColonnes0(ContextFormel * CF)
{
	int i,j,k;
	int NbrO=0,NbrA=0;
	ContextFormel  * CFbis1;
	CFbis1 = (ContextFormel*) malloc(1*sizeof (ContextFormel));
	for(j=0;j<(*CF).NbrA;j++)   // chercher les colonnes de 0
	{
		for(i=0;i<(*CF).NbrO;i++)
		{
			if((*CF).Matrice[i][j]!=0)
				break;
		}
		if(i!=(*CF).NbrO)
		{
			strcpy((*CFbis1).Attribut[NbrA],(*CF).Attribut[j]);
			for(k=0;k<(*CF).NbrO;k++)
			{
				(*CFbis1).Matrice[k][NbrA]=(*CF).Matrice[k][j];
			}
			NbrA++;
		}
	}

	(*CFbis1).NbrA=NbrA;
	(*CFbis1).NbrO=(*CF).NbrO;
	for(i=0;i<(*CF).NbrO;i++)
	{
		strcpy((*CFbis1).Objet[i],(*CF).Objet[i]);
	}

	CopieContextFormel(CF,CFbis1);

	for(i=0;i<(*CF).NbrO;i++)   // chercher les lignes de 0
	{
		for(j=0;j<(*CF).NbrA;j++)
		{
			if((*CF).Matrice[i][j]!=0)
				break;
		}
		if(j!=(*CF).NbrA)
		{
			strcpy((*CFbis1).Objet[NbrO],(*CF).Objet[i]);
			for(k=0;k<(*CF).NbrA;k++)
			{
				(*CFbis1).Matrice[NbrO][k]=(*CF).Matrice[i][k];
			}
			NbrO++;
		}
	}
	(*CFbis1).NbrO=NbrO;
	(*CFbis1).NbrA=(*CF).NbrA;
	for(i=0;i<(*CFbis1).NbrA;i++)
	{
		strcpy((*CFbis1).Attribut[i],(*CF).Attribut[i]);
	}

	CopieContextFormel(CF,CFbis1);
}


/////////////////////////////////////////////////////////////////// AVEC ONTOLOGIE //////////////////////////////////////////////////////



void RelationsNulles (ContextFormel * CF)
{
	int i,j;

	for(i=0;i<(*CF).NbrO;i++)
	{
		for(j=0;j<(*CF).NbrA;j++)
		{
			if((*CF).Matrice[i][j]==0)
				(*CF).Matrice[i][j]=1;
			else
				(*CF).Matrice[i][j]=0;
		}
	}
}

void Directesansfrequence (ContextFormel * CF)
{
	int i,j;

	for(i=0;i<(*CF).NbrO;i++)
	{
		for(j=0;j<(*CF).NbrA;j++)
		{
			if((*CF).Matrice[i][j]==0)
				(*CF).Matrice[i][j]=0;
			else
				(*CF).Matrice[i][j]=1;
		}
	}
}

/////////////////////////////////////////////////////////////////// SANS ONTOLOGIE //////////////////////////////////////////////////////


void RelationsFortesSansOnto (ContextFormel * CF, double Beta)
{
	int i,j,T;
	double Moyenne=0;
	double EcartType=0;
	double SeuilHaut;
	double * Diff;
	Diff= new double[(*CF).NbrA];
	for(i=0;i<(*CF).NbrO;i++)
	{
		T=0;
		for(j=0;j<(*CF).NbrA;j++)
		{
			if((*CF).Matrice[i][j]!=0)
			{
				T++;
				Moyenne=Moyenne+(*CF).Matrice[i][j];
			}
		}
		if(T!=0) Moyenne=Moyenne/T;

		for(j=0;j<(*CF).NbrA;j++)
		{
			if((*CF).Matrice[i][j]!=0)
			{
				Diff[j]=pow((*CF).Matrice[i][j]-Moyenne,2);
				EcartType=EcartType+Diff[j];
			}
		}
		if(T!=0) EcartType=sqrt(EcartType/T);

		SeuilHaut=Moyenne+Beta*EcartType;

		for(j=0;j<(*CF).NbrA;j++)
		{
			if((*CF).Matrice[i][j]>SeuilHaut)
				(*CF).Matrice[i][j]=1;
			else
				(*CF).Matrice[i][j]=0;
		}
		EcartType=0;
		Moyenne=0;
	}
	delete[] Diff;
}

void RelationsFaiblesSansOnto (ContextFormel * CF, double Beta)
{
	int i,j,T;
	double Moyenne=0;
	double EcartType=0;
	double SeuilBas;
	double *Diff;
	Diff= new double[(*CF).NbrA];
	for(i=0;i<(*CF).NbrO;i++)
	{
		T=0;
		for(j=0;j<(*CF).NbrA;j++)
		{
			if((*CF).Matrice[i][j]!=0)
			{
				T++;
				Moyenne=Moyenne+(*CF).Matrice[i][j];
			}
		}
		if(T!=0) Moyenne=Moyenne/T;

		for(j=0;j<(*CF).NbrA;j++)
		{
			if((*CF).Matrice[i][j]!=0)
			{
				Diff[j]=pow((*CF).Matrice[i][j]-Moyenne,2);
				EcartType=EcartType+Diff[j];
			}
		}
		if(T!=0) EcartType=sqrt(EcartType/T);
		SeuilBas=Moyenne-Beta*EcartType;
		if(SeuilBas < 0 ) SeuilBas = 0;

		for(j=0;j<(*CF).NbrA;j++)
		{
			if(0<(*CF).Matrice[i][j] && (*CF).Matrice[i][j]<SeuilBas)
				(*CF).Matrice[i][j]=1;
			else
				(*CF).Matrice[i][j]=0;
		}
		EcartType=0;
		Moyenne=0;
	}
	delete[] Diff;
}

void RelationsMoyennesSansOnto (ContextFormel * CF, double Beta)
{
	int i,j,T;
	double Moyenne=0;
	double EcartType=0;
	double SeuilBas;
	double SeuilHaut;
	double *Diff;
	Diff= new double[(*CF).NbrA];
	for(i=0;i<(*CF).NbrO;i++)
	{
		T=0;
		for(j=0;j<(*CF).NbrA;j++)
		{
			if((*CF).Matrice[i][j]!=0)
			{
				T++;
				Moyenne=Moyenne+(*CF).Matrice[i][j];
			}
		}
		if(T!=0) Moyenne=Moyenne/T;

		for(j=0;j<(*CF).NbrA;j++)
		{
			if((*CF).Matrice[i][j]!=0)
			{
				Diff[j]=pow((*CF).Matrice[i][j]-Moyenne,2);
				EcartType=EcartType+Diff[j];
			}
		}
		if(T!=0) EcartType=sqrt(EcartType/T);
		SeuilBas=Moyenne-Beta*EcartType;
		SeuilHaut=Moyenne+Beta*EcartType;
		if(SeuilBas < 0 ) SeuilBas = 0;

		for(j=0;j<(*CF).NbrA;j++)
		{
			if(0<(*CF).Matrice[i][j] && SeuilBas<=(*CF).Matrice[i][j] && (*CF).Matrice[i][j]<=SeuilHaut)
				(*CF).Matrice[i][j]=1;
			else
				(*CF).Matrice[i][j]=0;
		}
		EcartType=0;
		Moyenne=0;
	}
	delete[] Diff;
}




/////////////////////////////////////////////////////////////////// SANS ONTOLOGIE //////////////////////////////////////////////////////

void ContextFormelStrategies()   //****************************************************************************************//
{
	ContextFormel *CF, *CFbis;
	FILE* FichEtu = NULL;
	FILE* FichEtuS = NULL;
	double Beta=0;

	CFbis = (ContextFormel*) malloc(1*sizeof (ContextFormel));
	CF = (ContextFormel*) malloc(1*sizeof (ContextFormel));

	char FichiersDirectesansfrequence[40];
	char FichiersRelationsNulles[40];

	char FichiersRelationsFortesSansOnto[40];  // stratégie 1 bis
	char FichiersRelationsFaiblesSansOnto[40]; // stratégie 2 bis
	char FichiersRelationsMoyennesSansOnto[40]; // stratégie 3 bis


	char B[9];


	//FichEtu = fopen("FichDSPLS/DSPLS_Percentage.csv", "r");
	FichEtu = fopen("KIP/out_matrix.csv", "r");
	if(FichEtu != NULL)
	{
		//printf("FichDSPLS/DSPLS_Percentage.csv\n");
		printf("KIP/out_matrix.csv\n");

		LireContexteFormelle(FichEtu,CF);


		//ImprimerContextFormel(CF);

		Beta=0;

		while (Beta!=1.25)
		{
			sprintf(B,"%f",Beta);
			sprintf(FichiersRelationsFortesSansOnto,"FichiersStrategies/E-O=N-S=H-B=%c,%c%c.csv",B[0],B[2],B[3]);
			sprintf(FichiersRelationsFaiblesSansOnto,"FichiersStrategies/E-O=N-S=B-B=%c,%c%c.csv",B[0],B[2],B[3]);
			sprintf(FichiersRelationsMoyennesSansOnto,"FichiersStrategies/E-O=N-S=M-B=%c,%c%c.csv",B[0],B[2],B[3]);
			sprintf(FichiersRelationsNulles,"FichiersStrategies/E-Inverse.csv");
			sprintf(FichiersDirectesansfrequence,"FichiersStrategies/E-Directe.csv");


			CopieContextFormel(CFbis,CF);
			FichEtuS=fopen(FichiersRelationsFortesSansOnto, "w");
			RelationsFortesSansOnto(CFbis, Beta);
			SupprimerLignesColonnes0(CFbis);
			//ConstruirefichierContextFormel ( CFbis, FichEtuS);   //slf
			//ConstruirefichierContextFormelBis(CFbis, FichEtuS); //txt
			ConstruirefichierContextFormelBis2(CFbis, FichEtuS); //csv
			fclose(FichEtuS);
			rewind(FichEtu);

			CopieContextFormel(CFbis,CF);
			FichEtuS=fopen(FichiersRelationsFaiblesSansOnto, "w");
			RelationsFaiblesSansOnto(CFbis, Beta);
			SupprimerLignesColonnes0(CFbis);
			//ConstruirefichierContextFormel ( CFbis, FichEtuS);
			//ConstruirefichierContextFormelBis(CFbis, FichEtuS);
			ConstruirefichierContextFormelBis2(CFbis, FichEtuS);
			fclose(FichEtuS);
			rewind(FichEtu);

			CopieContextFormel(CFbis,CF);
			FichEtuS=fopen(FichiersRelationsMoyennesSansOnto, "w");
			RelationsMoyennesSansOnto(CFbis, Beta);
			SupprimerLignesColonnes0(CFbis);
			//ConstruirefichierContextFormel ( CFbis, FichEtuS);
			//ConstruirefichierContextFormelBis(CFbis, FichEtuS);
			ConstruirefichierContextFormelBis2(CFbis, FichEtuS);
			fclose(FichEtuS);
			rewind(FichEtu);

			CopieContextFormel(CFbis,CF);
			FichEtuS=fopen(FichiersRelationsNulles, "w");
			RelationsNulles(CFbis);
			SupprimerLignesColonnes0(CFbis);
			//ConstruirefichierContextFormel ( CFbis, FichEtuS);
			//ConstruirefichierContextFormelBis(CFbis, FichEtuS);
			ConstruirefichierContextFormelBis2(CFbis, FichEtuS);
			fclose(FichEtuS);
			rewind(FichEtu);

			CopieContextFormel(CFbis,CF);
			FichEtuS=fopen(FichiersDirectesansfrequence, "w");
			Directesansfrequence(CFbis);
			SupprimerLignesColonnes0(CFbis);
			//ConstruirefichierContextFormel ( CFbis, FichEtuS);
			//ConstruirefichierContextFormelBis(CFbis, FichEtuS);
			ConstruirefichierContextFormelBis2(CFbis, FichEtuS);
			fclose(FichEtuS);
			rewind(FichEtu);

			Beta=Beta+0.25;
		}
		//getc(stdin);
		//system("cls");
		fclose(FichEtu);

	//	free(CF);
	//	free(CFbis);
	}
	else
	{
		printf("Impossible d'ouvrir le fichier KIP/out_matrix.csv \n");
		getc(stdin);
	}

}






// Version qui gere N fichiers en entree
void ContextFormelStrategies(char **InputFiles, const char *OutputDirectory)
{
  CreateSubPath(OutputDirectory);
  for (int IterFile = 0; InputFiles[IterFile] != NULL; IterFile++)
  {
    std::string InputFileName = std::string(InputFiles[IterFile]);
    std::string InputBaseName = my_basename(InputFileName);
    FILE* InFile = NULL;

    std::cout << InputFileName << std::endl;
    InFile = fopen(InputFileName.c_str(), "r");
    if (InFile != NULL)
    {
      ContextFormel *CF, *CFbis;
      FILE* OutFile = NULL;
      double Beta = 0;

      CFbis = (ContextFormel*) malloc(1 * sizeof (ContextFormel));
      CF = (ContextFormel*) malloc(1 * sizeof (ContextFormel));

      LireContexteFormelle(InFile, CF);
      //ImprimerContextFormel(CF);

      while (Beta < 1.25)
      {
	std::string OutFileNoOntoHigh;
	std::string OutFileNoOntoMid;
	std::string OutFileNoOntoLow;
	std::string OutFileNullRelations;
	std::string OutFileDirectNoFreq;
	std::string TmpName, B;
	//char TmpName[64];
	//char B[sizeof (double)]; // 9 ?

	B = double_to_string(Beta, 2);
	//sprintf(B, "%f", Beta);

	//sprintf(TmpName, "E-O=N-S=H-B=%c,%c%c.csv", B[0], B[2], B[3]);
	//OutFileNoOntoHigh = OutputFilename + std::string(TmpName);
	TmpName = InputBaseName + "-O=N-S=H-B=" + B + ".csv";
	OutFileNoOntoHigh = BuildPath(OutputDirectory, TmpName);
	CopieContextFormel(CFbis,CF);
	OutFile = fopen(OutFileNoOntoHigh.c_str(), "w");
	RelationsFortesSansOnto(CFbis, Beta);
	SupprimerLignesColonnes0(CFbis);
	//ConstruirefichierContextFormel(CFbis, OutFile);    //slf
	//ConstruirefichierContextFormelBis(CFbis, OutFile); //txt
	ConstruirefichierContextFormelBis2(CFbis, OutFile);  //csv
	fclose(OutFile);
	rewind(InFile);

	//sprintf(TmpName, "E-O=N-S=M-B=%c,%c%c.csv", B[0], B[2], B[3]);
	//OutFileNoOntoMid = OutputFilename + std::string(TmpName);
	TmpName = InputBaseName + "-O=N-S=M-B=" + B + ".csv";
	OutFileNoOntoMid = BuildPath(OutputDirectory, TmpName);
	CopieContextFormel(CFbis, CF);
	OutFile = fopen(OutFileNoOntoMid.c_str(), "w");
	RelationsMoyennesSansOnto(CFbis, Beta);
	SupprimerLignesColonnes0(CFbis);
	//ConstruirefichierContextFormel(CFbis, OutFile);
	//ConstruirefichierContextFormelBis(CFbis, OutFile);
	ConstruirefichierContextFormelBis2(CFbis, OutFile);
	fclose(OutFile);
	rewind(InFile);

	//sprintf(TmpName, "E-O=N-S=B-B=%c,%c%c.csv", B[0], B[2], B[3]);
	//OutFileNoOntoLow = OutputFilename + std::string(TmpName);
	TmpName = InputBaseName + "-O=N-S=B-B=" + B + ".csv";
	OutFileNoOntoLow = BuildPath(OutputDirectory, TmpName);
	CopieContextFormel(CFbis, CF);
	OutFile = fopen(OutFileNoOntoLow.c_str(), "w");
	RelationsFaiblesSansOnto(CFbis, Beta);
	SupprimerLignesColonnes0(CFbis);
	//ConstruirefichierContextFormel(CFbis, OutFile);
	//ConstruirefichierContextFormelBis(CFbis, OutFile);
	ConstruirefichierContextFormelBis2(CFbis, OutFile);
	fclose(OutFile);
	rewind(InFile);


	//sprintf(TmpName, "E-Inverse.csv");
	//OutFileNullRelations = OutputFilename + std::string(TmpName);
	TmpName = InputBaseName + "-Inverse.csv";
	OutFileNullRelations = BuildPath(OutputDirectory, TmpName);
	CopieContextFormel(CFbis, CF);
	OutFile = fopen(OutFileNullRelations.c_str(), "w");
	RelationsNulles(CFbis);
	SupprimerLignesColonnes0(CFbis);
	//ConstruirefichierContextFormel(CFbis, OutFile);
	//ConstruirefichierContextFormelBis(CFbis, OutFile);
	ConstruirefichierContextFormelBis2(CFbis, OutFile);
	fclose(OutFile);
	rewind(InFile);

	//sprintf(TmpName, "E-Directe.csv");
	//OutFileDirectNoFreq = OutputFilename + std::string(TmpName);
	TmpName = InputBaseName + "-Directe.csv";
	OutFileDirectNoFreq = BuildPath(OutputDirectory, TmpName);
	CopieContextFormel(CFbis, CF);
	OutFile = fopen(OutFileDirectNoFreq.c_str(), "w");
	Directesansfrequence(CFbis);
	SupprimerLignesColonnes0(CFbis);
	//ConstruirefichierContextFormel(CFbis, OutFile);
	//ConstruirefichierContextFormelBis(CFbis, OutFile);
	ConstruirefichierContextFormelBis2(CFbis, OutFile);
	fclose(OutFile);
	rewind(InFile);

	Beta = Beta + 0.25;
      }
      //getc(stdin);
      //std::cout << std::endl << std::endl << std::endl << std::endl;
      fclose(InFile);

      free(CF);
      free(CFbis);
    }
    else
    {
      //printf("Impossible d'ouvrir le fichier de DSPLS_Percentage \n");
      std::cerr << "Impossible d'ouvrir le fichier " << InputFileName << std::endl;
      getc(stdin);
    }
  } // end for
}

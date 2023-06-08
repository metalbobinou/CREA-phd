#include "GeneralisationSimContex.hh"

void ConstruireFichierSimContexEMS(Treillis *T,char *NE, float Matrix[33][33],char O,char S,char beta[6]) // les impact dans le dossier EtudiantsMesuresStrategies
{
  int rc1;//, rc2;
  int nrow1, nrow2;
  int ncolumn1;//, ncolumn2;
  int l1, l2;
  //int c;
	char *Requete1=NULL;
	//char *Requete2=NULL;
	char *NomT=NULL;
	char ** result1;
	char ** result2;
	sqlite3 *db;
	char *zErrMsg = 0;
	char *chemin=NULL;
	FILE* FSimContex = NULL;

	chemin=(char*)malloc(150*sizeof(char));
	NomT=(char*)malloc(50*sizeof(char));
	Requete1=(char*)malloc(50*sizeof(char));
	//Requete2=(char*)malloc(50*sizeof(char));

	//sprintf(Requete1,"SELECT Objet.NomObjet FROM Objet");
	sprintf(Requete1,"SELECT Attribut.NomAttribut FROM Attribut");
	sprintf(NomT,"TreillisStruct/%s.sqlite",(*T).NomTreillis);
	//result=RequeteBDD(NomT,Requete);
	rc1 = sqlite3_open(NomT, &db);
	if( rc1 ) {fprintf(stderr, "Can't open database: %s\n", sqlite3_errmsg(db));getc(stdin);}
	//else fprintf(stdout, "Opened database successfully\n");
	sqlite3_get_table(db,Requete1,&result1,&nrow1,&ncolumn1,&zErrMsg);
	//sqlite3_get_table(db,Requete2,&result2,&nrow2,&ncolumn2,&zErrMsg);
	//Requete2=Requete1;
	result2=result1;
	nrow2=nrow1;
	//ncolumn2=ncolumn1;

	/*                            //Pour chaque application tout seul
	for(l1=1;l1<=nrow1;l1++)
	{
		sprintf(chemin, "EtudiantsMesuresStrategies/%s/GeneralisationMesureSimApp/O=%c S=%c/B=%s/Impact_%s.csv",NE,O,S,beta, result1[l1]);
		FSimApp = fopen(chemin,"w");

		for(l2=1;l2<=nrow2;l2++)
		{
			if(Matrix[l1-1][l2-1]<0 || Matrix[l1-1][l2-1] >1 )
			{
				printf("%s  %s\n %d - %d \n %f\n",result1[l1], result2[l2],l1-1, l2-1,Matrix[l1-1][l2-1]);
				getc(stdin);
			}
			fprintf(FSimApp,"%s;%f\n",result2[l2],Matrix[l1-1][l2-1]);
		}
		fclose(FSimApp);
	}

	*/

	sprintf(chemin, "EtudiantsMesuresStrategies/%s/GeneralisationMesureSimContex/O=%c S=%c/B=%s/SimContex.csv",NE,O,S,beta);
	FSimContex = fopen(chemin,"w");
	for(l2=1;l2<=nrow2;l2++) fprintf(FSimContex,";%s",result2[l2]);
	for(l1=1;l1<=nrow1;l1++)                                         // Matrix d'impact
	{
		fprintf(FSimContex,"\n");
		fprintf(FSimContex,"%s",result1[l1]);
		for(l2=1;l2<=nrow2;l2++)
		{
			if(Matrix[l1-1][l2-1]<0 || Matrix[l1-1][l2-1] >1 )
			{
				printf("%s  %s\n %d - %d \n %f\n",result1[l1], result2[l2],l1-1, l2-1,Matrix[l1-1][l2-1]);
				getc(stdin);
			}
			fprintf(FSimContex,";%f",Matrix[l1-1][l2-1]);
		}

	}
	fclose(FSimContex);

	//for(l2=1;l2<=nrow2;l2++)   Pour lire les resultat de la requete
	//{
	//	for(c=0;c<ncolumn2;c++)
	//		printf("%s\t",result2[l2*ncolumn2+c]);
	//	printf("\n");
	//}
	sqlite3_close(db);
	sqlite3_free_table(result1);
	//sqlite3_free_table(result2);
	delete[] chemin;
	delete[] NomT;
	delete[] Requete1;
	//delete[] Requete2;
}

void ConstruireFichierSimContexEMS_NN(Treillis *T,char *NE, float Matrix[33][33],char O,char S) // les impact dans le dossier EtudiantsMesuresStrategies
{
  int rc1;//, rc2;
  int nrow1, nrow2;
  int ncolumn1;//, ncolumn2;
  int l1, l2;
  //int c;
	char *Requete1=NULL;
	//char *Requete2=NULL;
	char *NomT=NULL;
	char ** result1;
	char ** result2;
	sqlite3 *db;
	char *zErrMsg = 0;
	char *chemin=NULL;
	FILE* FSimContex = NULL;

	chemin=(char*)malloc(150*sizeof(char));
	NomT=(char*)malloc(50*sizeof(char));
	Requete1=(char*)malloc(50*sizeof(char));
	//Requete2=(char*)malloc(50*sizeof(char));

	//sprintf(Requete1,"SELECT Objet.NomObjet FROM Objet");
	sprintf(Requete1,"SELECT Attribut.NomAttribut FROM Attribut");
	sprintf(NomT,"TreillisStruct/%s.sqlite",(*T).NomTreillis);
	//result=RequeteBDD(NomT,Requete);
	rc1 = sqlite3_open(NomT, &db);
	if( rc1 ) {fprintf(stderr, "Can't open database: %s\n", sqlite3_errmsg(db));getc(stdin);}
	//else fprintf(stdout, "Opened database successfully\n");
	sqlite3_get_table(db,Requete1,&result1,&nrow1,&ncolumn1,&zErrMsg);
	//sqlite3_get_table(db,Requete2,&result2,&nrow2,&ncolumn2,&zErrMsg);
	//Requete2=Requete1;
	result2=result1;
	nrow2=nrow1;
	//ncolumn2=ncolumn1;

	/*                            //Pour chaque application tout seul
	for(l1=1;l1<=nrow1;l1++)
	{
		sprintf(chemin, "EtudiantsMesuresStrategies/%s/GeneralisationMesureSimApp/O=%c S=%c/B=%s/Impact_%s.csv",NE,O,S,beta, result1[l1]);
		FSimApp = fopen(chemin,"w");

		for(l2=1;l2<=nrow2;l2++)
		{
			if(Matrix[l1-1][l2-1]<0 || Matrix[l1-1][l2-1] >1 )
			{
				printf("%s  %s\n %d - %d \n %f\n",result1[l1], result2[l2],l1-1, l2-1,Matrix[l1-1][l2-1]);
				getc(stdin);
			}
			fprintf(FSimApp,"%s;%f\n",result2[l2],Matrix[l1-1][l2-1]);
		}
		fclose(FSimApp);
	}

	*/

	sprintf(chemin, "EtudiantsMesuresStrategies/%s/GeneralisationMesureSimContex/O=%c S=%c/SimContex.csv",NE,O,S);
	FSimContex = fopen(chemin,"w");
	for(l2=1;l2<=nrow2;l2++) fprintf(FSimContex,";%s",result2[l2]);
	for(l1=1;l1<=nrow1;l1++)                                         // Matrix d'impact
	{
		fprintf(FSimContex,"\n");
		fprintf(FSimContex,"%s",result1[l1]);
		for(l2=1;l2<=nrow2;l2++)
		{
			if(Matrix[l1-1][l2-1]<0 || Matrix[l1-1][l2-1] >1 )
			{
				printf("%s  %s\n %d - %d \n %f\n",result1[l1], result2[l2],l1-1, l2-1,Matrix[l1-1][l2-1]);
				getc(stdin);
			}
			fprintf(FSimContex,";%f",Matrix[l1-1][l2-1]);
		}

	}
	fclose(FSimContex);

	//for(l2=1;l2<=nrow2;l2++)   Pour lire les resultat de la requete
	//{
	//	for(c=0;c<ncolumn2;c++)
	//		printf("%s\t",result2[l2*ncolumn2+c]);
	//	printf("\n");
	//}
	sqlite3_close(db);
	sqlite3_free_table(result1);
	//sqlite3_free_table(result2);
	delete[] chemin;
	delete[] NomT;
	delete[] Requete1;
	//delete[] Requete2;
}

void ConstruireFichierSimContexMSE(Treillis *T,char *NE, float Matrix[33][33],char O,char S,char beta[6])
{
  int rc1;//, rc2;
  int nrow1, nrow2;
  int ncolumn1;//, ncolumn2;
  int l1, l2;
  //int c;
	char *Requete1=NULL;
	//char *Requete2=NULL;
	char *NomT=NULL;
	char ** result1;
	char ** result2;
	sqlite3 *db;
	char *zErrMsg = 0;
	char *chemin=NULL;
	FILE* FSimContex = NULL;
	chemin=(char*)malloc(150*sizeof(char));
	NomT=(char*)malloc(50*sizeof(char));
	Requete1=(char*)malloc(50*sizeof(char));
	//Requete2=(char*)malloc(50*sizeof(char));

	//sprintf(Requete1,"SELECT Objet.NomObjet FROM Objet");
	sprintf(Requete1,"SELECT Attribut.NomAttribut FROM Attribut");
	sprintf(NomT,"TreillisStruct/%s.sqlite",(*T).NomTreillis);
	//result=RequeteBDD(NomT,Requete);
	rc1 = sqlite3_open(NomT, &db);
	if( rc1 ) {fprintf(stderr, "Can't open database: %s\n", sqlite3_errmsg(db));getc(stdin);}
	//else fprintf(stdout, "Opened database successfully\n");
	sqlite3_get_table(db,Requete1,&result1,&nrow1,&ncolumn1,&zErrMsg);
	//sqlite3_get_table(db,Requete2,&result2,&nrow2,&ncolumn2,&zErrMsg);
	//Requete2=Requete1;
	result2=result1;
	nrow2=nrow1;
	//ncolumn2=ncolumn1;

	for(l1=1;l1<nrow1;l1++)
	{
		for(l2=l1+1;l2<=nrow2;l2++)
		{
			if(result1[l1][0]<result2[l2][0]) // Par ordre alphabétique pour eliminer le combinaison symetrique
				sprintf(chemin, "MesuresStrategiesEtudiants/GeneralisationMesureSimContex/O=%c S=%c/B=%s/Sim_%s_%s.csv",O,S,beta, result1[l1], result2[l2]);
			else
				sprintf(chemin, "MesuresStrategiesEtudiants/GeneralisationMesureSimContex/O=%c S=%c/B=%s/Sim_%s_%s.csv",O,S,beta, result1[l2], result2[l1]);

			FSimContex = fopen(chemin,"a");
			if(Matrix[l1-1][l2-1]<0 || Matrix[l1-1][l2-1] >1 )
			{
				printf("%s  %s\n %d - %d \n %f\n",result1[l1], result2[l2],l1-1, l2-1,Matrix[l1-1][l2-1]);
				getc(stdin);
			}
			fprintf(FSimContex,"%s;%f\n",NE,Matrix[l1-1][l2-1]);
			fclose(FSimContex);
		}
	}
	//for(l2=0;l2<=nrow2;l2++)   Pour lire les resultat de la requete
	//{
	//	for(c=0;c<ncolumn2;c++)
	//		printf("%s\t",result2[l2*ncolumn2+c]);
	//	printf("\n");
	//}
	sqlite3_close(db);
	sqlite3_free_table(result1);
	//sqlite3_free_table(result2);  // il n'y a pas result 2
	delete[] chemin;
	delete[] NomT;
	delete[] Requete1;
	//delete[] Requete2; // deja le Requete 1 est supprime
}

void ConstruireFichierSimContexMSE_NN(Treillis *T,char *NE, float Matrix[33][33],char O,char S)
{
  int rc1;//, rc2;
  int nrow1, nrow2;
  int ncolumn1;//, ncolumn2;
  int l1, l2;
  //int c;
	char *Requete1=NULL;
	//char *Requete2=NULL;
	char *NomT=NULL;
	char ** result1;
	char ** result2;
	sqlite3 *db;
	char *zErrMsg = 0;
	char *chemin=NULL;
	FILE* FSimContex = NULL;
	chemin=(char*)malloc(150*sizeof(char));
	NomT=(char*)malloc(50*sizeof(char));
	Requete1=(char*)malloc(50*sizeof(char));
	//Requete2=(char*)malloc(50*sizeof(char));

	//sprintf(Requete1,"SELECT Objet.NomObjet FROM Objet");
	sprintf(Requete1,"SELECT Attribut.NomAttribut FROM Attribut");
	sprintf(NomT,"TreillisStruct/%s.sqlite",(*T).NomTreillis);
	//result=RequeteBDD(NomT,Requete);
	rc1 = sqlite3_open(NomT, &db);
	if( rc1 ) {fprintf(stderr, "Can't open database: %s\n", sqlite3_errmsg(db));getc(stdin);}
	//else fprintf(stdout, "Opened database successfully\n");
	sqlite3_get_table(db,Requete1,&result1,&nrow1,&ncolumn1,&zErrMsg);
	//sqlite3_get_table(db,Requete2,&result2,&nrow2,&ncolumn2,&zErrMsg);
	//Requete2=Requete1;
	result2=result1;
	nrow2=nrow1;
	//ncolumn2=ncolumn1;

	for(l1=1;l1<nrow1;l1++)
	{
		for(l2=l1+1;l2<=nrow2;l2++)
		{
			if(result1[l1][0]<result2[l2][0]) // Par ordre alphabétique pour eliminer le combinaison symetrique
				sprintf(chemin, "MesuresStrategiesEtudiants/GeneralisationMesureSimContex/O=%c S=%c/Sim_%s_%s.csv",O,S, result1[l1], result2[l2]);
			else
				sprintf(chemin, "MesuresStrategiesEtudiants/GeneralisationMesureSimContex/O=%c S=%c/Sim_%s_%s.csv",O,S, result1[l2], result2[l1]);

			FSimContex = fopen(chemin,"a");
			if(Matrix[l1-1][l2-1]<0 || Matrix[l1-1][l2-1] >1 )
			{
				printf("%s  %s\n %d - %d \n %f\n",result1[l1], result2[l2],l1-1, l2-1,Matrix[l1-1][l2-1]);
				getc(stdin);
			}
			fprintf(FSimContex,"%s;%f\n",NE,Matrix[l1-1][l2-1]);
			fclose(FSimContex);
		}
	}
	//for(l2=0;l2<=nrow2;l2++)   Pour lire les resultat de la requete
	//{
	//	for(c=0;c<ncolumn2;c++)
	//		printf("%s\t",result2[l2*ncolumn2+c]);
	//	printf("\n");
	//}
	sqlite3_close(db);
	sqlite3_free_table(result1);
	//sqlite3_free_table(result2);  // il n'y a pas result 2
	delete[] chemin;
	delete[] NomT;
	delete[] Requete1;
	//delete[] Requete2; // deja le Requete 1 est supprime
}

void GeneralisationMesureSimContex()
{
	int i=0,j=0,k=0,h=0;
	char *NE;
	char beta[6];
	//char beta0[]="0,00";
	char beta025[]="0,25";
	char beta05[]="0,50";
	char beta075[]="0,75";
	char beta1[]="1,00";

	char Nomfichier[650][20];
	char MatrixTreillis[650][30];
	float Matrix[33][33];

	FILE* TreillisXML = NULL;
	FILE * MatrixT = NULL;
	Treillis *T;

	NE=(char*)malloc(4*sizeof(char));

	for(i=1;i<602;i++)
	{
		sprintf(Nomfichier[i],"Treillis/T (%d).xml",i);
		sprintf(MatrixTreillis[i],"TreillisStruct/MatrixTreillis %d",i);
		TreillisXML = fopen(Nomfichier[i], "r");
		MatrixT = fopen(MatrixTreillis[i], "rb");
		printf("T%d\n",i);
		if (TreillisXML != NULL && MatrixT != NULL)
		{
			T=(Treillis*)malloc(1*sizeof(Treillis));
			T = ConstruireStructTreillis(i,TreillisXML);
			ReadMatrix(i,(*T).NbrObjets,(*T).NbrAttributs,4,Matrix);   // 1: Imapct Absolu / 2: Imapct Relatif / 3: SIM App / 4: SIM Context
			j=0;
			k=0;
			NE[0]='\0';NE[1]='\0';NE[2]='\0';
			beta[0]='\0';beta[1]='\0';beta[2]='\0';beta[3]='\0';beta[4]='\0';beta[5]='\0';
			NE[k]=(*T).NomTreillis[j];
			k++;j++;
			if((*T).NomTreillis[2]=='-')
			{
				NE[k]='0';k++;
			}
			while((*T).NomTreillis[j]!='-')
			{
				NE[k]=(*T).NomTreillis[j];
				j++;k++;
			}
			NE[k]='\0';
			while((*T).NomTreillis[j]!='=') j++;
			j++;
			if((*T).NomTreillis[j]=='O')
			{
				while((*T).NomTreillis[j]!='=') j++;
				j++;
				if((*T).NomTreillis[j]=='H')
				{
					while((*T).NomTreillis[j]!='=') j++;
					j++;
					for(h=0;h<5;h++)
					{
						beta[h]=(*T).NomTreillis[j];
						j++;
					}
					beta[5]='\0';

					if(strcmp(beta,beta025)==0)	  {   ConstruireFichierSimContexMSE(T,NE,Matrix,'O','H',beta); ConstruireFichierSimContexEMS(T,NE,Matrix,'O','H',beta);}

					else if (strcmp(beta,beta05)==0) { ConstruireFichierSimContexMSE(T,NE,Matrix,'O','H',beta); ConstruireFichierSimContexEMS(T,NE,Matrix,'O','H',beta);}

					else if (strcmp(beta,beta075)==0) {  ConstruireFichierSimContexMSE(T,NE,Matrix,'O','H',beta);	ConstruireFichierSimContexEMS(T,NE,Matrix,'O','H',beta);}

					else if (strcmp(beta,beta1)==0) {  ConstruireFichierSimContexMSE(T,NE,Matrix,'O','H',beta);	ConstruireFichierSimContexEMS(T,NE,Matrix,'O','H',beta);}

				}
				else if((*T).NomTreillis[j]=='B')
				{
					while((*T).NomTreillis[j]!='=') j++;
					j++;
					for(h=0;h<5;h++)
					{
						beta[h]=(*T).NomTreillis[j];
						j++;
					}
					beta[5]='\0';

					if(strcmp(beta,beta025)==0)	   {  ConstruireFichierSimContexMSE(T,NE,Matrix,'O','B',beta); ConstruireFichierSimContexEMS(T,NE,Matrix,'O','B',beta);}

					else if (strcmp(beta,beta05)==0) { ConstruireFichierSimContexMSE(T,NE,Matrix,'O','B',beta); ConstruireFichierSimContexEMS(T,NE,Matrix,'O','B',beta);}

					else if (strcmp(beta,beta075)==0) { ConstruireFichierSimContexMSE(T,NE,Matrix,'O','B',beta); ConstruireFichierSimContexEMS(T,NE,Matrix,'O','B',beta);}

					else if (strcmp(beta,beta1)==0) { ConstruireFichierSimContexMSE(T,NE,Matrix,'O','B',beta); ConstruireFichierSimContexEMS(T,NE,Matrix,'O','B',beta);}
				}
				else if((*T).NomTreillis[j]=='M')
				{
					while((*T).NomTreillis[j]!='=') j++;
					j++;
					for(h=0;h<5;h++)
					{
						beta[h]=(*T).NomTreillis[j];
						j++;
					}
					beta[5]='\0';

					if(strcmp(beta,beta025)==0)	   {  ConstruireFichierSimContexMSE(T,NE,Matrix,'O','M',beta); ConstruireFichierSimContexEMS(T,NE,Matrix,'O','M',beta);}

					else if (strcmp(beta,beta05)==0) { ConstruireFichierSimContexMSE(T,NE,Matrix,'O','M',beta); ConstruireFichierSimContexEMS(T,NE,Matrix,'O','M',beta);}

					else if (strcmp(beta,beta075)==0) { ConstruireFichierSimContexMSE(T,NE,Matrix,'O','M',beta); ConstruireFichierSimContexEMS(T,NE,Matrix,'O','M',beta);}

					else if (strcmp(beta,beta1)==0) { ConstruireFichierSimContexMSE(T,NE,Matrix,'O','M',beta); ConstruireFichierSimContexEMS(T,NE,Matrix,'O','M',beta);}
				}
			}
			else if((*T).NomTreillis[j]=='N')
			{
				while((*T).NomTreillis[j]!='=') j++;
				j++;
				if((*T).NomTreillis[j]=='H')
				{
					while((*T).NomTreillis[j]!='=') j++;
					j++;
					for(h=0;h<5;h++)
					{
						beta[h]=(*T).NomTreillis[j];
						j++;
					}
					beta[5]='\0';

					if(strcmp(beta,beta025)==0)	 {    ConstruireFichierSimContexMSE(T,NE,Matrix,'N','H',beta); ConstruireFichierSimContexEMS(T,NE,Matrix,'N','H',beta);}

					else if (strcmp(beta,beta05)==0) { ConstruireFichierSimContexMSE(T,NE,Matrix,'N','H',beta);  ConstruireFichierSimContexEMS(T,NE,Matrix,'N','H',beta);}

					else if (strcmp(beta,beta075)==0) { ConstruireFichierSimContexMSE(T,NE,Matrix,'N','H',beta);  ConstruireFichierSimContexEMS(T,NE,Matrix,'N','H',beta);}

					else if (strcmp(beta,beta1)==0) { ConstruireFichierSimContexMSE(T,NE,Matrix,'N','H',beta);  ConstruireFichierSimContexEMS(T,NE,Matrix,'N','H',beta);}

				}
				else if((*T).NomTreillis[j]=='B')
				{
					while((*T).NomTreillis[j]!='=') j++;
					j++;
					for(h=0;h<5;h++)
					{
						beta[h]=(*T).NomTreillis[j];
						j++;
					}
					beta[5]='\0';

					if(strcmp(beta,beta025)==0)	 {    ConstruireFichierSimContexMSE(T,NE,Matrix,'N','B',beta);  ConstruireFichierSimContexEMS(T,NE,Matrix,'N','B',beta);}

					else if (strcmp(beta,beta05)==0) { ConstruireFichierSimContexMSE(T,NE,Matrix,'N','B',beta);  ConstruireFichierSimContexEMS(T,NE,Matrix,'N','B',beta);}

					else if (strcmp(beta,beta075)==0) { ConstruireFichierSimContexMSE(T,NE,Matrix,'N','B',beta);  ConstruireFichierSimContexEMS(T,NE,Matrix,'N','B',beta);}

					else if (strcmp(beta,beta1)==0) { ConstruireFichierSimContexMSE(T,NE,Matrix,'N','B',beta);	 ConstruireFichierSimContexEMS(T,NE,Matrix,'N','B',beta);}
				}
				else if((*T).NomTreillis[j]=='M')
				{
					while((*T).NomTreillis[j]!='=') j++;
					j++;
					for(h=0;h<5;h++)
					{
						beta[h]=(*T).NomTreillis[j];
						j++;
					}
					beta[5]='\0';

					if(strcmp(beta,beta025)==0)	 {    ConstruireFichierSimContexMSE(T,NE,Matrix,'N','M',beta);  ConstruireFichierSimContexEMS(T,NE,Matrix,'N','M',beta);}

					else if (strcmp(beta,beta05)==0) { ConstruireFichierSimContexMSE(T,NE,Matrix,'N','M',beta);  ConstruireFichierSimContexEMS(T,NE,Matrix,'N','M',beta);}

					else if (strcmp(beta,beta075)==0) { ConstruireFichierSimContexMSE(T,NE,Matrix,'N','M',beta);  ConstruireFichierSimContexEMS(T,NE,Matrix,'N','M',beta);}

					else if (strcmp(beta,beta1)==0) { ConstruireFichierSimContexMSE(T,NE,Matrix,'N','M',beta);	 ConstruireFichierSimContexEMS(T,NE,Matrix,'N','M',beta);}
				}
				else if((*T).NomTreillis[j]=='N')
				{
					ConstruireFichierSimContexMSE_NN(T,NE,Matrix,'N','N'); ConstruireFichierSimContexEMS_NN(T,NE,Matrix,'N','N');
				}
			}
			delete[] (*T).Concepts;
			delete[] (*T).objets;
			delete[] (*T).Attributs;
			delete[] T;
			fclose(TreillisXML);
			fclose(MatrixT);
		}
		else
		{
			if (TreillisXML == NULL)
				printf("Impossible d'ouvrir le fichier XML de trellis\n");
			if (MatrixT == NULL)
				printf("Impossible d'ouvrir le fichier Matrix de trellis\n");
			getc(stdin);
		}
	}
	delete[] NE;
}

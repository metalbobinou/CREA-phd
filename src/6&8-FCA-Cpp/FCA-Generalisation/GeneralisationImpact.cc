#include "GeneralisationImpact.hh"

char ** RequeteBDD (char *NomT, char *Requete)
{
	int rc, nrow,ncolumn,i,j;
	sqlite3 *db;
	char *zErrMsg = 0;
	char ** result;

	rc = sqlite3_open(NomT, &db);

	if( rc )
	{fprintf(stderr, "Can't open database: %s\n", sqlite3_errmsg(db));getc(stdin);}
	else
	   fprintf(stdout, "Opened database successfully\n");

	sqlite3_get_table(db,Requete,&result,&nrow,&ncolumn,&zErrMsg);

	for(i=1;i<=nrow;i++)
	{
		for(j=0;j<ncolumn;j++)
			printf("%s\t",result[i*ncolumn+j]);
		printf("\n");
	}

	sqlite3_close(db);
	return result;
}

void ConstruireFichierImpactEMS(Treillis *T,char *NE, float Matrix[33][33],char O,char S,char beta[6]) // les impact dans le dossier EtudiantsMesuresStrategies
{
  int rc1;//, rc2;
  int nrow1, nrow2;
  int ncolumn1, ncolumn2;
  int l1, l2;
  //int c;
	char *Requete1=NULL;
	char *Requete2=NULL;
	char *NomT=NULL;
	char ** result1;
	char ** result2;
	sqlite3 *db;
	char *zErrMsg = 0;
	char *chemin=NULL;
	FILE* FImpact = NULL;

	chemin=(char*)malloc(150*sizeof(char));
	NomT=(char*)malloc(50*sizeof(char));
	Requete1=(char*)malloc(50*sizeof(char));
	Requete2=(char*)malloc(50*sizeof(char));

	sprintf(Requete1,"SELECT Objet.NomObjet FROM Objet");
	sprintf(Requete2,"SELECT Attribut.NomAttribut FROM Attribut");
	sprintf(NomT,"TreillisStruct/%s.sqlite",(*T).NomTreillis);
	//result=RequeteBDD(NomT,Requete);
	rc1 = sqlite3_open(NomT, &db);
	if( rc1 ) {fprintf(stderr, "Can't open database: %s\n", sqlite3_errmsg(db));getc(stdin);}
	//else fprintf(stdout, "Opened database successfully\n");
	sqlite3_get_table(db,Requete1,&result1,&nrow1,&ncolumn1,&zErrMsg);
	sqlite3_get_table(db,Requete2,&result2,&nrow2,&ncolumn2,&zErrMsg);

	/*                            //Pour chaque application tout seul
	for(l1=1;l1<=nrow1;l1++)
	{
		sprintf(chemin, "EtudiantsMesuresStrategies/%s/GeneralisationMesureImpact/O=%c S=%c/B=%s/Impact_%s.csv",NE,O,S,beta, result1[l1]);
		FImpact = fopen(chemin,"w");

		for(l2=1;l2<=nrow2;l2++)
		{
			if(Matrix[l1-1][l2-1]<0 || Matrix[l1-1][l2-1] >1 )
			{
				printf("%s  %s\n %d - %d \n %f\n",result1[l1], result2[l2],l1-1, l2-1,Matrix[l1-1][l2-1]);
				getc(stdin);
			}
			fprintf(FImpact,"%s;%f\n",result2[l2],Matrix[l1-1][l2-1]);
		}
		fclose(FImpact);
	}

	*/

	sprintf(chemin, "EtudiantsMesuresStrategies/%s/GeneralisationMesureImpact/O=%c S=%c/B=%s/Impact_mutuel_relatif.csv",NE,O,S,beta);
	FImpact = fopen(chemin,"w");
	for(l2=1;l2<=nrow2;l2++) fprintf(FImpact,";%s",result2[l2]);
	for(l1=1;l1<=nrow1;l1++)                                         // Matrix d'impact
	{
		fprintf(FImpact,"\n");
		fprintf(FImpact,"%s",result1[l1]);
		for(l2=1;l2<=nrow2;l2++)
		{
			if(Matrix[l1-1][l2-1]<0 || Matrix[l1-1][l2-1] >1 )
			{
				printf("%s  %s\n %d - %d \n %f\n",result1[l1], result2[l2],l1-1, l2-1,Matrix[l1-1][l2-1]);
				getc(stdin);
			}
			fprintf(FImpact,";%f",Matrix[l1-1][l2-1]);
		}

	}
	fclose(FImpact);
	//for(l2=1;l2<=nrow2;l2++)   Pour lire les resultat de la requete
	//{
	//	for(c=0;c<ncolumn2;c++)
	//		printf("%s\t",result2[l2*ncolumn2+c]);
	//	printf("\n");
	//}
	sqlite3_close(db);
	sqlite3_free_table(result1);
	sqlite3_free_table(result2);
	delete[] chemin;
	delete[] NomT;
	delete[] Requete1;
	delete[] Requete2;
}

void ConstruireFichierImpactEMS_NN(Treillis *T,char *NE, float Matrix[33][33],char O,char S) // les impact dans le dossier EtudiantsMesuresStrategies
{
  int rc1;//, rc2;
  int nrow1, nrow2;
  int ncolumn1, ncolumn2;
  int l1, l2;
  //int c;
	char *Requete1=NULL;
	char *Requete2=NULL;
	char *NomT=NULL;
	char ** result1;
	char ** result2;
	sqlite3 *db;
	char *zErrMsg = 0;
	char *chemin=NULL;
	FILE* FImpact = NULL;

	chemin=(char*)malloc(150*sizeof(char));
	NomT=(char*)malloc(50*sizeof(char));
	Requete1=(char*)malloc(50*sizeof(char));
	Requete2=(char*)malloc(50*sizeof(char));

	sprintf(Requete1,"SELECT Objet.NomObjet FROM Objet");
	sprintf(Requete2,"SELECT Attribut.NomAttribut FROM Attribut");
	sprintf(NomT,"TreillisStruct/%s.sqlite",(*T).NomTreillis);
	//result=RequeteBDD(NomT,Requete);
	rc1 = sqlite3_open(NomT, &db);
	if( rc1 ) {fprintf(stderr, "Can't open database: %s\n", sqlite3_errmsg(db));getc(stdin);}
	//else fprintf(stdout, "Opened database successfully\n");
	sqlite3_get_table(db,Requete1,&result1,&nrow1,&ncolumn1,&zErrMsg);
	sqlite3_get_table(db,Requete2,&result2,&nrow2,&ncolumn2,&zErrMsg);

	/*                            //Pour chaque application tout seul
	for(l1=1;l1<=nrow1;l1++)
	{
		sprintf(chemin, "EtudiantsMesuresStrategies/%s/GeneralisationMesureImpact/O=%c S=%c/B=%s/Impact_%s.csv",NE,O,S,beta, result1[l1]);
		FImpact = fopen(chemin,"w");

		for(l2=1;l2<=nrow2;l2++)
		{
			if(Matrix[l1-1][l2-1]<0 || Matrix[l1-1][l2-1] >1 )
			{
				printf("%s  %s\n %d - %d \n %f\n",result1[l1], result2[l2],l1-1, l2-1,Matrix[l1-1][l2-1]);
				getc(stdin);
			}
			fprintf(FImpact,"%s;%f\n",result2[l2],Matrix[l1-1][l2-1]);
		}
		fclose(FImpact);
	}

	*/

	sprintf(chemin, "EtudiantsMesuresStrategies/%s/GeneralisationMesureImpact/O=%c S=%c/Impact_mutuel_relatif.csv",NE,O,S);
	FImpact = fopen(chemin,"w");
	for(l2=1;l2<=nrow2;l2++) fprintf(FImpact,";%s",result2[l2]);
	for(l1=1;l1<=nrow1;l1++)                                         // Matrix d'impact
	{
		fprintf(FImpact,"\n");
		fprintf(FImpact,"%s",result1[l1]);
		for(l2=1;l2<=nrow2;l2++)
		{
			if(Matrix[l1-1][l2-1]<0 || Matrix[l1-1][l2-1] >1 )
			{
				printf("%s  %s\n %d - %d \n %f\n",result1[l1], result2[l2],l1-1, l2-1,Matrix[l1-1][l2-1]);
				getc(stdin);
			}
			fprintf(FImpact,";%f",Matrix[l1-1][l2-1]);
		}

	}
	fclose(FImpact);
	//for(l2=1;l2<=nrow2;l2++)   Pour lire les resultat de la requete
	//{
	//	for(c=0;c<ncolumn2;c++)
	//		printf("%s\t",result2[l2*ncolumn2+c]);
	//	printf("\n");
	//}
	sqlite3_close(db);
	sqlite3_free_table(result1);
	sqlite3_free_table(result2);
	delete[] chemin;
	delete[] NomT;
	delete[] Requete1;
	delete[] Requete2;
}


void ConstruireFichierImpactMSE(Treillis *T,char *NE, float Matrix[33][33],char O,char S,char beta[6])  // les impact dans dossier MesuresStrategiesEtudiants
{
  int rc1;//, rc2;
  int nrow1, nrow2;
  int ncolumn1, ncolumn2;
  int l1, l2;
  //int c;
	char *Requete1=NULL;
	char *Requete2=NULL;
	char *NomT=NULL;
	char ** result1;
	char ** result2;
	sqlite3 *db;
	char *zErrMsg = 0;
	char *chemin=NULL;
	FILE* FImpact = NULL;

	chemin=(char*)malloc(150*sizeof(char));
	NomT=(char*)malloc(50*sizeof(char));
	Requete1=(char*)malloc(50*sizeof(char));
	Requete2=(char*)malloc(50*sizeof(char));

	sprintf(Requete1,"SELECT Objet.NomObjet FROM Objet");
	sprintf(Requete2,"SELECT Attribut.NomAttribut FROM Attribut");
	sprintf(NomT,"TreillisStruct/%s.sqlite",(*T).NomTreillis);
	//result=RequeteBDD(NomT,Requete);
	rc1 = sqlite3_open(NomT, &db);
	if( rc1 ) {fprintf(stderr, "Can't open database: %s\n", sqlite3_errmsg(db));getc(stdin);}
	//else fprintf(stdout, "Opened database successfully\n");

	sqlite3_get_table(db,Requete1,&result1,&nrow1,&ncolumn1,&zErrMsg);
	sqlite3_get_table(db,Requete2,&result2,&nrow2,&ncolumn2,&zErrMsg);


	for(l1=1;l1<=nrow1;l1++)
	{
		for(l2=1;l2<=nrow2;l2++)
		{
			sprintf(chemin, "MesuresStrategiesEtudiants/GeneralisationMesureImpact/O=%c S=%c/B=%s/Impact_%s_%s.csv",O,S,beta, result1[l1], result2[l2]);
			FImpact = fopen(chemin,"a");
			if(Matrix[l1-1][l2-1]<0 || Matrix[l1-1][l2-1] >1 )
			{
				printf("%s  %s\n %d - %d \n %f\n",result1[l1], result2[l2],l1-1, l2-1,Matrix[l1-1][l2-1]);
				getc(stdin);
			}
			fprintf(FImpact,"%s;%f\n",NE,Matrix[l1-1][l2-1]);
			fclose(FImpact);
		}
	}
	//for(l2=1;l2<=nrow2;l2++)   Pour lire les resultat de la requete
	//{
	//	for(c=0;c<ncolumn2;c++)
	//		printf("%s\t",result2[l2*ncolumn2+c]);
	//	printf("\n");
	//}
	sqlite3_close(db);
	sqlite3_free_table(result1);
	sqlite3_free_table(result2);
	delete[] chemin;
	delete[] NomT;
	delete[] Requete1;
	delete[] Requete2;
}

void ConstruireFichierImpactMSE_NN(Treillis *T,char *NE, float Matrix[33][33],char O,char S)  // les impact dans dossier MesuresStrategiesEtudiants
{
  int rc1;//, rc2;
  int nrow1, nrow2;
  int ncolumn1, ncolumn2;
  int l1, l2;
  //int c;
	char *Requete1=NULL;
	char *Requete2=NULL;
	char *NomT=NULL;
	char ** result1;
	char ** result2;
	sqlite3 *db;
	char *zErrMsg = 0;
	char *chemin=NULL;
	FILE* FImpact = NULL;

	chemin=(char*)malloc(150*sizeof(char));
	NomT=(char*)malloc(50*sizeof(char));
	Requete1=(char*)malloc(50*sizeof(char));
	Requete2=(char*)malloc(50*sizeof(char));

	sprintf(Requete1,"SELECT Objet.NomObjet FROM Objet");
	sprintf(Requete2,"SELECT Attribut.NomAttribut FROM Attribut");
	sprintf(NomT,"TreillisStruct/%s.sqlite",(*T).NomTreillis);
	//result=RequeteBDD(NomT,Requete);
	rc1 = sqlite3_open(NomT, &db);
	if( rc1 ) {fprintf(stderr, "Can't open database: %s\n", sqlite3_errmsg(db));getc(stdin);}
	//else fprintf(stdout, "Opened database successfully\n");

	sqlite3_get_table(db,Requete1,&result1,&nrow1,&ncolumn1,&zErrMsg);
	sqlite3_get_table(db,Requete2,&result2,&nrow2,&ncolumn2,&zErrMsg);


	for(l1=1;l1<=nrow1;l1++)
	{
		for(l2=1;l2<=nrow2;l2++)
		{
			sprintf(chemin, "MesuresStrategiesEtudiants/GeneralisationMesureImpact/O=%c S=%c/Impact_%s_%s.csv",O,S, result1[l1], result2[l2]);
			FImpact = fopen(chemin,"a");
			if(Matrix[l1-1][l2-1]<0 || Matrix[l1-1][l2-1] >1 )
			{
				printf("%s  %s\n %d - %d \n %f\n",result1[l1], result2[l2],l1-1, l2-1,Matrix[l1-1][l2-1]);
				getc(stdin);
			}
			fprintf(FImpact,"%s;%f\n",NE,Matrix[l1-1][l2-1]);
			fclose(FImpact);
		}
	}
	//for(l2=1;l2<=nrow2;l2++)   Pour lire les resultat de la requete
	//{
	//	for(c=0;c<ncolumn2;c++)
	//		printf("%s\t",result2[l2*ncolumn2+c]);
	//	printf("\n");
	//}
	sqlite3_close(db);
	sqlite3_free_table(result1);
	sqlite3_free_table(result2);
	delete[] chemin;
	delete[] NomT;
	delete[] Requete1;
	delete[] Requete2;
}

void GeneralisationMesureImpact()
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



	for(i=653;i<654;i++)      // 1->653   80->162   162->336  336->602  603
	{
		NE=(char*)malloc(4*sizeof(char));
		sprintf(Nomfichier[i],"Treillis/T (%d).xml",i);
		sprintf(MatrixTreillis[i],"TreillisStruct/MatrixTreillis %d",i);
		TreillisXML = fopen(Nomfichier[i], "r");
		MatrixT = fopen(MatrixTreillis[i], "rb");
		printf("T%d\n",i);
		if (TreillisXML != NULL && MatrixT != NULL)
		{
			T=(Treillis*)malloc(1*sizeof(Treillis));
			T = ConstruireStructTreillis(i,TreillisXML);

			ReadMatrix(i,(*T).NbrObjets,(*T).NbrAttributs,2,Matrix);   // 1: Imapct Absolu / 2: Imapct Relatif / 3: SIM App / 4: SIM Context

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

					if(strcmp(beta,beta025)==0)	{ConstruireFichierImpactMSE(T,NE,Matrix,'O','H',beta); ConstruireFichierImpactEMS(T,NE,Matrix,'O','H',beta); }

					else if (strcmp(beta,beta05)==0) { ConstruireFichierImpactMSE(T,NE,Matrix,'O','H',beta); ConstruireFichierImpactEMS(T,NE,Matrix,'O','H',beta); }

					else if (strcmp(beta,beta075)==0) { ConstruireFichierImpactMSE(T,NE,Matrix,'O','H',beta); ConstruireFichierImpactEMS(T,NE,Matrix,'O','H',beta); }

					else if (strcmp(beta,beta1)==0) { ConstruireFichierImpactMSE(T,NE,Matrix,'O','H',beta); ConstruireFichierImpactEMS(T,NE,Matrix,'O','H',beta); }

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

					if(strcmp(beta,beta025)==0)	{ConstruireFichierImpactMSE(T,NE,Matrix,'O','B',beta); ConstruireFichierImpactEMS(T,NE,Matrix,'O','B',beta); }

					else if (strcmp(beta,beta05)==0) { ConstruireFichierImpactMSE(T,NE,Matrix,'O','B',beta); ConstruireFichierImpactEMS(T,NE,Matrix,'O','B',beta); }

					else if (strcmp(beta,beta075)==0) { ConstruireFichierImpactMSE(T,NE,Matrix,'O','B',beta); ConstruireFichierImpactEMS(T,NE,Matrix,'O','B',beta); }

					else if (strcmp(beta,beta1)==0) { ConstruireFichierImpactMSE(T,NE,Matrix,'O','B',beta); ConstruireFichierImpactEMS(T,NE,Matrix,'O','B',beta); }
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

					if(strcmp(beta,beta025)==0)	{ConstruireFichierImpactMSE(T,NE,Matrix,'O','M',beta); ConstruireFichierImpactEMS(T,NE,Matrix,'O','M',beta); }

					else if (strcmp(beta,beta05)==0) { ConstruireFichierImpactMSE(T,NE,Matrix,'O','M',beta); ConstruireFichierImpactEMS(T,NE,Matrix,'O','M',beta); }

					else if (strcmp(beta,beta075)==0) { ConstruireFichierImpactMSE(T,NE,Matrix,'O','M',beta); ConstruireFichierImpactEMS(T,NE,Matrix,'O','M',beta); }

					else if (strcmp(beta,beta1)==0) { ConstruireFichierImpactMSE(T,NE,Matrix,'O','M',beta); ConstruireFichierImpactEMS(T,NE,Matrix,'O','M',beta); }

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

					if(strcmp(beta,beta025)==0)	{ConstruireFichierImpactMSE(T,NE,Matrix,'N','H',beta); ConstruireFichierImpactEMS(T,NE,Matrix,'N','H',beta); }

					else if (strcmp(beta,beta05)==0) { ConstruireFichierImpactMSE(T,NE,Matrix,'N','H',beta); ConstruireFichierImpactEMS(T,NE,Matrix,'N','H',beta); }

					else if (strcmp(beta,beta075)==0) { ConstruireFichierImpactMSE(T,NE,Matrix,'N','H',beta); ConstruireFichierImpactEMS(T,NE,Matrix,'N','H',beta); }

					else if (strcmp(beta,beta1)==0) { ConstruireFichierImpactMSE(T,NE,Matrix,'N','H',beta); ConstruireFichierImpactEMS(T,NE,Matrix,'N','H',beta); }

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

					if(strcmp(beta,beta025)==0)	{ConstruireFichierImpactMSE(T,NE,Matrix,'N','B',beta); ConstruireFichierImpactEMS(T,NE,Matrix,'N','B',beta); }

					else if (strcmp(beta,beta05)==0) { ConstruireFichierImpactMSE(T,NE,Matrix,'N','B',beta); ConstruireFichierImpactEMS(T,NE,Matrix,'N','B',beta); }

					else if (strcmp(beta,beta075)==0) { ConstruireFichierImpactMSE(T,NE,Matrix,'N','B',beta); ConstruireFichierImpactEMS(T,NE,Matrix,'N','B',beta); }

					else if (strcmp(beta,beta1)==0) { ConstruireFichierImpactMSE(T,NE,Matrix,'N','B',beta); ConstruireFichierImpactEMS(T,NE,Matrix,'N','B',beta); }

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

					if(strcmp(beta,beta025)==0)	{ConstruireFichierImpactMSE(T,NE,Matrix,'N','M',beta); ConstruireFichierImpactEMS(T,NE,Matrix,'N','M',beta); }

					else if (strcmp(beta,beta05)==0) { ConstruireFichierImpactMSE(T,NE,Matrix,'N','M',beta); ConstruireFichierImpactEMS(T,NE,Matrix,'N','M',beta); }

					else if (strcmp(beta,beta075)==0) { ConstruireFichierImpactMSE(T,NE,Matrix,'N','M',beta); ConstruireFichierImpactEMS(T,NE,Matrix,'N','M',beta); }

					else if (strcmp(beta,beta1)==0) { ConstruireFichierImpactMSE(T,NE,Matrix,'N','M',beta); ConstruireFichierImpactEMS(T,NE,Matrix,'N','M',beta); }

				}
				else if((*T).NomTreillis[j]=='N')
				{
					ConstruireFichierImpactMSE_NN(T,NE,Matrix,'N','N'); ConstruireFichierImpactEMS_NN(T,NE,Matrix,'N','N');
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
		delete[] NE;
	}

}

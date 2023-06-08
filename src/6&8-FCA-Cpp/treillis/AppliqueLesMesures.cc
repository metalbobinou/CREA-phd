#include "AppliqueLesMesures.hh"

static int callback(void *data, int nbCol, char **argv, char **azColName)
{
   int i;
   for(i=0; i<nbCol; i++)
   {
      printf("%s = %s\n", azColName[i], argv[i] ? argv[i] : "NULL");

   }
   printf("\n");
   return 0;

   // Delete some warnings
   data = NULL;
   (void)data;
}

void fwriteStructTreillis (Treillis * T)
{
	char StructTreillis [40];
	FILE* TreillisStruct = NULL;
	sprintf(StructTreillis,"TreillisStruct/TreillisStruct %d",(*T).IdTreillis);
	TreillisStruct = fopen(StructTreillis, "w");

	fprintf(TreillisStruct,"%d\n",(*T).IdTreillis);
	fprintf(TreillisStruct,"%s\n",(*T).NomTreillis);
	fprintf(TreillisStruct,"%d\n",(*T).NbrConcepts);
	fprintf(TreillisStruct,"%d\n",(*T).NbrObjets);
	fprintf(TreillisStruct,"%d\n",(*T).NbrAttributs);
	fprintf(TreillisStruct,"%d\n",(*T).NbrRelations);
	fprintf(TreillisStruct,"%d\n",(*T).NbrNiveau);
//	fprintf(TreillisStruct,"%d\n",(*T).Largeur);
//	fprintf(TreillisStruct,"%d\n",(*T).IdNiveauL);
	fprintf(TreillisStruct,"%f\n",(*T).densite);
	fprintf(TreillisStruct,"%f\n",(*T).densiteConcepts);
//	fprintf(TreillisStruct,"%f\n",(*T).Taille);
//	fprintf(TreillisStruct,"%d\n",(*T).SurfaceMax);
//	fprintf(TreillisStruct,"%f\n",(*T).ComplexiteTreillis);
//	fprintf(TreillisStruct,"%f\n",(*T).LargeurNormalisee);
//	fprintf(TreillisStruct,"%f\n",(*T).LargeurNormaliseeBis);
//	fprintf(TreillisStruct,"%f\n",(*T).LargeurNormaliseeBis2);
//	fprintf(TreillisStruct,"%f\n",(*T).HauteurNormalisee);
//	fprintf(TreillisStruct,"%f\n",(*T).HauteurNormaliseeBis);
//	fprintf(TreillisStruct,"%f\n",(*T).HauteurNormaliseeBis2);
//	fprintf(TreillisStruct,"%f\n",(*T).pertinence);
	fprintf(TreillisStruct,"%f\n",(*T).MoyenneNbrObj);
	fprintf(TreillisStruct,"%f\n",(*T).MoyenneNbrAtt);
	fprintf(TreillisStruct,"%f\n",(*T).MoyenneNbrPar);
	fprintf(TreillisStruct,"%f\n",(*T).MoyenneNbrFils);
	fprintf(TreillisStruct,"%f\n",(*T).MoyenneTailleConcept);
//  fprintf(TreillisStruct,"%d\n",(*T).NbrParMax);
//	fprintf(TreillisStruct,"%d\n",(*T).NbrFilsMax);
	fclose(TreillisStruct);
}


void ImprimerConcepts (Treillis * T,FILE* F)
{
	int i,j;
	fprintf(F,"Nom de treillis : %s\n\n",(*T).NomTreillis);
	fprintf(F,"Nombre d'Objet : %d\n\n",(*T).NbrObjets);
	fprintf(F,"Nombre d'Attribut : %d\n\n",(*T).NbrAttributs);
	fprintf(F,"Nombre de Concepts : %d\n\n",(*T).NbrConcepts);
	fprintf(F,"Nombre de Relations : %d\n\n",(*T).NbrRelations);

	fprintf(F,"Nombre de niveau : %d\n\n",(*T).NbrNiveau);

	//fprintf(F,"Hauteur normalisee en focntion de Nbr de concept : %f\n\n",(*T).HauteurNormalisee);
	//fprintf(F,"Hauteur normalisee en fonction de NbrO et NbrA  : %f\n\n",(*T).HauteurNormaliseeBis);
	//fprintf(F,"Largeur : %d\n\n",(*T).Largeur);
	//fprintf(F,"Largeur normalisee en focntion de Nbr de concept : %f\n\n",(*T).LargeurNormalisee);
	//fprintf(F,"Largeur normalisee en fonction de NbrO et NbrA : %f\n\n",(*T).LargeurNormaliseeBis);
	//fprintf(F,"SurfaceMax : %d\n\n",(*T).SurfaceMax);
	//fprintf(F,"Taille : %f\n\n",(*T).Taille);
	//fprintf(F,"ComplexiteTreillis : %f\n\n",(*T).ComplexiteTreillis);
	//fprintf(F,"Densite Trellis : %f\n\n",(*T).densite);
	//fprintf(F,"Densite Trellis en fonction des concepts  : %f\n\n",(*T).densiteConcepts);
	//fprintf(F,"Pertinence Trellis : %f\n\n",(*T).pertinence);

	//fprintf(F,"Combianaison : %d\n\n", Nbrcombinaison(10));
	fprintf(F,"--------------------------------------\n");
	fprintf(F,"les objets avec les poids\n\n");
	/*
	for(i=0;i<(*T).NbrObjets;i++)
	{
		fprintf(F,"Id= %d  %s (poids = %f) (poidsbis = %f) appartient a %d concepts qui sont : ",(*T).objets[i].IdObjet,(*T).objets[i].NomObjet,(*T).objets[i].poids,(*T).objets[i].poidsbis,(*T).objets[i].NbrConceptsAppartient);
		for(j=0;j<(*T).objets[i].NbrConceptsAppartient;j++)
			fprintf(F," %d ",(*T).objets[i].IdConceptsAppartient[j]);
		fprintf(F,"\n\n");
	}
	*/
	for(i=0;i<(*T).NbrObjets;i++)
	{
		fprintf(F,"%s;%f\n",(*T).objets[i].NomObjet,(*T).objets[i].poids);
	}

	fprintf(F,"--------------------------------------\n");
	fprintf(F,"les attributs avec le poids\n\n");
	/*
	for(i=0;i<(*T).NbrAttributs;i++)
	{
		fprintf(F,"Id= %d  %s (poids = %f) (poidsbis = %f) appartient a %d concepts qui sont : ",(*T).Attributs[i].IdAttribut,(*T).Attributs[i].NomAttribut,(*T).Attributs[i].poids,(*T).Attributs[i].poidsbis,(*T).Attributs[i].NbrConceptsAppartient);
		for(j=0;j<(*T).Attributs[i].NbrConceptsAppartient;j++)
			fprintf(F," %d ",(*T).Attributs[i].IdConceptsAppartient[j]);
		fprintf(F,"\n\n");
	}
	*/
	for(i=0;i<(*T).NbrAttributs;i++)
	{
		fprintf(F,"%s;%f\n",(*T).Attributs[i].NomAttribut,(*T).Attributs[i].poids);
	}

	fprintf(F,"--------------------------------------\n");
	fprintf(F,"les concepts avec le nombre de parent et de fils et les details sont :\n\n");
	fprintf(F,"--------------------------------------\n");

	/*

	for(i=0;i<(*T).NbrConcepts;i++)
	{
		fprintf(F,"Id concept :%d \t Nombre de objets :%d \t Proportion de Nbr objets :%f \t Nombre de attributs :%d \t Proportion de Nbr attributs :%f \n\n",(*T).Concepts[i].idConcept, (*T).Concepts[i].NbrObjets, (*T).Concepts[i].ProportionObj,(*T).Concepts[i].NbrAttributs,(*T).Concepts[i].ProportionAtt);
		fprintf(F,"Objets :\t");
		for(j=0;j<(*T).Concepts[i].NbrObjets;j++)
			fprintf(F,"%s\t",(*T).Concepts[i].objets[j].NomObjet);
		fprintf(F,"\n\nAttributs :\t");
		for(j=0;j<(*T).Concepts[i].NbrAttributs;j++)
			fprintf(F,"%s\t",(*T).Concepts[i].Attributs[j].NomAttribut);
		fprintf(F,"\n\nLe nombre de concept parent :%d \t Proportion de Nbr concept parent %f\n\n",(*T).Concepts[i].NbrParents, (*T).Concepts[i].ProportionParents);
		if((*T).Concepts[i].NbrParents != 0)
		{
			fprintf(F,"les Ids de concepts parent:\t");
			for(j=0;j<(*T).Concepts[i].NbrParents;j++)
				fprintf(F,"%d\t",(*T).Concepts[i].idConceptParents[j]);
			fprintf(F,"\n\n");
		}
		fprintf(F,"Le nombre de concept fils :%d \t Proportion de Nbr concept fils %f\n\n",(*T).Concepts[i].NbrFils, (*T).Concepts[i].ProportionFils);
		if((*T).Concepts[i].NbrFils != 0)
		{
			fprintf(F,"les Ids de concepts fils\t");
			for(j=0;j<(*T).Concepts[i].NbrFils;j++)
				fprintf(F,"%d\t",(*T).Concepts[i].idConceptfils[j]);
			fprintf(F,"\n\n");
		}
//		fprintf(F,"Le nombre de tout les concepts fils :%d\n\n",(*T).Concepts[i].NbrFilsInf);
		fprintf(F,"Taille de concept :%d\n\n",(*T).Concepts[i].TailleConcept);
//		fprintf(F,"Equilibre de concept :%f\n\n",(*T).Concepts[i].equilibre);
		fprintf(F,"Niveau de concept :%d\n\n",(*T).Concepts[i].niv);
		fprintf(F,"--------------------------------------\n");
	}

	*/
	//  /*
		for(i=0;i<(*T).NbrConcepts;i++)
	{
		fprintf(F,"\n\nId concept;%d\n",(*T).Concepts[i].idConcept);
		fprintf(F,"Objets");
		for(j=0;j<(*T).Concepts[i].NbrObjets;j++)
			fprintf(F,";%s",(*T).Concepts[i].objets[j].NomObjet);
		fprintf(F,"\nAttributs");
		for(j=0;j<(*T).Concepts[i].NbrAttributs;j++)
			fprintf(F,";%s",(*T).Concepts[i].Attributs[j].NomAttribut);
	}
	fprintf(F,"\n--------------------------------------\n");
	// */


	fprintf(F,"Moyenne Nbr Obj : %f \n\n",(*T).MoyenneNbrObj);
	fprintf(F,"Moyenne Nbr Att : %f \n\n", (*T).MoyenneNbrAtt);
	fprintf(F,"Moyenne Nbr Parent : %f \n\n", (*T).MoyenneNbrPar);
	fprintf(F,"Moyenne Nbr Fils : %f \n\n", (*T).MoyenneNbrFils);
	fprintf(F,"Moyenne Taille concepts : %f \n\n", (*T).MoyenneTailleConcept);
//	fprintf(F,"Nbr Parent Max : %d\n\n",(*T).NbrParMax);
//	fprintf(F,"Nbr Fils Max : %d\n\n",(*T).NbrFilsMax);
//	fprintf(F,"Id concept Parent Max : %d\n\n",(*T).ConcParMax.idConcept);
//	fprintf(F,"Id concept Fils Max : %d\n\n",(*T).ConcFilsMax.idConcept);

/*	for(i=0;i<=(*T).NbrNiveau;i++)
	{
		fprintf(F," Niveau %d \t", i);
		for (j=0; j<(*T).Niveaux[i].NbrConcepts;j++)
			fprintf(F," %d \t",(*T).Niveaux[i].idConcepts[j]);
		fprintf(F," \n");
	}*/

	fprintf(F," \nImapct Absolu\n");
	fprintf(F,";");
	for(i=0;i<(*T).NbrAttributs;i++)
		fprintf(F,"%s ;",(*T).Attributs[i].NomAttribut);

	fprintf(F,"\n");
	for(i=0;i<(*T).NbrObjets;i++)
	{
		fprintf(F,"%s ;",(*T).objets[i].NomObjet);
		for(j=0;j<(*T).NbrAttributs;j++)
			fprintf(F,"%f ;",(*T).ObjetsAttributs[i][j]);
		fprintf(F,"\n");
	}

	///////////////
	/*
	fprintf(F,"\nImapct Relatif liste \n");

	for(i=0;i<(*T).NbrObjets;i++)
	{
		for(j=0;j<(*T).NbrAttributs;j++)
		{
			fprintf(F,"%s ;",(*T).objets[i].NomObjet);
			fprintf(F,"%s ;",(*T).Attributs[j].NomAttribut);
			fprintf(F,"%f ;",(*T).ObjetsAttributsRelatif[i][j]);
			fprintf(F,"\n");
		}
	}
	fprintf(F,"\n");
	*/
	//////////////////

	fprintf(F,"\nImapct Relatif\n");

	fprintf(F,";");
	for(i=0;i<(*T).NbrAttributs;i++)
		fprintf(F,"%s ;",(*T).Attributs[i].NomAttribut);
	fprintf(F,"\n");
	for(i=0;i<(*T).NbrObjets;i++)
	{
		fprintf(F,"%s ;",(*T).objets[i].NomObjet);
		for(j=0;j<(*T).NbrAttributs;j++)
			fprintf(F,"%f ;",(*T).ObjetsAttributsRelatif[i][j]);
		fprintf(F,"\n");
	}
	fprintf(F,"\n");


	////
		/*
	fprintf(F,"\nSim objets liste\n");
	for(i=0;i<(*T).NbrObjets;i++)
	{
		for(j=0;j<(*T).NbrObjets;j++)
		{
			fprintf(F,"%s ;",(*T).objets[i].NomObjet);
			fprintf(F,"%s ;",(*T).objets[j].NomObjet);
			fprintf(F,"%f ;",(*T).ObjetsObjets[i][j]);
			fprintf(F,"\n");
		}
	}
	fprintf(F,"\n");
	////
	*/


	fprintf(F,"\nSim objets\n");

	fprintf(F,";");
	for(i=0;i<(*T).NbrObjets;i++)
		fprintf(F,"%s ;",(*T).objets[i].NomObjet);
	fprintf(F,"\n");
	for(i=0;i<(*T).NbrObjets;i++)
	{
		fprintf(F,"%s ;",(*T).objets[i].NomObjet);
		for(j=0;j<(*T).NbrObjets;j++)
			fprintf(F,"%f ;",(*T).ObjetsObjets[i][j]);
		fprintf(F,"\n");
	}
	fprintf(F,"\n");


		/*
	fprintf(F,"\nL'objet avec maximum de 1 : %s\n",(*T).NomObjetMAX1);

	for(i=0;i<(*T).OOM;i++)
	{
		//printf("\n ligne %d i : %d j %d ObjetsObjetsMax %d\n",i,(*T).ObjetsObjetsMax[i][0],(*T).ObjetsObjetsMax[i][1],(*T).ObjetsObjetsMax[i][2]);getc(stdin);
		//printf("%s ; %s ; %d\n",(*T).objets[(*T).ObjetsObjetsMax[i][0]].NomObjet,(*T).objets[(*T).ObjetsObjetsMax[i][1]].NomObjet, (*T).ObjetsObjetsMax[i][2]);getc(stdin);
		fprintf(F,"%s ; %s ; %d\n",(*T).objets[(*T).ObjetsObjetsMax[i][0]].NomObjet,(*T).objets[(*T).ObjetsObjetsMax[i][1]].NomObjet, (*T).ObjetsObjetsMax[i][2]);
	}
	fprintf(F,"\n");

	fprintf(F,"\nSim Attributs\n");

	///

	for(i=0;i<(*T).NbrAttributs;i++)
	{
		for(j=0;j<(*T).NbrAttributs;j++)
		{
			fprintf(F,"%s ;",(*T).Attributs[i].NomAttribut);
			fprintf(F,"%s ;",(*T).Attributs[j].NomAttribut);
			fprintf(F,"%f ;",(*T).AttributsAttributs[i][j]);
			fprintf(F,"\n");
		}
	}
	fprintf(F,"\n");
	///

	*/

	fprintf(F,"\nSim Attributs\n");

	fprintf(F,";");
	for(i=0;i<(*T).NbrAttributs;i++)
		fprintf(F,"%s ;",(*T).Attributs[i].NomAttribut);
	fprintf(F,"\n");
	for(i=0;i<(*T).NbrAttributs;i++)
	{
		fprintf(F,"%s ;",(*T).Attributs[i].NomAttribut);
		for(j=0;j<(*T).NbrAttributs;j++)
			fprintf(F,"%f ;",(*T).AttributsAttributs[i][j]);
		fprintf(F,"\n");
	}
	fprintf(F,"\n");

}

void CalculerNbr (Treillis * T, FILE* TreillisR)
{
  int j=0;//,l;
	int p=0;
	int a=0;
	int NbrO=0;
	int NbrA=0;
	char ligne[100]="";
	char c[4];
	char *ptr;

	fgets(ligne, 100, TreillisR);   //premiere ligne
	fgets(ligne, 100, TreillisR);   // deuxieme ligne dans le fichier
	//l=strlen(ligne);
	while(ligne[j]!='#')
		j++;
	j=j+11;
	while(ligne[j]!='"')
	{
		c[p]=ligne[j];
		j++;
		p++;
	}
	a=strtol(c, &ptr,10);
	(*T).NbrConcepts=a;
	fgets(ligne, 90, TreillisR);
	fgets(ligne, 90, TreillisR);
	while (strstr(ligne, "</OBJS>")== NULL)
	{
		NbrO++;
		fgets(ligne, 90, TreillisR);
	}
	(*T).NbrObjets=NbrO;
	fgets(ligne, 90, TreillisR);
	fgets(ligne, 90, TreillisR);
	while (strstr(ligne, "</ATTS>")== NULL)
	{
		NbrA++;
		fgets(ligne, 90, TreillisR);
	}
	(*T).NbrAttributs=NbrA;
}

void ConstruireBDD (Treillis * T)
{
	sqlite3 *db;
	int rc, i, j;//, longueurChaine;
	char *zErrMsg = 0;
	const char *sql[8];
	char *Requete=NULL;
	char *NomT=NULL;

	Requete=(char*)malloc(100*sizeof(char));
	NomT=(char*)malloc(100*sizeof(char));

	sprintf(NomT,"TreillisStruct/%s.sqlite",(*T).NomTreillis);

	rc = sqlite3_open(NomT, &db);
	if( rc )
	   fprintf(stderr, "Can't open database: %s\n", sqlite3_errmsg(db));
	else
	   fprintf(stdout, "Opened database successfully\n");

	sql[0] = "CREATE TABLE Treillis("  \
	        "IdTreillis INT PRIMARY KEY NOT NULL, " \
			"NomTreillis  TEXT  NOT NULL," \
			"NbrConcepts  INT NOT NULL," \
			"NbrObjets  INT NOT NULL ," \
			"NbrAttributs INT NOT NULL );";

	sql[1] = "CREATE TABLE Concepts("  \
         "IdConcepts INT PRIMARY KEY NOT NULL," \
		 "NbrObjets  INT NOT NULL," \
         "NbrAttributs  INT NOT NULL," \
		 "IdTreillis  INT NOT NULL," \
		 "foreign key (IdTreillis) references Treillis);";

	sql[2] = "CREATE TABLE Objet("  \
         "IdObjet INT PRIMARY KEY NOT NULL," \
         "NomObjet  TEXT  NOT NULL,"\
		 "poids  FLOAT,"\
		 "poidsbis  FLOAT)";

	sql[3] = "CREATE TABLE Attribut("  \
         "IdAttribut INT PRIMARY KEY NOT NULL," \
         "NomAttribut  TEXT  NOT NULL,"\
		 "poids  FLOAT,"\
		 "poidsbis  FLOAT)";

	sql[4] = "CREATE TABLE TreillisObjet("  \
         "IdTreillis INT NOT NULL," \
         "IdObjet  INT NOT NULL ," \
		 "Primary key (IdTreillis, IdObjet)," \
		 "foreign key (IdTreillis) references Treillis," \
         "foreign key (IdObjet) references Objet);";

	sql[5] = "CREATE TABLE TreillisAttribut("  \
         "IdTreillis INT NOT NULL," \
         "IdAttribut  INT NOT NULL ," \
		 "Primary key (IdTreillis, IdAttribut)," \
		 "foreign key (IdTreillis) references Treillis," \
         "foreign key (IdAttribut) references Attribut);";

	sql[6] = "CREATE TABLE ConceptsObjet("  \
         "IdConcepts INT NOT NULL," \
         "IdObjet   INT NOT NULL ," \
		 "Primary key (IdConcepts, IdObjet)," \
		 "foreign key (IdConcepts) references Concepts," \
         "foreign key (IdObjet) references Objet);";

	sql[7] = "CREATE TABLE ConceptsAttribut("  \
         "IdConcepts INT NOT NULL," \
         "IdAttribut   INT NOT NULL ," \
		 "Primary key (IdConcepts, IdAttribut)," \
		 "foreign key (IdConcepts) references Concepts," \
         "foreign key (IdAttribut) references Attribut);";

	for(i=0;i<8;i++)
	{
		rc = sqlite3_exec(db, sql[i], callback, 0, &zErrMsg);
		if( rc != SQLITE_OK )
		{
		  fprintf(stderr, "SQL error: %s\n", zErrMsg);
		  sqlite3_free(zErrMsg);
		}
		//else
		//  fprintf(stdout, "Records created successfully\n");
	}

	sprintf(Requete,"INSERT INTO Treillis  VALUES (%d,'%s' ,%d ,%d,%d);",(*T).IdTreillis,(*T).NomTreillis,(*T).NbrConcepts,(*T).NbrObjets,(*T).NbrAttributs);
	rc = sqlite3_exec(db, Requete, callback, 0, &zErrMsg);

	for(i=0;i<(*T).NbrObjets;i++)
	{
		//printf("\n IdObjet %d  NomObjet %s  poids  %f poidsbis %f\n",(*T).objets[i].IdObjet,(*T).objets[i].NomObjet,(*T).objets[i].poids,(*T).objets[i].poidsbis);getc(stdin);
		sprintf(Requete,"INSERT INTO Objet  VALUES (%d,'%s',%f,%f);",(*T).objets[i].IdObjet,(*T).objets[i].NomObjet,(*T).objets[i].poids,(*T).objets[i].poidsbis);
		rc = sqlite3_exec(db, Requete, callback, 0, &zErrMsg);
		sprintf(Requete,"INSERT INTO TreillisObjet  VALUES (%d,%d);",(*T).IdTreillis,(*T).objets[i].IdObjet);
		rc = sqlite3_exec(db, Requete, callback, 0, &zErrMsg);
	}

	for(i=0;i<(*T).NbrAttributs;i++)
	{
		sprintf(Requete,"INSERT INTO Attribut  VALUES (%d,'%s',%f,%f);",(*T).Attributs[i].IdAttribut,(*T).Attributs[i].NomAttribut,(*T).Attributs[i].poids,(*T).Attributs[i].poidsbis);
		rc = sqlite3_exec(db, Requete, callback, 0, &zErrMsg);
		sprintf(Requete,"INSERT INTO TreillisAttribut  VALUES (%d,%d);",(*T).IdTreillis,(*T).Attributs[i].IdAttribut);
		rc = sqlite3_exec(db, Requete, callback, 0, &zErrMsg);
	}

	for(i=0;i<(*T).NbrConcepts;i++)
	{
		sprintf(Requete,"INSERT INTO Concepts  VALUES (%d,%d,%d,%d);",(*T).Concepts[i].idConcept,(*T).Concepts[i].NbrObjets,(*T).Concepts[i].NbrAttributs,(*T).IdTreillis);
		rc = sqlite3_exec(db, Requete, callback, 0, &zErrMsg);
	}

	for(i=0;i<(*T).NbrConcepts;i++)
		for(j=0;j<(*T).Concepts[i].NbrObjets;j++)
		{
			sprintf(Requete,"INSERT INTO ConceptsObjet  VALUES (%d,%d);",(*T).Concepts[i].idConcept,(*T).Concepts[i].objets[j].IdObjet);
			rc = sqlite3_exec(db, Requete, callback, 0, &zErrMsg);
		}

	for(i=0;i<(*T).NbrConcepts;i++)
		for(j=0;j<(*T).Concepts[i].NbrAttributs;j++)
		{
			sprintf(Requete,"INSERT INTO ConceptsAttribut  VALUES (%d,%d);",(*T).Concepts[i].idConcept,(*T).Concepts[i].Attributs[j].IdAttribut);
			rc = sqlite3_exec(db, Requete, callback, 0, &zErrMsg);
		}

	sqlite3_close(db);

}

Treillis * ConstruireStructTreillis (int NTreillis, FILE* TreillisXML)
{
	Treillis *T;
	//char Nomfichier[30];
	T=(Treillis*)malloc(1*sizeof(Treillis));
	CalculerNbr(T,TreillisXML);
	rewind(TreillisXML);    // place le curseur au debut du fichier // cette fonction remplace le deux ligne precedant
	(*T).IdTreillis=NTreillis;
	LireTreillisV2 (T,TreillisXML);

	return T;
}
void SaveMatrix (Treillis * T)
{
	char MatrixTreillis[40];
	FILE * MatrixT = NULL;
	sprintf(MatrixTreillis,"TreillisStruct/MatrixTreillis %d",(*T).IdTreillis);
	MatrixT = fopen (MatrixTreillis,"wb");
	fwrite((*T).ObjetsAttributs,sizeof((*T).ObjetsAttributs),1,MatrixT);
	fwrite((*T).ObjetsAttributsRelatif,sizeof((*T).ObjetsAttributsRelatif),1,MatrixT);
	fwrite((*T).ObjetsObjets,sizeof((*T).ObjetsObjets),1,MatrixT);
	fwrite((*T).AttributsAttributs,sizeof((*T).AttributsAttributs),1,MatrixT);
	fclose(MatrixT);
}

void ReadMatrix (int IdTreillis, int NbrO, int NbrA, int M,float MT[33][33])
{
	float Matrix[33][33];
	int i,j;
	char MatrixTreillis[40];
	FILE * MatrixT = NULL;
	sprintf(MatrixTreillis,"TreillisStruct/MatrixTreillis %d",IdTreillis);

	//printf("\n %s \n",MatrixTreillis);getc(stdin);

	MatrixT = fopen(MatrixTreillis, "rb");

	if(M==1)   //ObjetsAttributs
	{
		fread(Matrix, sizeof(Matrix), 2,MatrixT);
		for(i=0;i<NbrO;i++)
			for(j=0;j<NbrA;j++)
				MT[i][j]=Matrix[i][j];
	}
	else if(M==2) //ObjetsAttributsRelatif
	{
		//printf("\nje suis la\n"); getc(stdin);
		fread(Matrix, sizeof(Matrix), 1,MatrixT);
		fread(Matrix, sizeof(Matrix), 1,MatrixT);
		for(i=0;i<NbrO;i++)
			for(j=0;j<NbrA;j++)
				MT[i][j]=Matrix[i][j];
	}
	else if(M==3)  //ObjetsObjets
	{
		fread(Matrix, sizeof(Matrix), 1,MatrixT);
		fread(Matrix, sizeof(Matrix), 1,MatrixT);
		fread(Matrix, sizeof(Matrix), 1,MatrixT);
		for(i=0;i<NbrO;i++)
			for(j=0;j<NbrO;j++)
				MT[i][j]=Matrix[i][j];
	}
	else if(M==4)  //AttributsAttributs
	{
		fread(Matrix, sizeof(Matrix), 1,MatrixT);
		fread(Matrix, sizeof(Matrix), 1,MatrixT);
		fread(Matrix, sizeof(Matrix), 1,MatrixT);
		fread(Matrix, sizeof(Matrix), 1,MatrixT);
		for(i=0;i<NbrA;i++)
			for(j=0;j<NbrA;j++)
				MT[i][j]=Matrix[i][j];
	}
	fclose(MatrixT);
}

void AppliqueLesMesures() //*************************************************************************************************************
{
	Treillis * T;
	FILE* F2 = NULL;

	char Nomfichier[18][20];
	char InterTreillis[18][100];

	char Termes[1280][20];
	char Cours[18][50];
	char Terme1[]="N1";
	char Terme2	[]="N2";
	char Cours1[]="C1";
	char Cours2[]="C2";
	float Impact[18];
	float SimT[18];
	float SimC[18];

	int i, j, k;
	//int *test=0;
	int NbrTermes=0, NbrCours=0;
	FILE* Comparaison = NULL;
	FILE* TreillisXML = NULL;


	for(j=0; j<18;j++) Impact[j]=0;
	for(j=0; j<18;j++) SimT[j]=0;
	for(j=0; j<18;j++) SimC[j]=0;

	for(i=1;i<17;i++)
	{
		sprintf(Nomfichier[i],"Treillis/T (%d).xml",i);
		printf("Treillis %d\n",i);
		TreillisXML = fopen(Nomfichier[i], "r");

		if (TreillisXML != NULL)   // si fichier xml est ouvert
		{
			T=(Treillis*)malloc(1*sizeof(Treillis));

			T = ConstruireStructTreillis(i,TreillisXML);

			sprintf(InterTreillis[i],"InterTreillis/InterTreillis %s.txt",(*T).NomTreillis);
			//sprintf(InterTreillis[i],"InterTreillis/InterTreillis %d.txt",i);

			F2= fopen(InterTreillis[i], "w");

			Mesures(T);

		//	SaveMatrix(T);

		//	printf("SaveMatrix pour treillis %d \n",i);


			for(j=0;j<(*T).NbrObjets;j++)    // Pour trouver l'impacte entre Terme1 et Cours1
			{
				if(strcmp((*T).objets[j].NomObjet,Terme1)==00)
				{
					for(k=0;k<(*T).NbrAttributs;k++)
					{
						if(strcmp((*T).Attributs[k].NomAttribut,Cours1)==00)
							{
								Impact[i]=(*T).ObjetsAttributs[j][k];
							}
					}
				}
			}

			for(j=0;j<(*T).NbrObjets;j++)    // Pour trouver la similarite entre Terme1 et Terme2
			{
				if(strcmp((*T).objets[j].NomObjet,Terme1)==00)
				{
					for(k=0;k<(*T).NbrObjets;k++)
					{
						if(strcmp((*T).objets[k].NomObjet,Terme2)==00)
							{
								SimT[i]=(*T).ObjetsObjets[j][k];
							}
					}
				}
			}

			for(j=0;j<(*T).NbrAttributs;j++)    // Pour trouver la similarite entre Cours1 et Cours2
			{
				if(strcmp((*T).Attributs[j].NomAttribut,Cours1)==00)
				{
					for(k=0;k<(*T).NbrAttributs;k++)
					{
						if(strcmp((*T).Attributs[k].NomAttribut,Cours2)==00)
							{
								SimC[i]=(*T).AttributsAttributs[j][k];
							}
					}
				}
			}

			for(j=0;j<(*T).NbrObjets;j++)   // les termes dans tout les treillis
			{
				for(k=0;k<NbrTermes;k++)
				{
					if(strcmp((*T).objets[j].NomObjet,Termes[k])==0)
						break;
				}
				if(k==NbrTermes)
				{
					strcpy(Termes[NbrTermes],(*T).objets[j].NomObjet);
					NbrTermes++;
				}
			}

			for(j=0;j<(*T).NbrAttributs;j++)   // les cours dans tout les treillis
			{
				for(k=0;k<NbrCours;k++)
				{
					if(strcmp((*T).Attributs[j].NomAttribut,Cours[k])==0)
						break;
				}
				if(k==NbrCours)
				{
					strcpy(Cours[NbrCours],(*T).Attributs[j].NomAttribut);
					NbrCours++;
				}
			}

		//	ConstruireBDD(T);

		//	printf("BDD est fait pour treillis %d\n",i);

			ImprimerConcepts(T,F2);

			//fwriteStructTreillis(T);

			delete[] (*T).Concepts;
			delete[] (*T).objets;
			delete[] (*T).Attributs;
			delete[] T;

			fclose(F2);

			fclose(TreillisXML);
		}
		else
		{
			printf("Impossible d'ouvrir le fichier pour lire le trellis\n");
			getc(stdin);
		}
	}

	printf("\n");

	Comparaison=fopen("Comparaison/Impact.csv","w");

	for(j=1; j<17;j++)
		fprintf(Comparaison,"T%d;",j);
	fprintf(Comparaison,"\n");

	for(j=1; j<17;j++)
		fprintf(Comparaison,"%f;",Impact[j]);
	fclose(Comparaison);

	Comparaison=fopen("Comparaison/SimC.csv","w");

	for(j=1; j<17;j++)
		fprintf(Comparaison,"T%d;",j);
	fprintf(Comparaison,"\n");

	for(j=1; j<17;j++)
		fprintf(Comparaison,"%f;",SimC[j]);
	fclose(Comparaison);

	Comparaison=fopen("Comparaison/SimT.csv","w");

	for(j=1; j<17;j++)
		fprintf(Comparaison,"T%d;",j);
	fprintf(Comparaison,"\n");

	for(j=1; j<17;j++)
		fprintf(Comparaison,"%f;",SimT[j]);
	fclose(Comparaison);

	Comparaison=fopen("Comparaison/Termes.csv","w");

	for(i=0; i<NbrTermes;i++)
		fprintf(Comparaison,"%s\n",Termes[i]);
	fclose(Comparaison);

	Comparaison=fopen("Comparaison/Cours.csv","w");

	for(i=0; i<NbrCours;i++)
		fprintf(Comparaison,"%s\n",Cours[i]);
	fclose(Comparaison);

	//printf("\n  NbrApp = %d  NbrCont =  %d ",NbrApp, NbrCont);


}

#include "ReadWriteTreillisMatrix.hh"

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

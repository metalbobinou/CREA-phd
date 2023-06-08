#include "LireEtInterpTreillis.hh"

/* void InterTreillisContexteFormelle (ContextFormel CF, Treillis T)
{
	// Pour faire des interpretation entre un Contexte formelle et son treillis
} */


long factorielle(int n)
{
   if (n == 0)
      return 1;
   else
     return (n * factorielle(n-1));
}

int Nbrcombinaison(int n)
{
	int Nbr = 0, p;
	for(p = 1; p <= n; p++)
	{
		Nbr=Nbr+(factorielle(n)/(factorielle(p)*factorielle(n-p)));
	}
	return Nbr;
}

float Arrondi (float x)
{
	int y;
	y = int (x * 1000);
	x = float (y) / 1000;
	return x;
}




/*int Existe (int id, int l[])
{
	for(int i=0;i<20;i++)
		if(l[i]==id)
			return 1;
	return 0;
}

int FilsInf(Treillis* T, int i, int j, int NbrFilsInf )      // pour cherche tout les fils et sous fils des concepts dans le treillis // fonction ne fonctionne pas encore
{
	if( i < (*T).NbrConcepts)
	{
		for(j=0;j<(*T).Concepts[i].NbrFils;j++)
		{
			if(Existe((*T).Concepts[i].idConceptfils[j],(*T).Concepts[i].idConceptfilsInf)==0)
			{
				(*T).Concepts[i].idConceptfilsInf[NbrFilsInf]=(*T).Concepts[i].idConceptfils[j];
				NbrFilsInf++;
			}
			i=(*T).Concepts[i].idConceptfils[j];
			(*T).Concepts[i].NbrFilsInf = FilsInf( T,  i, j,  NbrFilsInf );
		}
	}
	return NbrFilsInf;
}*/




void ConceptsInclutV3(Treillis * T)   // pour calculer le nombre de concept pour chaque objet et chaque attribut
{
	int NbrConceptsAppartient=0;
	int i,j,k,p=0;
	for(i=0;i<(*T).NbrObjets;i++)
	{
		for(j=0;j<(*T).NbrConcepts;j++)
		{

			for(k=0;k<(*T).Concepts[j].NbrObjets;k++)
			{
				if((*T).objets[i].IdObjet==(*T).Concepts[j].objets[k].IdObjet)
				{
					(*T).objets[i].IdConceptsAppartient[NbrConceptsAppartient]=j;
					NbrConceptsAppartient++;
					p=p+(*T).Concepts[j].NbrParents;
					//if(i==8 && j==186) {printf("i = %d j = %d k=%d  NbrConceptsAppartient :%d,id: %d Nom: %s\n",i,j,k,NbrConceptsAppartient,(*T).objets[8].IdObjet,(*T).objets[8].NomObjet); getc(stdin);}  // Treillis 272, qaund  i=8 j=186 k=5 alors non Objets 8 disparu !!!
				}

			}
		}


		(*T).objets[i].NbrConceptsAppartient=NbrConceptsAppartient;
		if(p==0)
		{
			(*T).objets[i].poids =0;
			(*T).objets[i].poidsbis =0;
		}
		else
		{
			(*T).objets[i].poids=float(NbrConceptsAppartient)/float((*T).NbrConcepts);
			(*T).objets[i].poidsbis=float(p)/float((*T).NbrRelations);
		}
		p=0;
		NbrConceptsAppartient=0;
	}

	for(i=0;i<(*T).NbrAttributs;i++)
	{
		for(j=0;j<(*T).NbrConcepts;j++)
		{
			for(k=0;k<(*T).Concepts[j].NbrAttributs;k++)
			{
				if((*T).Attributs[i].IdAttribut==(*T).Concepts[j].Attributs[k].IdAttribut)
				{
					(*T).Attributs[i].IdConceptsAppartient[NbrConceptsAppartient]=j;
					NbrConceptsAppartient++;
					p=p+(*T).Concepts[j].NbrFils;
				}
			}
		}
		(*T).Attributs[i].NbrConceptsAppartient=NbrConceptsAppartient;
		if(p==0)
		{
			(*T).Attributs[i].poids =0;
			(*T).Attributs[i].poidsbis =0;
		}
		else
		{
			(*T).Attributs[i].poids=float(NbrConceptsAppartient)/float((*T).NbrConcepts);
			(*T).Attributs[i].poidsbis=float(p)/float((*T).NbrRelations);
		}
		p=0;
		NbrConceptsAppartient=0;
	}
}
/*
void ParFilsMaxV2 (Treillis * T)    // pour calculer le nombre Max de parent et de fils
{
	int i,j;
	int NbrParMax=0,NbrFilsMax=0;
	Concepts ConcParMax=(*T).Concepts[0],ConcFilsMax=(*T).Concepts[0];
	for (i=0;i<(*T).NbrConcepts;i++)
	{
		if((*T).Concepts[i].NbrParents>NbrParMax)
		{
			NbrParMax=(*T).Concepts[i].NbrParents;
			ConcParMax=(*T).Concepts[i];
		}
		if((*T).Concepts[i].NbrFils>NbrFilsMax)
		{
			NbrFilsMax=(*T).Concepts[i].NbrFils;
			ConcFilsMax=(*T).Concepts[i];
		}
	}
	(*T).NbrParMax=NbrParMax;
	(*T).NbrFilsMax=NbrFilsMax;
	(*T).ConcParMax=ConcParMax;
	(*T).ConcFilsMax=ConcFilsMax;
}*/


void RemplirNbrFilsEtListeFilsV2( Treillis * T)  // pour cherche les fils pour chaque concept
{
	int i,j,k,n=0;
	for(i=0;i<(*T).NbrConcepts;i++)    //liste de concepts
	{
		for (j=0;j<(*T).NbrConcepts;j++)  // liste de concepts
		{
			for(k=0;k<(*T).Concepts[j].NbrParents;k++)  // liste de parent
			{
				if((*T).Concepts[j].idConceptParents[k]==(*T).Concepts[i].idConcept)   // cherche le fils
				{
					(*T).Concepts[i].idConceptfils[n]=(*T).Concepts[j].idConcept;
					n++;
					break;
				}
			}
		}
		(*T).Concepts[i].NbrFils=n;
		(*T).Concepts[i].ProportionFils=(float)(*T).Concepts[i].NbrFils/(*T).NbrConcepts;
		(*T).Concepts[i].ProportionParents=(float)(*T).Concepts[i].NbrParents/(*T).NbrConcepts;
		n=0;
	}
}


void MoyenneOAPTFV2 (Treillis * T)    // pour calculer le moyenne de nombre objets, attribut, parent, fils et taille
{
	double So=0,Sa=0,Sp=0,Sf=0,Stc=0;
	int i;
	for (i=0;i<(*T).NbrConcepts;i++)
	{
		So=So+(*T).Concepts[i].NbrObjets;
		Sa=Sa+(*T).Concepts[i].NbrAttributs;
		Sp=Sp+(*T).Concepts[i].NbrParents;
		Sf=Sf+(*T).Concepts[i].NbrFils;
		Stc=Stc+(*T).Concepts[i].TailleConcept;
	}
	(*T).MoyenneNbrObj=So/(*T).NbrConcepts;
	(*T).MoyenneNbrAtt=Sa/(*T).NbrConcepts;
	(*T).MoyenneNbrPar=Sp/(*T).NbrConcepts;
	(*T).MoyenneTailleConcept=Stc/(*T).NbrConcepts;
	(*T).MoyenneNbrFils=Sf/(*T).NbrConcepts;
	//So = ((*T).NbrRelations*(*T).NbrConcepts);
	//Sa = ((*T).NbrObjets*(*T).NbrAttributs);
	//(*T).densite= So / Sa ;
	//So=Nbrcombinaison((*T).NbrObjets);
	//Sa=Nbrcombinaison((*T).NbrAttributs);
	/*if(So<=Sa)
		(*T).densiteConcepts=float((*T).NbrConcepts)/float(So);
	else
		(*T).densiteConcepts=float((*T).NbrConcepts)/float(Sa);*/
}


void RemplirNomOADansCV2 (Treillis* T)   // pour remplir le nom de objet et attribut dans chaque concept
{
	int i=0,j=0,k=0;
	for(i=0; i<(*T).NbrConcepts ; i++)
	{
		for(j=0;j<(*T).Concepts[i].NbrObjets;j++)         // cherche le nom de objet dans le concept i
		{
			for(k=0;k<(*T).NbrObjets;k++)
			{
				if((*T).Concepts[i].objets[j].IdObjet==(*T).objets[k].IdObjet)
				{
					strcpy((*T).Concepts[i].objets[j].NomObjet,(*T).objets[k].NomObjet);
					//printf("%d   %s \n",(*T).Concepts[i].objets[j].IdObjet,(*T).Concepts[i].objets[j].NomObjet );
					k=(*T).NbrObjets;
				}
			}
		}
		for(j=0;j<(*T).Concepts[i].NbrAttributs;j++)         // cherche le nom de attribut dans le concept i
		{
			for(k=0;k<(*T).NbrAttributs;k++)
			{
				if((*T).Concepts[i].Attributs[j].IdAttribut==(*T).Attributs[k].IdAttribut)
				{
					strcpy((*T).Concepts[i].Attributs[j].NomAttribut,(*T).Attributs[k].NomAttribut);
					k=(*T).NbrAttributs;
				}
			}
		}
	}
}

/*void CalculerNbrrelations(Treillis * T)
{
	int i, NbrR=0;
	for (i=0;i<(*T).NbrConcepts;i++)
		NbrR=NbrR+(*T).Concepts[i].NbrParents;
	(*T).NbrRelations=NbrR;

	return T;
}*/

void CalculerNbrrelationsV2(Treillis * T)
{
	int i, NbrR=0;
	for (i=0;i<(*T).NbrConcepts;i++)
		NbrR=NbrR+(*T).Concepts[i].NbrParents;
	(*T).NbrRelations=NbrR;
}
/*
void Niveaux(Treillis * T)
{
	int i,j, L=0, Idn=0;
	(*T).Niveaux=new Niveau[(*T).NbrNiveau];
	for(i=0;i<=(*T).NbrNiveau;i++)
	{
		(*T).Niveaux[i].NbrConcepts=0;
		(*T).Niveaux[i].IdNiveau=i;
		for(j=0;j<(*T).NbrConcepts;j++)
		{
			if((*T).Concepts[j].niv==i)
			{
				(*T).Niveaux[i].idConcepts[(*T).Niveaux[i].NbrConcepts]=(*T).Concepts[j].idConcept;
				(*T).Niveaux[i].NbrConcepts++;

			}
		}
		if((*T).Niveaux[i].NbrConcepts>L)
		{
			L=(*T).Niveaux[i].NbrConcepts;
			Idn=i;
		}
	}
	//(*T).Largeur=L;
	(*T).IdNiveauL=Idn;
	//(*T).Taille=float((*T).Largeur)/float((*T).NbrNiveau);   // attention à la division
	//(*T).SurfaceMax=(*T).Largeur*(*T).NbrNiveau;
	//(*T).LargeurNormalisee= float(L)/float((*T).NbrConcepts);
	//(*T).LargeurNormaliseeBis= float(L)/(float((*T).NbrAttributs)*float((*T).NbrObjets));
	//(*T).HauteurNormalisee=float((*T).NbrNiveau)/float((*T).NbrConcepts);
	//(*T).HauteurNormaliseeBis= float((*T).NbrNiveau)/(float((*T).NbrAttributs)*float((*T).NbrObjets));
	//(*T).ComplexiteTreillis=(*T).LargeurNormalisee*(*T).HauteurNormalisee;
	//(*T).pertinence = (*T).Taille * (*T).densite;
}

*/

void Mesures(Treillis * T)   // les matrices et les niveaux
{
	int i,j,k,l,m;
	int mx=0;

	for (i=0;i<(*T).NbrObjets;i++)
		for(j=0;j<(*T).NbrAttributs;j++)
		{
			(*T).ObjetsAttributs[i][j]=0;
			(*T).ObjetsAttributsRelatif[i][j]=0;
		}


	for (i=0;i<(*T).NbrObjets;i++)
		for(j=0;j<(*T).NbrObjets;j++)
			(*T).ObjetsObjets[i][j]=0;

	for (i=0;i<(*T).NbrAttributs;i++)
		for(j=0;j<(*T).NbrAttributs;j++)
			(*T).AttributsAttributs[i][j]=0;

	for (i=0;i<(*T).NbrObjets;i++)
	{
		for(j=0;j<(*T).NbrAttributs;j++)
		{
			for(k=0;k<(*T).NbrConcepts;k++)
			{
				for(l=0;l<(*T).Concepts[k].NbrAttributs;l++)
					if((*T).Concepts[k].Attributs[l].IdAttribut==j)
					{
						for(m=0;m<(*T).Concepts[k].NbrObjets;m++)
							if((*T).Concepts[k].objets[m].IdObjet==i)
								{
									(*T).ObjetsAttributs[i][j]++;
									break;
								}
						break;
					}
			}
			(*T).ObjetsAttributsRelatif[i][j]=(*T).ObjetsAttributs[i][j]/float((*T).objets[i].NbrConceptsAppartient+(*T).Attributs[j].NbrConceptsAppartient-(*T).ObjetsAttributs[i][j]);
			(*T).ObjetsAttributs[i][j]=(*T).ObjetsAttributs[i][j]/float((*T).NbrConcepts);
		}

	}


	for (i=0;i<(*T).NbrObjets;i++)
	{
		for(j=0;j<(*T).NbrObjets;j++)
		//for(j=0;j<i;j++)
		//for(j=i+1;j<(*T).NbrObjets;j++)
		{
			for(k=0;k<(*T).NbrConcepts;k++)
			{
				for(l=0;l<(*T).Concepts[k].NbrObjets;l++)
					if((*T).Concepts[k].objets[l].IdObjet==i)
					{
						for(m=0;m<(*T).Concepts[k].NbrObjets;m++)
							if((*T).Concepts[k].objets[m].IdObjet==j && i!=j) //
								{
									(*T).ObjetsObjets[i][j]++;
									break;
								}
						break;
					}
			}
		}

	}

	//int idOMAX1;
	int x=0,y=0;

	for (i=0;i<(*T).NbrObjets;i++)
	{
		k=(*T).ObjetsObjets[i][i];
		for(j=0;j<(*T).NbrObjets;j++)
		{
			(*T).ObjetsObjets[i][j]=float((*T).ObjetsObjets[i][j])/float((*T).objets[i].NbrConceptsAppartient+(*T).objets[j].NbrConceptsAppartient-(*T).ObjetsObjets[i][j]);
			if((*T).ObjetsObjets[i][j]==1)  // pour avoir la liste de combinaisons avec une similarité 100%
			{
				(*T).ObjetsObjetsMax[mx][0]=i;
				(*T).ObjetsObjetsMax[mx][1]=j;
				(*T).ObjetsObjetsMax[mx][2]=1;
				x++;
				mx++;
			}
		}
		if(x>y)    // pour cherche l'obejt le plus simiaire au max des oejts
		{
			(*T).NomObjetMAX1[0]='\0';(*T).NomObjetMAX1[1]='\0';(*T).NomObjetMAX1[2]='\0';(*T).NomObjetMAX1[3]='\0';(*T).NomObjetMAX1[4]='\0';
			strcpy((*T).NomObjetMAX1,(*T).objets[i].NomObjet);
			y=x;
		}
		x=0;

	}
	(*T).OOM=mx;


	for (i=0;i<(*T).NbrAttributs;i++)
	{
		for(j=0;j<(*T).NbrAttributs;j++)
		{
			for(k=0;k<(*T).NbrConcepts;k++)
			{
				for(l=0;l<(*T).Concepts[k].NbrAttributs;l++)
					if((*T).Concepts[k].Attributs[l].IdAttribut==i)
					{
						for(m=0;m<(*T).Concepts[k].NbrAttributs;m++)
							if((*T).Concepts[k].Attributs[m].IdAttribut==j && i!=j)
								{
									(*T).AttributsAttributs[i][j]++;
									break;
								}
						break;
					}
			}
		}

	}

	for (i=0;i<(*T).NbrAttributs;i++)
	{
		k=(*T).AttributsAttributs[i][i];
		for(j=0;j<(*T).NbrAttributs;j++)
			//(*T).AttributsAttributs[i][j]=float((*T).AttributsAttributs[i][j])/float(k);
			(*T).AttributsAttributs[i][j]=float((*T).AttributsAttributs[i][j])/float((*T).Attributs[i].NbrConceptsAppartient+(*T).Attributs[j].NbrConceptsAppartient-(*T).AttributsAttributs[i][j]);

	}

	for(i=0;i<(*T).NbrConcepts;i++)
		(*T).Concepts[i].niv=0;

	for(i=0;i<(*T).NbrConcepts;i++)
	{
		for(j=0;j<(*T).Concepts[i].NbrFils;j++)
		{
			m=(*T).Concepts[i].idConceptfils[j];
			l=(*T).Concepts[m].niv + 1;
			if((*T).Concepts[i].niv < l)
				(*T).Concepts[i].niv=l;
		}
	}
	(*T).NbrNiveau=(*T).Concepts[i-1].niv;

//	Niveaux(T);
}


void LireTreillisV2 (Treillis* T, FILE* TreillisR)   // pour la treillis de fichier XML  //**********************************************************//
{
	int IdC = 0;
	int i = 0, j;
	//int l, n;
	int x = 0;//, y;
	//int p = 0;
	int a;
	int NbrO = 0;
	int NbrA = 0;
	int NbrP = 0;
	//int e = 1;
	//int f = 0;
	//int NbrFilsInf = 0;
	char ligne[100] = "";
	char c[4];
	char *ptr;
	//char nom[30] = "";

	(*T).Concepts=new Concept[(*T).NbrConcepts];
	(*T).objets=new Objet[(*T).NbrObjets];
	(*T).Attributs=new Attribut[(*T).NbrAttributs];

	fgets(ligne, 100, TreillisR);   //premiere ligne
	fgets(ligne, 100, TreillisR);   // deuxieme ligne dans le fichier
	//l=strlen(ligne);
	while(ligne[i]!='"')   // lire le nom de treillis
		i++;
	i++;
	while(ligne[i]!='"')
		i++;
	i++;
	while(ligne[i]!='"')
		i++;
	i++;

	while(ligne[i]!=' ')
	{
		(*T).NomTreillis[x]=ligne[i];
		x++;i++;
	}

	/*while(ligne[i]!='=')
		i++;
	i=i+21;
	j=i;
	while(ligne[j]!='#')
		j++;
	j=j-11;
	for(n=i;n<=j;n++)
	{
		(*T).NomTreillis[x]=ligne[n];
		x++;
	}*/

	(*T).NomTreillis[x]='\0';
	//i=0;j=0;l=0;n=0;y=0;x=0;p=0;a=0;c[0]='\0';c[1]='\0';c[2]='\0';c[3]='\0';   // les varaibles à zero //lire id objet et nom objet
	i=0;j=0;x=0;a=0;c[0]='\0';c[1]='\0';c[2]='\0';c[3]='\0';   // les varaibles à zero //lire id objet et nom objet
	fgets(ligne, 90, TreillisR);
	fgets(ligne, 90, TreillisR);

	while (strstr(ligne, "</OBJS>")== NULL)
	{
		NbrO++;
		i=0;
		j=0;
		while(ligne[i]!='"')
				i++;
		i++;
		while (ligne[i]!='"')
		{
			c[j]=ligne[i];
			i++;
			j++;
		};
		i=i+2;
		j=0;
		while (ligne[i]!='<')
		{
			(*T).objets[NbrO-1].NomObjet[j]=ligne[i];
			i++;
			j++;
		}
		(*T).objets[NbrO-1].NomObjet[j]='\0';

		a=strtol(c, &ptr,10);
		c[0]='\0';c[1]='\0';c[2]='\0';c[3]='\0';
		(*T).objets[NbrO-1].IdObjet=a;
		fgets(ligne, 90, TreillisR);
	}
	//i=0;j=0;l=0;n=0;y=0;x=0;p=0;a=0;c[0]='\0';c[1]='\0';c[2]='\0';c[3]='\0'; NbrO=0; NbrA=0;NbrP=0;   // les varaibles à zero //lire id, nom attributs
	i=0;j=0;x=0;a=0;c[0]='\0';c[1]='\0';c[2]='\0';c[3]='\0'; NbrO=0; NbrA=0;NbrP=0;   // les varaibles à zero //lire id, nom attributs
	fgets(ligne, 90, TreillisR);
	fgets(ligne, 90, TreillisR);
	while (strstr(ligne, "</ATTS>")== NULL)
	{
		NbrA++;
		i=0;
		j=0;
		while(ligne[i]!='"')
				i++;
		i++;
		while (ligne[i]!='"')
		{
			c[j]=ligne[i];
			i++;
			j++;
		};
		i=i+2;
		j=0;
		while (ligne[i]!='<')
		{
			(*T).Attributs[NbrA-1].NomAttribut[j]=ligne[i];
			i++;
			j++;
		}
		(*T).Attributs[NbrA-1].NomAttribut[j]='\0';
		a=strtol(c, &ptr,10);
		c[0]='\0';c[1]='\0';c[2]='\0';c[3]='\0';
		(*T).Attributs[NbrA-1].IdAttribut=a;
		fgets(ligne, 90, TreillisR);
	}
	//i=0;j=0;l=0;n=0;y=0;x=0;p=0;a=0;c[0]='\0';c[1]='\0';c[2]='\0';c[3]='\0';    // les varaibles à zero
	i=0;j=0;x=0;a=0;c[0]='\0';c[1]='\0';c[2]='\0';c[3]='\0';    // les varaibles à zero
	fgets(ligne, 90, TreillisR);
	fgets(ligne, 90, TreillisR);
	while (strstr(ligne, "</NODS")== NULL)
	{

		if (strstr(ligne, "<NOD")!= NULL)
		{
			while(ligne[i]!='"')              // pour lire l'id de concept
				i++;
			i++;
			while (ligne[i]!='"')
			{
				c[j]=ligne[i];
				i++;
				j++;
			};

			(*T).Concepts[IdC].idConcept=strtol(c, &ptr,10);

			/*
			if(v==1) // Treillis 1 pour creer les objets // attention si les treilis changent je dois modifier les if ici
			{
				if(IdC == 261 )
					(*T).Concepts[IdC].objets = new Objet[1210];
				else
					(*T).Concepts[IdC].objets = new Objet[370];
			}


			if(v==16) // Treillis 1 pour creer les objets // attention si les treilis changent je dois modifier les if ici
			{
				if(IdC == 196 )
					(*T).Concepts[IdC].objets = new Objet[1210];
				else
					(*T).Concepts[IdC].objets = new Objet[370];
			}



			if(IdC == 261 )
				(*T).Concepts[IdC].objets = new Objet[1210];
			else
				(*T).Concepts[IdC].objets = new Objet[370];
			*/

			if(IdC < 144 )
				(*T).Concepts[IdC].objets = new Objet[344];
			else
				(*T).Concepts[IdC].objets = new Objet[1205];


			c[0]='\0';c[1]='\0';c[2]='\0';c[3]='\0'; i=0; j=0;NbrO=0; NbrA=0;
			fgets(ligne, 90, TreillisR);
			if (strstr(ligne, "<EXT>")!= NULL)          // pour lire les ids objets dans ce concept
			{
				fgets(ligne, 90, TreillisR);
				while(strstr(ligne, "</EXT>")== NULL)
				{
					NbrO++;
					while(ligne[i]!='"')
						i++;
					i++;
					while (ligne[i]!='"')
					{
						c[j]=ligne[i];
						i++;
						j++;
					};

					(*T).Concepts[IdC].objets[NbrO-1].IdObjet=strtol(c, &ptr,10);
					fgets(ligne, 90, TreillisR);

					i=0;j=0;c[0]='\0';c[1]='\0';c[2]='\0';c[3]='\0';
				}
				(*T).Concepts[IdC].NbrObjets=NbrO;
				(*T).Concepts[IdC].ProportionObj=(float)NbrO/(*T).NbrObjets;
				NbrO=0;
				fgets(ligne, 90, TreillisR);
			}
			else
			{
				(*T).Concepts[IdC].NbrObjets=0;
				(*T).Concepts[IdC].ProportionObj=0;
				fgets(ligne, 90, TreillisR);
			}

			if (strstr(ligne, "<INT>")!= NULL)
			{
				fgets(ligne, 90, TreillisR);
				while(strstr(ligne, "</INT>")== NULL)
				{
					NbrA++;
					while(ligne[i]!='"')              // pour lire les ids attributs dans ce concept
						i++;
					i++;
					while (ligne[i]!='"')
					{
						c[j]=ligne[i];
						i++;
						j++;
					};
					(*T).Concepts[IdC].Attributs[NbrA-1].IdAttribut=strtol(c, &ptr,10);
					fgets(ligne, 90, TreillisR);
					i=0;j=0;c[0]='\0';c[1]='\0';c[2]='\0';c[3]='\0';
				}
				(*T).Concepts[IdC].NbrAttributs=NbrA;
				(*T).Concepts[IdC].ProportionAtt=(float)NbrA/(*T).NbrAttributs;
				NbrA=0;
				fgets(ligne, 90, TreillisR);
			}
			else
			{
				(*T).Concepts[IdC].NbrAttributs=0;
				(*T).Concepts[IdC].ProportionAtt=0;
				fgets(ligne, 90, TreillisR);
			}
			if (strstr(ligne, "<SUP_NOD>")!= NULL)
			{
				fgets(ligne, 90, TreillisR);
				while(strstr(ligne, "</SUP_NOD>")== NULL)
				{
					NbrP++;
					while(ligne[i]!='"')              // pour lire les ids des concept parent
						i++;
					i++;
					while (ligne[i]!='"')
					{
						c[j]=ligne[i];
						i++;
						j++;
					};
					(*T).Concepts[IdC].idConceptParents[NbrP-1]=strtol(c, &ptr,10);
					fgets(ligne, 90, TreillisR);
					i=0;j=0;c[0]='\0';c[1]='\0';c[2]='\0';c[3]='\0';
				}
				(*T).Concepts[IdC].NbrParents=NbrP;
				//printf("Nombre parent de concept %d : %d\n",IdC,NbrP);getc(stdin);
				NbrP=0;
				fgets(ligne, 90, TreillisR);
			}
			else
			{
				//fprintf(F,"pas des parents \n");
				(*T).Concepts[IdC].NbrParents=0;
				fgets(ligne, 90, TreillisR);
			}
			(*T).Concepts[IdC].TailleConcept=(*T).Concepts[IdC].NbrObjets+(*T).Concepts[IdC].NbrAttributs;
			/*if(cp.NbrObjets != 0 )
			cp.equilibre = float (cp.NbrAttributs) / float(cp.NbrObjets);
			else cp.equilibre=0;*/
			IdC++;
			fgets(ligne, 90, TreillisR);
		}
	}
	RemplirNomOADansCV2(T);

	RemplirNbrFilsEtListeFilsV2(T);

	CalculerNbrrelationsV2(T);

	MoyenneOAPTFV2(T);

//	ParFilsMaxV2(T);

	ConceptsInclutV3(T);

}

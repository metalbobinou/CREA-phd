#ifndef TREILLISSTRUCT_HH_
# define TREILLISSTRUCT_HH_

typedef struct Objet Objet;
typedef struct Attribut Attribut;
typedef struct Concept Concept;
typedef struct Niveau Niveau;
typedef struct Treillis Treillis;
typedef struct ResultatsInterpredeuxTreillis ResultatsInterpredeuxTreillis;
typedef struct ContextClass ContextClass;

typedef struct ContextFormel ContextFormel;

typedef struct ResultatsInterpreTreillis ResultatsInterpreTreillis;


struct ContextFormel
{
	int NbrO;
	int NbrA;
	char Objet[1276][20];
	char Attribut[18][30];
	int Matrice[1276][18];
};

struct Objet  // les applications
{
    int IdObjet;
	int NbrConceptsAppartient;
	int IdConceptsAppartient[262]; // c'est ici qaund le nombre de conceptApp passe le 150 il supprime le nom de objets
    char NomObjet[20] ;
	float poids;    // NbrConcepts*Nbrliens (nbr concept parent )
	float poidsbis;
};

struct Attribut    // les éléments de contexte
{
    int IdAttribut;
	int NbrConceptsAppartient;
	int IdConceptsAppartient[262];
    char NomAttribut[30];
	float poids;    // NbrConcepts*Nbrliens (nbr concept fils )
	float poidsbis;
};

struct Concept
{
	int idConcept;
	int NbrObjets;
	int NbrAttributs;
	Objet * objets;           // les objets dans ce concept
	Attribut Attributs[18];   // les attributs dans ce concept
	int idConceptParents[50];  // les id de concept parent pour ce concept
	//int idConceptParentsSup[15];
	int NbrParents;
	//int NbrParentsSup;
	int idConceptfils[50];
	//int idConceptfilsInf[15];
	int NbrFils;
//	int NbrFilsInf;
	int TailleConcept;   // Pour le moment je considere que le taille d'un concept est la somme de nombre d'objets avec le nombre d'attribut
//	float equilibre;
	int niv;
	float ProportionAtt;
	float ProportionObj;
	float ProportionParents;
	float ProportionFils;
};

struct Niveau  // il manque  la fonction pour trouver un niveau dans un treillis
{
	int IdNiveau;
	int NbrConcepts;
	int idConcepts[40];
};

struct Treillis
{
	int IdTreillis;
	char NomTreillis[30];
	int NbrConcepts;
	int NbrObjets;
	int NbrAttributs;
	int NbrRelations;
	int NbrNiveau;
//	int Largeur;   // le nombre de concepts sur le niveau le plus large dans le treillis
//	int IdNiveauL;
	Objet * objets;         // les objets dans le treillis
	Attribut * Attributs;   // les attributs dans le treillis
//	Niveau * Niveaux;
//	Concept ConcParMax,ConcFilsMax;
	Concept *Concepts;
	double densite;
	float densiteConcepts;
//	float Taille;
//	int SurfaceMax;
//	float ComplexiteTreillis;
//	float LargeurNormalisee ;
//	float LargeurNormaliseeBis ; // divise par le NbrO*NbrA
//	float LargeurNormaliseeBis2 ; // divise par le Nbr de 1 dans contexte formel
//	float HauteurNormalisee ;
//	float HauteurNormaliseeBis ; // divise par le NbrO*NbrA
//	float HauteurNormaliseeBis2 ; // divise par le Nbr de 1 dans contexte formel
//	float pertinence;
	float MoyenneNbrObj;
	float MoyenneNbrAtt;
	float MoyenneNbrPar;
	float MoyenneNbrFils;
	float MoyenneTailleConcept;
//	int NbrParMax;
//	int NbrFilsMax;
	float ObjetsAttributs[1276][18];
	float ObjetsAttributsRelatif[1276][20];
	float ObjetsObjets[1276][1276];
	int ObjetsObjetsMax[1000000][3];
	int OOM;
	int IdOMAX1;
	char NomObjetMAX1[5] ;
	float AttributsAttributs[18][18];
};

#endif /* !TREILLISSTRUCT_HH_ */

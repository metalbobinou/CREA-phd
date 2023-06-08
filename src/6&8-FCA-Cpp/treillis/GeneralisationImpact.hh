#ifndef GENERALISATIONIMPACT_HH_
# define GENERALISATIONIMPACT_HH_

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sqlite3.h>

#include "TreillisStructs.hh"

#include "AppliqueLesMesures.hh"


char ** RequeteBDD(char *NomT, char *Requete);

void ConstruireFichierImpactEMS(Treillis *T, char *NE, float Matrix[33][33], char O, char S, char beta[6]);

void ConstruireFichierImpactEMS_NN(Treillis *T, char *NE, float Matrix[33][33], char O, char S);

void ConstruireFichierImpactMSE(Treillis *T, char *NE, float Matrix[33][33], char O, char S, char beta[6]);

void ConstruireFichierImpactMSE_NN(Treillis *T, char *NE, float Matrix[33][33], char O, char S);

void GeneralisationMesureImpact();

#endif /* !GENERALISATIONIMPACT_HH_ */

#ifndef GENERALISATIONSIMCONTEX_HH_
# define GENERALISATIONSIMCONTEX_HH_

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sqlite3.h>

#include "TreillisStructs.hh"

#include "AppliqueLesMesures.hh"


void ConstruireFichierSimContexEMS(Treillis *T, char *NE, float Matrix[33][33], char O, char S, char beta[6]);

void ConstruireFichierSimContexEMS_NN(Treillis *T, char *NE, float Matrix[33][33], char O, char S);

void ConstruireFichierSimContexMSE(Treillis *T, char *NE, float Matrix[33][33], char O, char S, char beta[6]);

void ConstruireFichierSimContexMSE_NN(Treillis *T, char *NE, float Matrix[33][33], char O, char S);

void GeneralisationMesureSimContex();

#endif /* !GENERALISATIONSIMCONTEX_HH_ */

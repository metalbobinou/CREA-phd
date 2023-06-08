#ifndef GENERALISATIONSIMAPP_HH_
# define GENERALISATIONSIMAPP_HH_

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sqlite3.h>

#include "TreillisStructs.hh"

#include "ReadWriteTreillisMatrix.hh"


void ConstruireFichierSimAppEMS(Treillis *T, char *NE, float Matrix[33][33], char O, char S, char beta[6]);

void ConstruireFichierSimAppEMS_NN(Treillis *T, char *NE, float Matrix[33][33], char O, char S);

void ConstruireFichierSimAppMSE(Treillis *T, char *NE, float Matrix[33][33], char O,char S, char beta[6]);

void ConstruireFichierSimAppMSE_NN(Treillis *T, char *NE, float Matrix[33][33], char O, char S);

void GeneralisationMesureSimApp();

#endif /* !GENERALISATIONSIMAPP_HH_ */

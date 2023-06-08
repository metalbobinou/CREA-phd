#ifndef APPLIQUELESMESURES_HH_
# define APPLIQUELESMESURES_HH_

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sqlite3.h>

#include "TreillisStructs.hh"

#include "LireEtInterpTreillis.hh"


void fwriteStructTreillis(Treillis * T);

void ImprimerConcepts(Treillis * T, FILE* F);

void CalculerNbr(Treillis * T, FILE* TreillisR);

void ConstruireBDD(Treillis * T);

Treillis * ConstruireStructTreillis(int NTreillis, FILE* TreillisXML);

void SaveMatrix(Treillis * T);

void ReadMatrix(int IdTreillis, int NbrO, int NbrA, int M, float MT[33][33]);

void AppliqueLesMesures();

#endif /* !APPLIQUELESMESURES_HH_ */

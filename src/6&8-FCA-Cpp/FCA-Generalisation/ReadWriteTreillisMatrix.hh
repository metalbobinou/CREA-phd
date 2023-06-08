#ifndef READWRITETREILLISMATRIX_HH_
# define READWRITETREILLISMATRIX_HH_

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "TreillisStructs.hh"

#include "LireEtInterpTreillis.hh"


void fwriteStructTreillis(Treillis * T);

void ImprimerConcepts(Treillis * T, FILE* F);

void CalculerNbr(Treillis * T, FILE* TreillisR);

Treillis * ConstruireStructTreillis(int NTreillis, FILE* TreillisXML);

void SaveMatrix(Treillis * T);

void ReadMatrix(int IdTreillis, int NbrO, int NbrA, int M, float MT[33][33]);

#endif /* !READWRITETREILLISMATRIX_HH_ */

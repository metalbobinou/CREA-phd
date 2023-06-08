#ifndef LIREETINTERPTREILLIS_HH_
# define LIREETINTERPTREILLIS_HH_

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "TreillisStructs.hh"


long factorielle(int n);

int Nbrcombinaison(int n);

float Arrondi(float x);

void ConceptsInclutV3(Treillis * T);

void RemplirNbrFilsEtListeFilsV2(Treillis * T);

void MoyenneOAPTFV2(Treillis * T);

void RemplirNomOADansCV2(Treillis* T);

void CalculerNbrrelationsV2(Treillis * T);

void Mesures(Treillis * T);

void LireTreillisV2 (Treillis* T, FILE* TreillisR);

#endif /* !LIREETINTERPTREILLIS_HH_ */

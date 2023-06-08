#ifndef CONTEXTFORMELSTRATEGIES_HH_
# define CONTEXTFORMELSTRATEGIES_HH_

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

#include <iostream>
#include <string>

#include "TreillisStructs.hh"

#include "Dirs.hh"
#include "Files.hh"
#include "ParseCSV.hh"


# define LIRECONTEXTEFORMEL_BUFFER 1024


void CopieContextFormel(ContextFormel * CFbis, ContextFormel * CF);

void LireContexteFormelle(FILE *F, ContextFormel *CF);

void ConstruirefichierContextFormel(ContextFormel * CF, FILE* F);

void ConstruirefichierContextFormelBis(ContextFormel * CF, FILE* F);

void ConstruirefichierContextFormelBis2(ContextFormel * CF, FILE* F);

void SupprimerLignesColonnes0(ContextFormel * CF);

/////////////////////////////////////////////////////////////////// AVEC ONTOLOGIE //////////////////////////////////////////////////////

void RelationsNulles(ContextFormel * CF);

void Directesansfrequence(ContextFormel * CF);


/////////////////////////////////////////////////////////////////// SANS ONTOLOGIE //////////////////////////////////////////////////////

void RelationsFortesSansOnto(ContextFormel * CF, double Beta);

void RelationsFaiblesSansOnto(ContextFormel * CF, double Beta);

void RelationsMoyennesSansOnto(ContextFormel * CF, double Beta);

/////////////////////////////////////////////////////////////////// SANS ONTOLOGIE //////////////////////////////////////////////////////

void ContextFormelStrategies();
void ContextFormelStrategies(char **InputFiles, const char *OutputDirectory);

#endif /* !CONTEXTFORMELSTRATEGIES_HH_ */

#include "DSPLs.hh"

void PercentageDSPLs()
{
	FILE* FichDSPLS = NULL;
	FILE* FichDSPLS_Bis = NULL;
	char ligne[250] = "";
	//char ligne2[50] = "";
	char V[3];
	int i = 0, id = 1, y, j = 0, t = 0;
	float x, NoP;
	char *ptr;
	for(j = 0; j < 3; j++) V[j]='\0';

	FichDSPLS = fopen("FichDSPLS/DSPLS.csv","r");
	FichDSPLS_Bis = fopen("FichDSPLS/DSPLS_Percentage.csv", "w");

	if(FichDSPLS!= NULL && FichDSPLS_Bis!= NULL)
	{
		fgets(ligne, 250, FichDSPLS);

		while(fgets(ligne, 50, FichDSPLS)!=NULL)
		{
			fprintf(FichDSPLS_Bis,"%d",id);
			printf("%s\n",ligne);
			id++;

			i=0;t=0;
			while(ligne[i]!=';') i++;
			i++;//i=i++;

			while(ligne[i]!=';')
			{
				V[t]=ligne[i];
				t++;
				i++;
			}
			NoP=strtol(V, &ptr,10);
			i++;//i=i++;
			t=0;
			while(ligne[i]!='\n')
			{
				for(j=0;j<3;j++) V[j]='\0';
				t=0;
				while(ligne[i]!=';' && ligne[i]!='\n')
				{
					V[t]=ligne[i];
					t++;
					i++;
				}
				x=strtol(V, &ptr,10);
				x=x/NoP;
				x=x*100;
				y=int(x);
				fprintf(FichDSPLS_Bis,";%d",y);
				if(ligne[i]!='\n') i++;
			}
			fprintf(FichDSPLS_Bis,"\n");
		}
		fclose(FichDSPLS);
		fclose(FichDSPLS_Bis);
	}
	else
	{
		printf("Impossible d'ouvrir le fichier de l'FichDSPLS ou l'FichDSPLS_Bis \n");
		getc(stdin);
	}

}

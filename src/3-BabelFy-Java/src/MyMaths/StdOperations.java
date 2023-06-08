package MyMaths;

import java.util.ArrayList;
import java.util.List;

public class StdOperations
{
	public static void main (String[] args)
	{
		// Test functions

		System.out.println("PPCM 6 & 10 : " + PPCM(6, 10));
		System.out.println("PPCM 42 & 68 : " + PPCM(42, 68));
		System.out.println("PGCD 42 & 68 : " + PGCD(42, 68));
		System.out.println("PGCD 768 & 48 : " + PGCD(768, 48));
		System.out.println("PGCD 768 & 128 : " + PGCD(768, 128));
		System.out.println("Diviseurs 10 : " + Divisors(10));
		System.out.println("Diviseurs 50 : " + Divisors(50));
		System.out.println("Diviseurs 4096 : " + Divisors(4096));
	}


	// Code Telecom ParisTech
	public static int PPCM(int Nb1, int Nb2)
	{
		int Produit, Reste, PPCM;

		Produit = Nb1 * Nb2;
		Reste = Nb1 % Nb2;
		while (Reste != 0)
		{
			Nb1 = Nb2;
			Nb2 = Reste;
			Reste = Nb1 % Nb2;
		}
		PPCM = Produit / Nb2;
		// System.out.println("PGCD = " + Nb2 + " PPCM = " + PPCM);
		return PPCM;
	}

	public static int PGCD(int Nb1, int Nb2)
	{
		while (Nb1 != Nb2)
		{
			if (Nb1 > Nb2)
				Nb1 = Nb1 - Nb2;
			else
				Nb2 = Nb2 - Nb1;
		}
		return (Nb2);
	}

	public static List<Integer> Divisors(int n)
	{
		List<Integer> ListDivisor = new ArrayList<>();

		for (int i = 2; i <= (n / 2); i++)
		{
			if ((n % i) == 0)
				ListDivisor.add(i);
		}
		return ListDivisor;
	}
}

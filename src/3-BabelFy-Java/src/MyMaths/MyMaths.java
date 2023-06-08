package MyMaths;

import java.util.ArrayList;
import java.util.List;


public class MyMaths
{
	public static void main (String[] args)
	{
		// Test functions
		System.out.println("PPCM 6 & 10 : " + StdOperations.PPCM(6, 10));
		System.out.println("PGCD 42 & 68 : " + StdOperations.PGCD(42, 68));
		System.out.println("Diviseurs 10 : " + StdOperations.Divisors(10));
		System.out.println("Distribute 24k 8k 20% : " + Distribute(24000, 8000, 20));
		System.out.println("Distribute 23999 8k 20% : " + Distribute(23999, 8000, 20));
		System.out.println("Distribute 26k 8k 20% : " + Distribute(26000, 8000, 20));
		System.out.println("Distribute 28k 8k 20% : " + Distribute(28000, 8000, 20));
		System.out.println("Distribute 28k 8k 10% : " + Distribute(28000, 8000, 10));
	}

	// Try to distribute Number into packs of MaxPack elts (with minimal equality)
	// In some cases, the threshold (%) is used to have min and max inequalities
	// For example, 24.000 into MaxPack 8.000 will give : 8.000, 8.000, 8.000 OK
	//   24000 % 8000 = 0
	// Or, 23.999 into 8.000 (20%) will give : 8.000, 8.000, 7.999 OK
	//   23999 % 8000 = 7999 which is above the min of 6400 (threshold : 8k * 20%)
	// Or, 26.000 into 8.000 (20%) will give : 8.666, 8.666, 8.668 OK
	//   26000 % 8000 = 2000, under the min of 6400 (threshold : 8000 * 20%)
	//   Therefore, 2000 is decomposed and added to the three packs
	//   8.668 is under the max of 9600 (threshold : 8000 * 20%)
	// Or
	public static List<Integer> Distribute(int Number, int MaxPack, int Threshold)
	{
		List<Integer> ListInteger = new ArrayList<>();
		int quotient, remainder, quotient2, remainder2;
		int MaxThreshold, MinThreshold;

		// Error Case 0 : MaxPack at 0 (division by 0)
		if (MaxPack <= 0)
		{
			System.err.println("MaxPack must be positive AND above 0");
			return ListInteger;
		}

		// Error Case 1 : threshold incorrect
		if ((Threshold < 0) || (Threshold > 100))
		{
			System.err.println("Threshold is a percentage (20% ideally) between 0 and 100");
			return ListInteger;
		}

		// Error Case 2 : Number is smaller than MaxPack
		if (Number < MaxPack)
		{
			ListInteger.add(Number);
			return ListInteger;
		}

		quotient = Number / MaxPack;
		remainder = Number % MaxPack;

		// Case 1 : perfect cut
		if (remainder == 0)
		{
			for (int i = 0; i < quotient; i++)
			{
				ListInteger.add(MaxPack);
			}
			return ListInteger;
		}

		MaxThreshold = MaxPack + ((MaxPack * Threshold) / 100);
		MinThreshold = MaxPack - ((MaxPack * Threshold) / 100);

		// Case 2 : Remainder is still within the acceptable range : keep it
		if (remainder > MinThreshold)
		{
			for (int i = 0; i < quotient; i++)
			{
				ListInteger.add(MaxPack);
			}
			ListInteger.add(remainder);
			return ListInteger;
		}

		quotient2 = remainder / quotient;
		remainder2 = remainder % quotient;

		// Case 3 : Remainder can be distributed without exceeding the range
		if ((MaxPack + quotient2 + remainder2) < MaxThreshold)
		{
			for (int i = 0; i < (quotient - 1); i++)
			{
				ListInteger.add(MaxPack + quotient2);
			}
			ListInteger.add(MaxPack + quotient2 + remainder2);
			return ListInteger;
		}

		// Case 4 : Remainder can't be distributed... if we add it with MaxPack,
		//          even after cutting it, it would create too big packs
		//          Let's make smaller packs (by reducing MaxPack by Threshold)
		return (Distribute(Number, MinThreshold, Threshold));
	}
}

package CSVManipulation;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;

import java.util.List;
import java.util.ArrayList;


public class CSVReader
{
	String Filename;
	List<List<String>> Matrix;

	// Open a CSV file
	public CSVReader(String filename)
	{
		File file = new File(filename);

		if (! file.exists())
		{
			System.err.println("Impossible to read file: " + filename);
			Filename = null;
		}
		else
		{
			Filename = filename;
		}
		Matrix = new ArrayList<List<String>>();
	}

	// Copy the matrix
	public List<List<String>> getMatrix()
	{
		return (Matrix);
	}

	// Empty the String[][] matrix
	public void clearMatrix()
	{
		Matrix.clear();
	}

	// Change the file to read/write
	public boolean ChangeFilename(String filename)
	{
		File file = new File(filename);

		if (! file.exists())
		{
			System.err.println("Impossible to read file: " + filename);
			Filename = null;
			return (false);
		}
		Filename = filename;
		return (true);
	}

	// Read the CSV file and put data into the Matrix
	public void ReadCSV(String separator)
	{
		BufferedReader csvReader;

		try
		{
			csvReader = new BufferedReader(new FileReader(Filename));
		}
		catch (FileNotFoundException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
			System.err.println("Error (in ReadCSV) while opening : " + Filename);
			return;
		}

		String row;
		int line = 0;

		try
		{
			while ((row = csvReader.readLine()) != null)
			{
			    String[] data = row.split(separator);
			    //System.out.println("[" + line + "] " + data.length + " : " + data[0]);

			    List<String> TmpLine = new ArrayList<String>();
					for (int col = 0; col < data.length; col++)
					{
						String str = data[col];

						// We copy every column, except the last one if it's empty
						if (! ((col == (data.length - 1)) && (str.trim().isEmpty())))
							TmpLine.add(col, str.trim()); // Set each line
					}
			    Matrix.add(line, TmpLine); // Allocate the line

			    line++;
			}
			csvReader.close();
		}
		catch (IOException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
			System.err.println("Error (in ReadCSV) while processing : " + Filename);
		}
	}


	public static void main(String[] args)
	{
		// TODO Auto-generated method stub
		System.out.println("CSVReader MAIN : ");

		CSVReader MyReader = new CSVReader("Test");

		MyReader.ChangeFilename("myFormalContext.csv");
		MyReader.clearMatrix();
		MyReader.ReadCSV(";");

		List<List<String>> Mat = MyReader.getMatrix();
		System.out.println("0x0 : " + Mat.get(0).get(0));
		System.out.println("0xlen : " + Mat.get(0).get(Mat.get(0).size() - 1) );
		System.out.println("lenx0 : " + Mat.get(Mat.size() - 1).get(0) );
		System.out.println("lenxlen : " + Mat.get(Mat.size() - 1).get(Mat.get(Mat.size() - 1).size() - 1) );

		System.out.println("-----");
		for (int i = 0; i < Mat.size(); i++)
		{
			for (int j = 0; j < Mat.get(i).size(); j++)
			{
				System.out.println("[" + i + "][" + j + "] : " + Mat.get(i).get(j));
			}
			System.out.println("");
		}

		MyReader.clearMatrix();
		System.out.println("clean : " + Mat.size());
	}
}

package CSVManipulation;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

import java.util.ArrayList;
import java.util.List;

public class CSVWriter
{
	String Filename;

	public CSVWriter()
	{
		Filename = null;
	}

	public CSVWriter(String filename)
	{
		Filename = filename;
	}

	public boolean ChangeFilename(String filename)
	{
		Filename = filename;
		return (true);
	}

	public void WriteCSV(List<List<String> > dataList, String separator)
	{
		WriteIntoCSV(dataList, Filename, separator);
	}


	public static void WriteIntoCSV(List<List<String> > tokensArray, String outFile, String separator)
	{
		try
		{
			File file = new File(outFile); // File.separator
			FileWriter csvWriter;

			if (! file.exists())
			{
				File dirs = file.getParentFile();
				if ((dirs != null) && (! dirs.exists()))
					dirs.mkdirs();
				file.createNewFile();
			}

			// Clear file
			csvWriter = new FileWriter(file, false);

			// $csv_array[] = array("$tokens", "$score", "$coherenceScore", "$globalScore", "$synsetId");
			//csvWriter.append("Tokens ; Score ; Coherence Score ; Global Score ; Synset ID\n");

			for (List<String> rowData : tokensArray)
			{
		    csvWriter.append(String.join(separator, rowData));
		    csvWriter.append("\n");
			}

			csvWriter.flush();
			csvWriter.close();
		}
		catch (IOException e)
		{
			e.printStackTrace();
			System.err.println("Can't write CSV output in " + outFile);
		}
	}

	public static void main(String[] args)
	{
		CSVWriter MyWriter = new CSVWriter("Test.csv");

		List<List<String>> MyMatrix = new ArrayList<List<String>>();
		List<String> MyArray = new ArrayList<String>();

		MyArray.add("A");
		MyArray.add("B");
		MyArray.add("C");
		MyMatrix.add(MyArray);
		MyArray = new ArrayList<String>();
		MyArray.add("42");
		MyArray.add("U2");
		MyMatrix.add(MyArray);

		System.out.println("- Lines : " + MyMatrix.size());
		for (int i = 0; i < MyMatrix.size(); i++)
		{
			System.out.println("-- Cols : " + MyMatrix.get(i).size());
			for (int j = 0; j < MyMatrix.get(i).size(); j++)
				System.out.println("[" + i + "][" + j + "] : " + MyMatrix.get(i).get(j));
		}
		System.out.println("");

		MyWriter.WriteCSV(MyMatrix, ";");

		MyMatrix.clear();

		System.out.println("CSV written");
	}

}

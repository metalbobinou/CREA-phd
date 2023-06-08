package CSVProcessing;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.List;

public class CSVWriter
{
	public static void WriteIntoCSV(List<List<String> > TokensArray, String outFile)
	{
		try
		{
			File file = new File(outFile); // File.separator
			FileWriter csvWriter;

			if (! file.exists())
			{
				File dirs = file.getParentFile();
				if (! dirs.exists())
					dirs.mkdirs();
				file.createNewFile();
			}

			csvWriter = new FileWriter(file, false);

			// $csv_array[] = array("$tokens", "$score", "$coherenceScore", "$globalScore", "$synsetId");
			//csvWriter.append("Tokens ; Score ; Coherence Score ; Global Score ; Synset ID\n");

			for (List<String> rowData : TokensArray)
			{
		    csvWriter.append(String.join(";", rowData));
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
}

package FileManagement;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class ExtractFiles
{
	// Extract filenames
	public static List<String> ExtractFilenames(String[] Filename)
	{
		List<String> FileList = new ArrayList<String>();
		int len = Filename.length;

		for (int i = 0; i <= len; i++)
		{
			List<String> tmp = ExtractFilenames(Filename[i]);
			FileList.addAll(tmp);
		}

		return (FileList);
	}

	// Extract filenames
	public static List<String> ExtractFilenames(String Filename)
	{
		List<String> FileList = new ArrayList<String>();

		FileList.add(Filename);

		return (FileList);
	}


	// Extract line by line
	public static List<String> ExtractLines(String Filename)
	{
		List<String> WordList = new ArrayList<String>();

		try (BufferedReader BufReader = new BufferedReader(new FileReader(Filename)))
		{
			// Get each line into a List<String>
			String line;

			while ((line = BufReader.readLine()) != null)
				WordList.add(line);

			return WordList;
		}
		catch (FileNotFoundException e)
		{
			e.printStackTrace();
			return WordList;
		}
		catch (IOException e)
		{
			e.printStackTrace();
			return WordList;
		}
	}


	// Extract line by line
	public static String ExtractString(String Filename)
	{
		String Words = new String();

		try (BufferedReader BufReader = new BufferedReader(new FileReader(Filename)))
		{
			// Get each line into a List<String>
			String line;

			while ((line = BufReader.readLine()) != null)
				Words = Words + " " + line;

			Words = Words.trim();

			return Words;
		}
		catch (FileNotFoundException e)
		{
			e.printStackTrace();
			return Words;
		}
		catch (IOException e)
		{
			e.printStackTrace();
			return Words;
		}
	}
}

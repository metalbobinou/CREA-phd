package Main;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.StringTokenizer;

import com.beust.jcommander.JCommander;

import Args.Args;
import Args.JCommanderArgs;
import MyMaths.MyMaths;
import CSVProcessing.CSVWriter;
import Disambiguate.Disambiguator;
import FileManagement.ExtractFiles;
import FileManagement.FileOutput;

public class Main
{
	public static void main (String[] args)
	{
		JCommanderArgs jct = new JCommanderArgs();
    JCommander.newBuilder()
        .addObject(jct)
        .build()
        .parse(args);

    if (jct.help)
    {
    	PrintUsage();
    	System.exit(0);
    }

    if (! jct.parameters.isEmpty())
    {
      List<String> Files = Args.getFileList(jct.parameters);
      String Lang = Args.getLang(jct.parameters);

      System.out.println("-- BEGIN : " + Lang + " -- "+ new Date());
    	Main.run(Files, Lang);
    	System.out.println("-- END -- " + new Date());
    	System.exit(0);
    }

    PrintUsage();
    System.exit(-1);
	}


	public static void run (List<String> files, String lang)
	{
		Disambiguator Disambiguate = new Disambiguator(lang);
		//List<String> FileList;
		String Words = new String();
		String InputText = new String();
		List<Integer> CharactersPositions, RealCharactersPositions = new ArrayList<>();
		List<String> InputTextList;

		//FileList = ExtractFiles.ExtractFilenames(args);

		// Open and read file
		//for (String file : FileList)
		for (String file : files)
		{
			System.out.println("File: " + file);

			//WordList = ExtractFiles.ExtractLines(file);
			Words = Words + " " + ExtractFiles.ExtractString(file);
			Words = Words.trim();
		}

		// Get a clean text
		System.out.println("Tokenizer: ");
		StringTokenizer token = new StringTokenizer(Words, " ");
		while (token.hasMoreTokens())
		{
			// System.out.println(token.nextToken());
			InputText = InputText + " " + token.nextToken();
		}
		InputText = InputText.trim();

		// Let's create packs of ~8000 characters, with 20% of approximation
		CharactersPositions = MyMaths.Distribute(InputText.length(), 8000, 20);

		// Apply the packs of ~8000 characters on the text, and get the real indexes
		InputTextList = Disambiguator.CutStringIntoStringList(InputText, CharactersPositions, RealCharactersPositions);

		// BabelFy and merge all the "local lines" (pack of ~8000) into one array
		List<List<String> > DefinitionArray = new ArrayList<>();

		for (int pack = 0; pack < InputTextList.size(); pack++)
		{
			List<List<String>> LocalDefinitionArray;
			String LocalText = InputTextList.get(pack);
			int CurFirstPosition = RealCharactersPositions.get(pack);

			// BabelFy the LocalText !
			LocalDefinitionArray = Disambiguate.BabelFyString(LocalText);

			// Now, update the position of the strings (BabelFy got the wrong strlen)
			for (int lineNb = 0; lineNb < LocalDefinitionArray.size(); lineNb++)
			{
				List<String> InLine = LocalDefinitionArray.get(lineNb);
				List<String> OutLine = new ArrayList<String>();

				for (int i = 0; i < InLine.size(); i++)
				{
					String str = InLine.get(i);
					/*
					 * List<String> Line = new ArrayList<String>(); Line.add(Token);
					 * Line.add(Double.toString(score));
					 * Line.add(Double.toString(coherenceScore));
					 * Line.add(Double.toString(globalScore));
					 * Line.add(tfFrag.toString()); Line.add(synsetID);
					 * DefinitionList.add(Line);
					 */

					// Should be 5 :
					switch (i)
					{
					case 0: // Token
					case 1: // score
					case 2: // coherenceScore
					case 3: // globalScore
						OutLine.add(str);
						break;
					case 4: // tfFrag / Place of fragment
						String NewStr;
						int commaIndex;
						int OldFirst, OldLast;
						int NewFirst, NewLast;

						commaIndex = str.indexOf(",");
						OldFirst = new Integer(str.substring(1, commaIndex));
						OldLast = new Integer(
								str.substring(commaIndex + 2, str.length() - 1));
						NewFirst = OldFirst + CurFirstPosition;
						NewLast = OldLast + CurFirstPosition;

						/*
						 * System.out.print(OldFirst); System.out.print(" ");
						 * System.out.print(OldLast); System.out.print(" [");
						 * System.out.print(CurFirstPosition); System.out.println("]");
						 *
						 * System.out.print(NewFirst); System.out.print(" ");
						 * System.out.println(NewLast);
						 */

						NewStr = new String("(" + NewFirst + ", " + NewLast + ")");
						OutLine.add(NewStr);
						break;
					case 5: // synsetID / bn:ID
						OutLine.add(str);
						break;
					default:
						OutLine.add(str);
					}
				}
				DefinitionArray.add(OutLine);
			}
		}
		CSVWriter.WriteIntoCSV(DefinitionArray, FileOutput.BuildOutputName(files.get(0)));
	}


	public static void PrintUsage()
	{
		String str = "Usage:\n"
				+ "java -jar BabelFyFiles.jar Language Files\n\n"
				+ "args :\n"
				+ "-h --help (print this help)\n"
				+ "FR EN ..."
				+ "file1 file2 ... (merge the files and get their babelfy contexts)\n\n"
				+ "Example :\n"
				+ "java -jar BabelFyFiles.jar FR file1 file2 file3";
		System.out.println(str);
	}
}

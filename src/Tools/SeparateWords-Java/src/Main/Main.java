package Main;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.StringTokenizer;

import com.beust.jcommander.JCommander;

import Args.JCommanderArgs;
import CSVProcessing.CSVWriter;
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
		System.out.println("-- BEGIN -- " + new Date());
		Main.run(jct.parameters);
		System.out.println("-- END -- " + new Date());
		System.exit(0);
	    }

	PrintUsage();
	System.exit(-1);
    }


    public static void run (List<String> files)
    {
	List<List<String> > DefinitionArray = new ArrayList<>();
	String Words = new String();

	for (String file : files)
	    {
		System.out.println("File: " + file);

		//WordList = ExtractFiles.ExtractLines(file);
		Words = Words + " " + ExtractFiles.ExtractString(file);
		Words = Words.trim();
	    }

	StringTokenizer token = new StringTokenizer(Words, " ");
	while (token.hasMoreTokens())
	    {
		List<String> line = new ArrayList<String>();
		String CurTok = token.nextToken();

		CurTok = CurTok.toLowerCase();
		CurTok = CurTok.trim();

		// System.out.println(token.nextToken());
		line.add(CurTok);
		line.add("1");
		line.add("1");
		line.add("1");
		line.add(CurTok);
		DefinitionArray.add(line);
	    }

	CSVWriter.WriteIntoCSV(DefinitionArray, FileOutput.BuildOutputName(files.get(0)));
    }


    public static void PrintUsage()
    {
	String str = "Usage:\n"
	    + "java -jar SeparateWordsFiles.jar [args]\n\n"
	    + "args :\n"
	    + "-h --help (print this help)\n"
	    + "file1 file2 ... (merge the files and get their babelfy contexts)\n\n"
	    + "Example :\n"
	    + "java -jar SeparateWordsFiles.jar file1 file2 file3";
	System.out.println(str);
    }
}

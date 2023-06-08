package Main;

import java.util.Date;
import java.util.List;

import com.aspose.pdf.Document;
import com.aspose.pdf.TextAbsorber;
import com.beust.jcommander.JCommander;

import Args.Args;
import Args.JCommanderArgs;
import FileManagement.FileOutput;

public class Main
{

    public static void main(String[] args)
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

	    System.out.println("-- BEGIN -- " + new Date());
	    Main.run(Files);
	    System.out.println("-- END -- " + new Date());
	    System.exit(0);
	}

	PrintUsage();
	System.exit(-1);
    }

    public static void run (List<String> InputFiles)
    {
	for (String InFile : InputFiles)
	{
	    Document pdfDocument = new Document(InFile);
	    TextAbsorber textAbsorber = new TextAbsorber();
	    String OutFile = FileOutput.BuildOutputName(InFile);
	    String extractedText;

	    pdfDocument.getPages().accept(textAbsorber);
	    extractedText = textAbsorber.getText();

	    FileOutput.WriteStringToFile(OutFile, extractedText);
	}
    }

    public static void PrintUsage()
    {
	String str = "Usage:\n"
	    + "java -jar PDFContentExtractor.jar Files.pdf\n\n"
	    + "args :\n"
	    + "-h --help (print this help)\n"
	    + "file1 file2 ... \n\n"
	    + "Example :\n"
	    + "java -jar PDFContentExtractor.jar file1.pdf file2.pdf";
	System.out.println(str);
    }

}

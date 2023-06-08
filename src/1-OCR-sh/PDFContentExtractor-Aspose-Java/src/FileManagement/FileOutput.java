package FileManagement;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

public class FileOutput
{
	public static String BuildOutputName(String InputFileName)
	{
		File file = new File(InputFileName);
		String OutFile = new String();

		String prefix = "out_";
		String suffix = ".txt";

		file = file.getAbsoluteFile();

		String dirname = file.getParent();
		String basename = file.getName();

		OutFile = dirname + File.separator + prefix + basename + suffix;

		return (OutFile);
	}

	public static void WriteStringToFile(String OutputFileName, String Text)
	{
		try
		{
			PrivateWriteStringToFile(OutputFileName, Text);
		}
		catch (IOException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	private static void PrivateWriteStringToFile(String OutputFileName, String Text) throws IOException
	{
		File file = new File(OutputFileName);        
    FileWriter fileWriter;
		
    if (! file.exists())
    {
    	File dirs = file.getParentFile();
    	if (! dirs.exists())
    		dirs.mkdirs();
    	file.createNewFile();
    }

    fileWriter = new FileWriter(file, false);

    fileWriter.append(Text);
    fileWriter.flush();
    fileWriter.close();
	}
}

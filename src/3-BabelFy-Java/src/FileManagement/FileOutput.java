package FileManagement;

import java.io.File;

public class FileOutput
{
	public static String BuildOutputName(String InputFileName)
	{
		File file = new File(InputFileName);
		String OutFile = new String();

		String prefix = "out_";
		String suffix = ".csv";

		file = file.getAbsoluteFile();

		String dirname = file.getParent();
		String basename = file.getName();

		OutFile = dirname + File.separator + prefix + basename + suffix;

		return (OutFile);
	}
}

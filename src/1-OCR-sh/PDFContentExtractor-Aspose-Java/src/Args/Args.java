package Args;

import java.util.ArrayList;
import java.util.List;

public class Args
{
	public static List<String> getFileList(List<String> args)
	{
		List<String> Files = new ArrayList<>();

		for (int i = 0; i < args.size() ; i++)
		{
			Files.add(args.get(i));
		}
		return (Files);
	}

	public static String getLang(List<String> args)
	{
		String Lang;

		if (args.size() > 0)
			Lang = args.get(0);
		else
			Lang = "";

		return (Lang);
	}
}

package Args;

import java.util.List;

import com.beust.jcommander.Parameter;
import com.beust.jcommander.internal.Lists;

public class JCommanderArgs
{
	@Parameter
  public List<String> parameters = Lists.newArrayList();

	@Parameter(names={"--help", "-h"}, description = "Print help")
	public boolean help = false;

	/*
	@Parameter(names = "-files", description = "Filenames to process")
	public List<String> files = new ArrayList<>();
	*/
}

namespace ChalkPlusPlus;

public class Config(ConfigFileSchema configFile)
{
	public bool instantFill = configFile.instantFill;
	public int modeSelectKey = configFile.modeSelectKey;
}

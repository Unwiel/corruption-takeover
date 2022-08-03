package;

import openfl.Lib;

class GlobalVideo
{
	private static var video:VideoHandler;
	private static var webm:WebmHandler;
	public static var isWebm:Bool = false;
	public static var isAndroid:Bool = false;
	public static var daAlpha1:Float = 0.2;
	public static var daAlpha2:Float = 1;

	public static function setVid(vid:VideoHandler):Void
	{
		video = vid;
	}
	
	public static function getVid():VideoHandler
	{
		return video;
	}
	
	public static function setWebm(vid:WebmHandler):Void
	{
		webm = vid;
		isWebm = true;
	}
	
	public static function getWebm():WebmHandler
	{
		return webm;
	}
	
	public static function get():Dynamic
	{
		if (isWebm)
		{
			return getWebm();
		} else {
			return getVid();
		}
	}
	
	
}

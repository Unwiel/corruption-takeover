package;

#if (android && MODS_ALLOWED)
import android.Tools;
import android.Permissions;
import android.PermissionsList;
#end
import lime.app.Application;
import openfl.events.UncaughtErrorEvent;
import openfl.utils.Assets as OpenFlAssets;
import openfl.Lib;
import haxe.CallStack.StackItem;
import haxe.CallStack;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;

/**
 * ...
 * @author: Saw (M.A. Jigsaw)
 */

using StringTools;

class SUtil
{
	#if android 
	private static var aDir:String = null; // android dir
	#end

	public static function getPath():String
	{
		#if android 
		if (aDir != null && aDir.length > 0)
			return aDir;
		else
			return aDir = Tools.getExternalStorageDirectory() + '/' + '.' + Application.current.meta.get('file') + '/';
		#else
		return '';
		#end
	}

	public static function doTheCheck()
	{
		#if android 
		if (!Permissions.getGrantedPermissions().contains(PermissionsList.READ_EXTERNAL_STORAGE) || !Permissions.getGrantedPermissions().contains(PermissionsList.WRITE_EXTERNAL_STORAGE))
		{
			Permissions.requestPermissions([PermissionsList.READ_EXTERNAL_STORAGE, PermissionsList.WRITE_EXTERNAL_STORAGE]);
			SUtil.applicationAlert('Permissions', "if you accepted the permissions all good if not expect a crash" + '\n' + 'Press Ok to see what happens');//shitty way to stop the app
		}

		if (Permissions.getGrantedPermissions().contains(PermissionsList.READ_EXTERNAL_STORAGE) || Permissions.getGrantedPermissions().contains(PermissionsList.WRITE_EXTERNAL_STORAGE))
		{
			if (!FileSystem.exists(Tools.getExternalStorageDirectory() + '/' + '.' + Application.current.meta.get('file') + '/'))
				FileSystem.createDirectory(Tools.getExternalStorageDirectory() + '/' + '.' + Application.current.meta.get('file') + '/');
				
            if (!FileSystem.exists(SUtil.getPath() + 'assets/videos'))
				FileSystem.createDirectory(SUtil.getPath() + 'assets/videos');
				
			if (FileSystem.exists(SUtil.getPath() + 'assets/videos')) 
		        SUtil.copyContent(Paths.video('oneshotcut'), SUtil.getPath() + Paths.video('oneshotcut'));
			
		}
		#end
	}

	public static function gameCrashCheck()
	{
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);
	}

	static function onCrash(e:UncaughtErrorEvent):Void
	{
		var errMsg:String = "";
		var path:String;
		var callStack:Array<StackItem> = CallStack.exceptionStack(true);
		var dateNow:String = Date.now().toString();

		dateNow = dateNow.replace(" ", "_");
		dateNow = dateNow.replace(":", "'");

		for (stackItem in callStack)
		{
			switch (stackItem)
			{
				case FilePos(s, file, line, column):
					errMsg += file + " (line " + line + ")\n";
				default:
					Sys.println(stackItem);
			}
		}

		errMsg += "\nUncaught Error: " + e.error;
		#if MODS_ALLOWED
		if (!FileSystem.exists(SUtil.getPath() + "crash/"))
			FileSystem.createDirectory(SUtil.getPath() + "crash/");

		File.saveContent(path, errMsg + "\n");
		#end

		Sys.println(errMsg);

		Application.current.window.alert(errMsg, "Error!");
		Sys.exit(1);
	}

	private static function applicationAlert(title:String, description:String)
	{
		Application.current.window.alert(description, title);
	}

	private static function openLinkAndClose()
	{
		CoolUtil.browserLoad('https://youtu.be/zjvkTmdWvfU');
		Sys.exit(1);
	}

	#if android
	public static function saveContent(fileName:String = 'file', fileExtension:String = '.json', fileData:String = 'you forgot something to add in your code')
	{
		#if (android && MODS_ALLOWED)
                if (!FileSystem.exists(SUtil.getPath() + "saves")){
                        FileSystem.createDirectory(SUtil.getPath() + "saves");
                }

                File.saveContent(SUtil.getPath() + "saves/" + fileName + fileExtension, fileData);
                SUtil.applicationAlert("Done Action :)", "File Saved Successfully!");
                #elseif android
                openfl.system.System.setClipboard(fileData);
                SUtil.applicationAlert("Done Action :)", "Data Saved to Clipboard Successfully!");
                #end
	}

	public static function saveClipboard(fileData:String = 'you forgot something to add in your code')
	{
		openfl.system.System.setClipboard(fileData);
		SUtil.applicationAlert('Done!', 'Data Saved to Clipboard Successfully!');
	}

	public static function copyContent(copyPath:String, savePath:String)
	{
		if (!FileSystem.exists(savePath))
			File.saveBytes(savePath, OpenFlAssets.getBytes(copyPath));
	}
	#end
}
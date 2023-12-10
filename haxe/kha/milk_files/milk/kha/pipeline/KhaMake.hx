package milk.kha.pipeline;

import milk.pipeline.Pipeline;
import milk.pipeline.IPipelineStep;
import milk.pipeline.ExecutionContext;

import milk.kha.Types.EKhaGraphicsAPI;
import milk.kha.Types.ETargetPlatform;
import milk.kha.Types.EVisualStudioVersion;

import milk.kha.Document.KhaDoc;
import milk.kha.Document.KhaSDKDoc;
import milk.kha.Document.KhaKromDoc;

import milk.haxe.HaxeModule;
import milk.haxe.Types.HaxeDoc;
import milk.util.HXMLDocument.HXMLBlock;

import hx.files.*;

class KhaMake implements IPipelineStep
{
	public var project:KhaProject;

	var doc:KhaDoc;

	public var khaPath:String;
	public var khaProjectFile:String;

	public var graphicsAPI:EKhaGraphicsAPI = EKhaGraphicsAPI.Default;
	public var targetPlatform:ETargetPlatform = ETargetPlatform.Krom;

	public var hxmlPath:String;

	public var output:String;
	public var mainClass:String;

	var isNativeBuild:Bool;
	var noCompilation:Bool;
	var debugBuild:Bool;

	var vs:EVisualStudioVersion;

	public function new()
	{
	}

	public function setup(context:ExecutionContext):Void
	{
	}

	public function execute(context:ExecutionContext):Void
	{
		// execute khamake
		var cmds:Array<String> = [];

		cmds.push(Path.of(khaPath).join('make.js').toString());
		
		// output
		cmds.push('--to ${output}');

		// main class
		cmds.push('--main ${mainClass}');

		if(targetPlatform != ETargetPlatform.Empty)
		{
			cmds.push(getTargetName(targetPlatform));
		}

		if(isNativeBuild)
		{
			if(noCompilation == false)
			{
				cmds.push('--compile');
			}

			if(debugBuild)
			{
				cmds.push('--debug');
			}

			if(graphicsAPI != EKhaGraphicsAPI.Default)
			{
				cmds.push('--graphics ${graphicsAPI.getName().toLowerCase()}');
			}

			if(vs != EVisualStudioVersion.VS2017)
			{
				cmds.push('--visualstudio ${vs.getName().toLowerCase()}');
			}
		}

		Sys.println('Executing KhaMake ${targetPlatform}/${graphicsAPI}');

		Sys.setCwd(Path.of(khaProjectFile).parent.toString());
		Sys.command('node', cmds);
	}

	private function getTargetName(target:ETargetPlatform):String
	{
		if(target == ETargetPlatform.DebugHTML5)
		{
			return "debug-html5";
		}
	
		return target.getName().toLowerCase();
	}
}
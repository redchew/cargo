package milk.kha.pipeline;

import milk.pipeline.Pipeline;
import milk.pipeline.IPipelineStep;
import milk.pipeline.ExecutionContext;

import milk.kha.Types.EKhaGraphicsAPI;
import milk.kha.Types.ETargetPlatform;
import milk.kha.Types.EVisualStudioVersion;

import hx.files.*;

class KromLauncher implements IPipelineStep
{
	public var project:KhaProject;
	
	var khaPath:String;
	public var kromPath:String;

	public var platform:ETargetPlatform;

	var workingDir:String;
	public var outputPath:String;

	var executable:String;

	public function new()
	{
	}

	public function setup(context:ExecutionContext):Void
	{
		this.workingDir = context.project.projectDir;

		if(platform == ETargetPlatform.Windows)
		{
			executable = context.project.projectDoc.name + '.exe';
		}

		if(Path.of(kromPath).exists() == false)
		{
			kromPath = Path.of(workingDir).join(kromPath).toString();
		}
	}

	public function execute(context:ExecutionContext):Void
	{
		if(kromPath == null || Path.of(kromPath).exists() == false)
		{
			kromPath = 'krom';
		}

		var targetPlatformName:String = 'krom';

		if(platform == ETargetPlatform.HTML5)
		{
			targetPlatformName = 'debug-html5';
		}

		var assetPath = Path.of(workingDir).join(outputPath).join(targetPlatformName);
		var resourcePath = Path.of(workingDir).join(outputPath).join('${targetPlatformName}-resources');

		var cmds:Array<String> = [assetPath.toString(), resourcePath.toString()];

		var args = arguable.ArgParser.parse(context.workspace.env.arguments);
		if(args.has('watch'))
		{
			Sys.command('start', ['node', Path.of(khaPath).join('make.js').toString(), 'krom', '--watch']);
		}

		// var executable = Path.of(kromPath).filename;
		// Path.of(kromPath).parent.toDir().setCWD();

		Sys.println(kromPath);
		Sys.println(cmds);
		
		Sys.setCwd(Path.of(kromPath).parent.toString());
		Sys.command(kromPath, cmds.concat(Sys.args()));

		// if(platform == ETargetPlatform.Krom)
		// {
			
		// }
		// else if(platform == ETargetPlatform.HTML5)
		// {
		// 	Sys.command('start', ['electron', Path.of(outputPath).join('debug-html5').toString()]);
		// }
		// else if(platform == ETargetPlatform.Windows)
		// {
		// 	Path.of(outputPath).join(platform.getName().toLowerCase()).toDir().setCWD();
		// 	Sys.command(executable);
		// }
	}
}
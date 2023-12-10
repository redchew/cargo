package milk.heaps.pipeline;

import milk.Document.ProjectDoc;
import milk.Environment.EPlatform;
import milk.pipeline.IPipelineStep;
import milk.pipeline.ExecutionContext;
import milk.haxe.HaxeModule;
import haxe.Template;
import hx.files.*;

class HeapsWebRunner implements IPipelineStep
{
	var outputPath:String;

	public function new()
	{
	}

	public function setup(context:ExecutionContext):Void
	{
		if(context.workspace.modules.exists('haxe'))
		{
			var module:HaxeModule = cast context.workspace.modules.get('haxe');
			outputPath = module.outputPath.toString();
		}
	}

    public function execute(context:ExecutionContext):Void
	{
		var projectDoc:ProjectDoc = cast context.project.projectDoc.project;

		var templateFile:Path = context.workspace.getModuleRootPath('heaps');
		templateFile = templateFile.join('template').join('html5').join('index.html');

		var templateDoc:Dynamic = context.workspace.moduleDocuments.get('heaps').html5;
		if(templateDoc != null && templateDoc.template != null)
		{
			var templatePath:String = cast templateDoc.template;
			templateFile = context.workspace.getModuleRootPath('heaps').join(templatePath);
		}

		var settings:Dynamic = { appName:projectDoc.name };
		var template:Template = new Template (templateFile.toFile().readAsString());

		var htmlFile = Path.of(outputPath).parent.join('index.html');
		htmlFile.toFile().writeString(template.execute(settings));

		Log.info("Launching Heaps ...");

		var args = arguable.ArgParser.parse(context.workspace.env.arguments);
		
		if(context.workspace.env.platform == EPlatform.Windows)
		{
			if(args.has('edge'))
			{
				Log.info('Opening ${htmlFile.toString()} with Microsoft Edge');
				Sys.command('start', ['microsoft-edge:file:///${htmlFile.toString()}']);
			}
			else if(args.has('chrome'))
			{
				Log.info('Opening ${htmlFile.toString()} with Chrome');
            	Sys.command('start', ['chrome', htmlFile.toString()]);
			}
        }
		else if(context.workspace.env.platform == EPlatform.Mac)
		{
			if(args.has('chrome'))
			{
				Log.info('Opening ${htmlFile.toString()} with Chrome');
				Sys.command('open', ["-a", "Google Chrome" , htmlFile.toString()]);
			}
		}
	}
}
package milk.heaps;

import milk.Workspace;
import milk.Project;
import milk.module.IModule;
import milk.module.ModuleDescriptor;
import milk.pipeline.Pipeline;
import milk.haxe.HaxeModule;
import milk.haxe.Types.HaxeDoc;
import milk.heaps.Types.HeapsDoc;
import milk.heaps.pipeline.HeapsWebRunner;
import hx.files.*;

@milk({module:'heaps'})
class HeapsModule implements IModule
{
	public function new() {}
	
    public function register():ModuleDescriptor
    {
        var descriptor = {
            name: 'heaps'
        };

        return descriptor;
	}
	
	public function setup(workspace:Workspace, project:Project):Void
	{
		var doc:HeapsDoc = null;

		if(project.projectDoc.heaps != null)
		{
			doc = cast project.projectDoc.heaps;
		}

		if(workspace.modules.exists('haxe'))
		{
			var haxeModule:HaxeModule = cast workspace.modules.get('haxe');

			if(doc != null)
			{
				if(doc.asset != null && doc.asset.path != null)
				{
					var assetPath = Path.of(project.projectDir).join(doc.asset.path);
					haxeModule.hxml.addDefine('resourcesPath=${assetPath}');
				}

				if(doc.resource != null && doc.resource.path != null)
				{
					var resourcePath = Path.of(project.projectDir).join(doc.resource.path);
					haxeModule.hxml.addDefine('resourcesPath=${resourcePath}');
				}

				haxeModule.hxml.addDefine('windowSize=${doc.width}x${doc.height}');
			}
		}
	}

	public function build(workspace:Workspace, project:Project, pipeline:Pipeline):Void
	{
		var args = arguable.ArgParser.parse(workspace.env.arguments);
		var useWebRunner:Bool = args.has('run');
		
		var haxeDoc:HaxeDoc = cast project.projectDoc.haxe;
		if(haxeDoc != null)
		{
			if(haxeDoc.target.toLowerCase() != 'js')
			{
				useWebRunner = false;
			}
		}

		if(useWebRunner)
		{
			pipeline.addStep(new HeapsWebRunner());
		}
	}
}
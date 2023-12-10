package milk.defold;

import milk.Workspace;
import milk.Project;
import milk.Document.ProjectDoc;
import milk.module.IModule;
import milk.pipeline.Pipeline;
import milk.pipeline.step.SysCommand;
import milk.util.HXMLDocument.HXMLBlock;
import milk.haxe.HaxeModule;
import milk.defold.Types.DefoldDoc;
import hx.files.*;

import hx.strings.*;
using hx.strings.Strings;

@milk({module:'defold'})
class DefoldModule implements IModule
{
	public function setup(workspace:Workspace, project:Project):Void
	{
		var defoldDoc:DefoldDoc = cast project.projectDoc.defold;
		
		if(defoldDoc == null)
		{
			return;
		}

        var hxModule:HaxeModule = cast workspace.modules.get('haxe');
        if(hxModule != null)
        {
			var block:HXMLBlock = hxModule.hxml.getBlock(0);

			for(pkg in defoldDoc.packages)
			{
				hxModule.hxml.addMacro('include("${pkg}")');
			}

			block.output = Path.of(project.projectDir).join('main.lua').toString();
			block.output = block.output.replaceAll('\\', '/');
        }
	}

	public function build(workspace:Workspace, project:Project, pipeline:Pipeline):Void
	{

	}
}
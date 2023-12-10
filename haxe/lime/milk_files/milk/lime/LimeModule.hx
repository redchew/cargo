package milk.lime;

import milk.module.Module;
import milk.pipeline.Pipeline;
import milk.lime.pipeline.LimeMakeStep;

import milk.haxe.HaxeModule;

@milk({module:'lime'})
class LimeModule extends Module
{
    public override function setup(workspace:Workspace, project:Project):Void
    {
        // haxe
        workspace.setBlackboard('haxe.compiler', 'lime');

        var hxModule:HaxeModule = cast workspace.modules.get('haxe');
        if(hxModule != null)
        {
            hxModule.noCompilation = true;
        }
    }

    public override function build(workspace:Workspace, project:Project, pipeline:Pipeline):Void
    {
        pipeline.addStep(new LimeMakeStep());
    }
}
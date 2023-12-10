package milk.nme;

import milk.module.Module;
import milk.pipeline.Pipeline;

import milk.nme.pipeline.NMEMakeStep;

@milk({module:'nme'})
class NMEModule extends Module
{
    public override function setup(workspace:Workspace, project:Project):Void
    {
    }

    public override function build(workspace:Workspace, project:Project, pipeline:Pipeline):Void
    {
        pipeline.addStep(new NMEMakeStep());
    }
}
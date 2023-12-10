 package milk.kha;

import milk.Workspace;
import milk.Project;
import milk.module.Module;
import milk.pipeline.Pipeline;
import milk.pipeline.IPipelineStep;

import milk.util.DynamicHelper; 

import milk.haxe.HaxeModule;
import milk.haxe.Types.HaxeDoc;
import milk.util.HXMLDocument.HXMLBlock;

import milk.kha.Types.ETargetPlatform;
import milk.kha.Document.KhaDoc;

import milk.kha.pipeline.KhaProjectWriter;
import milk.kha.pipeline.KhaMake;
import milk.kha.pipeline.KromLauncher;

import hx.files.*;

@milk({module:'kha'})
class KhaModule extends Module
{
    var doc:KhaDoc;

    var docs:Array<HaxeDoc> = [];
    var hxml:milk.util.HXMLDocument = new milk.util.HXMLDocument();

	var stagePath:String;

    var khaSDK:String;
    var platform:ETargetPlatform;

    public override function setup(workspace:Workspace, project:Project):Void
    {
        // disable haxe compilation
        var haxeModule:milk.haxe.HaxeModule = cast workspace.modules.get('haxe');
        if(haxeModule != null)
        {
            haxeModule.noCompilation = true;
        }

        // SDK
        doc = cast workspace.moduleDocuments.get('kha').kha;

        if(project.projectDoc.kha != null)
        {
            DynamicHelper.merge(doc, project.projectDoc.kha);
        }
    }

    public override function build(workspace:Workspace, project:Project, pipeline:Pipeline):Void
    {
        var args = arguable.ArgParser.parse(workspace.env.arguments);

        var haxeModule:HaxeModule = cast workspace.modules.get('haxe');
        var block:HXMLBlock = haxeModule.hxml.getBlock(0);

        var khaProject:KhaProject = {
            name:project.projectDoc.project.name,
            sources:block.sources,
            mainclass:block.mainClass,
            libraries:block.libraries,
            definitions:block.definitions,
            extras:block.extras,
            width:doc.width,
            height:doc.height,
            assets:doc.assets,
        };

        // write khafile.js
        var khafilePath:Path = Path.of(project.projectDir).join('khafile.js');

        if(args.has('staged'))
        {
            var khaStagePath:Path = workspace.getStageDirectory(project).join('kha');
            khafilePath = khaStagePath.join('khafile.js');
        }

        var writerStep:KhaProjectWriter = new KhaProjectWriter();
        writerStep.project = khaProject;
        writerStep.pathToWrite = khafilePath.toString();
        writerStep.localLibraryPath = doc.library;
        pipeline.addStep(writerStep);  

        var compileKhaProject:Bool = doc.noCompilation;
        if(args.has('compile'))
        {
            compileKhaProject = true;
        }

        if(compileKhaProject)
        {
            var sdkPath:String = doc.sdk.path;
            
            if(args.has('kha'))
            {
                var _path:Path = Path.of(args.get('kha').value);
                
                if(_path.exists())
                {
                    sdkPath = _path.toString(); 
                }
                else
                {
                    _path = Path.of(project.projectDir).join(args.get('kha').value);

                    if(_path.exists())
                    {
                        sdkPath = _path.toString();
                    }
                }
            }

            var makeStep:KhaMake = new KhaMake();
            makeStep.project = khaProject;
            makeStep.khaPath = sdkPath;
            makeStep.khaProjectFile = khafilePath.toString();
            pipeline.addStep(makeStep);
        }

        if(args.has('krom'))
        {
            var kromStep:KromLauncher = new KromLauncher();
            kromStep.project = khaProject;
            kromStep.platform = ETargetPlatform.Krom;
            kromStep.outputPath = 'build';
            kromStep.kromPath = args.get('krom').value;
            pipeline.addStep(kromStep); 
        }
    }
}
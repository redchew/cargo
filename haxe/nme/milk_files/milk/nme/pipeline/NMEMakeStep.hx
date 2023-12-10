package milk.nme.pipeline;

import milk.pipeline.Pipeline;
import milk.pipeline.IPipelineStep;
import milk.pipeline.ExecutionContext;

import milk.haxe.HaxeModule;

import milk.nme.Types.AssetDoc;

import hx.files.*;
import hx.files.File.FileCopyOption;

import haxe.xml.Fast;

class NMEMakeStep implements IPipelineStep
{
    public function new()
    {
    }

    public function setup(context:ExecutionContext):Void
    {
    }

    public function execute(context:ExecutionContext):Void
    {
        var root = Xml.createElement('xml');

        var doc:Dynamic = context.project.projectDoc.nme;
        
        if(doc == null) {

            Log.warn('Needs definition block for NME in project');
            return;
        }

        // project
        var docProject:Dynamic = doc.project;
        if(docProject == null) {
            Log.warn('Invalid project definition');
            return;
        }
        var xmlProject:Xml = Xml.createElement('project');
        // root.addChild(xmlProject);
        root = xmlProject;

        // project.meta
        var docMeta:Dynamic = docProject.meta;
        if(docMeta == null) {
            return;
        }

        var xmlMeta:Xml = Xml.createElement('meta');
        xmlProject.addChild(xmlMeta);

        for(field in Reflect.fields(docMeta))
        {
            xmlMeta.set(field, cast(Reflect.field(docMeta, field), String));
        }

        // project.app
        var docApp:Dynamic = docProject.app;
        if(docApp == null) {
            return;
        }
        var xmlApp:Xml = Xml.createElement('app');
        xmlProject.addChild(xmlApp);

        for(field in Reflect.fields(docApp))
        {
            if(field == 'path')
            {
                xmlApp.set(field, Path.of(context.project.projectDir).join(cast(Reflect.field(docApp, field), String)).toString());
                continue;
            }

            xmlApp.set(field, cast(Reflect.field(docApp, field), String));
        }

        if(context.project.projectDoc.project != null)
        {
            if(context.project.projectDoc.project.output != null)
            {
                xmlApp.set('path', Path.of(context.project.projectDir).join(cast(context.project.projectDoc.project.output, String)).toString());
            }
        }

        if(docProject.assets != null)
        {
            for(fieldAsset in Reflect.fields(docProject.assets))
            {
                var xmlAsset:Xml = Xml.createElement('assets');
                xmlProject.addChild(xmlAsset);

                var docAsset:Dynamic = Reflect.field(docProject.assets, fieldAsset);
                for(fieldOpt in Reflect.fields(docAsset))
                {
                    var value:String = cast Reflect.field(docAsset, fieldOpt);
                    
                    if(fieldOpt == 'path')
                    {
                        value = Path.of(context.project.projectDir).join(value).toString();
                    }

                    xmlAsset.set(fieldOpt, value);
                }

                // var docAsset:AssetDoc = cast Reflect.field(docProject.assets, fieldAsset);
                // if(docAsset != null)
                // {
                //     if(docAsset.path != null)
                //     {
                //         xmlAsset.set('path', Path.of(context.project.projectDir).join(docAsset.path).toString());
                //     }
                //     if(docAsset.rename != null)
                //     {
                //         xmlAsset.set('rename', docAsset.rename);
                //     }
                //     if(docAsset.include != null)
                //     {
                //         xmlAsset.set('include', docAsset.include);
                //     }
                //     if(docAsset.exclude != null)
                //     {
                //         xmlAsset.set('exclude', docAsset.exclude);
                //     }
                //     if(docAsset.type != null)
                //     {
                //         xmlAsset.set('type', docAsset.type);
                //     }
                // }
            }
        }

        // project.window
        var docWindow:Dynamic = docProject.window;
        if(docWindow == null) return;
        var xmlWindow:Xml = Xml.createElement('window');
        xmlProject.addChild(xmlWindow);

        for(field in Reflect.fields(docWindow))
        {
            xmlWindow.set(field, '${Reflect.field(docWindow, field)}');
        }

        // haxe
        var hxModule:HaxeModule = cast context.workspace.modules.get('haxe');
        if(hxModule == null) return;

        for(src in hxModule.hxml.getBlock(0).sources)
        {
            var xmlSrc:Xml = Xml.createElement('source');
            xmlSrc.set('path', src);
            xmlProject.addChild(xmlSrc);
        }

        for(lib in hxModule.hxml.getBlock(0).libraries)
        {
            var xmlLib:Xml = Xml.createElement('haxelib');
            xmlLib.set('name', lib);
            xmlProject.addChild(xmlLib);
        }

        // write
        var stageDirectory:Path = context.workspace.getStageDirectory(context.project).join('nme');
        var scriptFile:Path = stageDirectory.join('build.nmml');
        
        if(scriptFile.parent.exists() == false)
        {
            scriptFile.parent.toDir().create();
        }

        var f:File = scriptFile.toFile();
        f.writeString('<?xml version="1.0" encoding="utf-8"?>\n' + haxe.xml.Printer.print(root, true));

        var platform:String = context.workspace.targetPlatform.getName();

        // if(context.workspace.env.arguments.contains('platform'))
        // {
        //     platform = context.workspace.env.arguments.get('platform').value;
        // }

        var command:String = 'build';

        // if(context.workspace.env.args.has('cmd'))
        // {
        //     command = context.workspace.env.args.get('cmd').value;
        // }

        var cmdArgs:Array<String> = ['run', 'nme', scriptFile.toString(), command, platform];
        Sys.command('haxelib', cmdArgs);
    }
}
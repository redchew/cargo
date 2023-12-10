package milk.lime.pipeline;

import milk.pipeline.Pipeline;
import milk.pipeline.IPipelineStep;
import milk.pipeline.ExecutionContext;
import milk.haxe.HaxeModule;
import milk.lime.Types.LimeAssetDoc;

import hx.files.*;
import hx.files.File.FileCopyOption;

import haxe.xml.Fast;

class LimeMakeStep implements IPipelineStep
{
    var limeDoc:Dynamic = {};

    public function new()
    {
    }

    public function setup(context:ExecutionContext):Void
    {
        var deps = context.workspace.collectProjectDependencies(context.project);
        for(dep in deps)
        {
            var moduleDoc = context.workspace.moduleDocuments.get(dep);
            
            if(moduleDoc == null)
            {
                continue;
            }

            if(moduleDoc.lime != null)
            {
                milk.util.DynamicHelper.merge(this.limeDoc, moduleDoc.lime);
            }
        }

        if(context.project.projectDoc.lime != null)
        {
            milk.util.DynamicHelper.merge(this.limeDoc, context.project.projectDoc.lime);
        }
    }

    public function execute(context:ExecutionContext):Void
    {
        var root = Xml.createElement('xml');

        // var doc:Dynamic = context.project.projectDoc.lime;
        // if(doc == null) return;

        var doc:Dynamic = limeDoc;

        // project
        var docProject:Dynamic = doc.project;
        if(docProject == null) return;
        var xmlProject:Xml = Xml.createElement('project');
        // root.addChild(xmlProject);
        root = xmlProject;

        // project.meta
        var docMeta:Dynamic = docProject.meta;
        if(docMeta == null) return;
        var xmlMeta:Xml = Xml.createElement('meta');
        xmlProject.addChild(xmlMeta);

        for(field in Reflect.fields(docMeta))
        {
            xmlMeta.set(field, cast(Reflect.field(docMeta, field), String));
        }

        // project.app
        var docApp:Dynamic = docProject.app;
        if(docApp == null) return;
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
                        if(value.indexOf('$') != -1)
                        {
                            value = context.workspace.resolveString(value);
                        }
                        else
                        {
                            value = Path.of(context.project.projectDir).join(value).toString();
                        }
                    }

                    xmlAsset.set(fieldOpt, value);
                }

                // var docAsset:LimeAssetDoc = cast Reflect.field(docProject.assets, fieldAsset);
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
            xmlWindow.set(field, Reflect.field(docWindow, field).toString());
        }

        // icon
        var docIcon:Dynamic = docProject.icon;
        if(docIcon != null)
        {
            var xmlIcon:Xml = Xml.createElement('icon');
            xmlIcon.set('path', docIcon.path);
            xmlProject.addChild(xmlIcon);
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

        // lib from HXML
        for(lib in hxModule.hxml.getBlock(0).libraries)
        {
            var xmlLib:Xml = Xml.createElement('haxelib');

            var tokens:Array<String> = lib.split(':');
            xmlLib.set('name', tokens[0]);

            // split version from 'libname:version'
            if(tokens.length > 1)
            {
                xmlLib.set('version', tokens[1]);
            }

            xmlProject.addChild(xmlLib);
        }

        // lib
        var docHaxeLib:Dynamic = docProject.haxelib;
        if(docHaxeLib != null)
        {
            for(field in Reflect.fields(docHaxeLib))
            {
                var xmlLib:Xml = Xml.createElement('haxelib');
                xmlLib.set('name', field);

                var libField:Dynamic = Reflect.field(docHaxeLib, field);
                if(libField != null && libField.version != null)
                {
                    xmlLib.set('version', libField.version);
                }

                xmlProject.addChild(xmlLib);
            }
        }

        // write
        var stageDirectory:Path = context.workspace.getStageDirectory(context.project).join('lime');
        var scriptFile:Path = stageDirectory.join('project.xml');
        
        if(scriptFile.parent.exists() == false)
        {
            scriptFile.parent.toDir().create();
        }

        scriptFile.toFile().writeString('<?xml version="1.0" encoding="utf-8"?>\n' + haxe.xml.Printer.print(root, true));

        var platform:String = context.workspace.targetPlatform.getName();
        var platformOverride:String = context.workspace.getVar('lime.platform');
        if(platformOverride != null)
        {
            platform = platformOverride;
        }

        var command:String = 'build';
        var cmds = context.workspace.getDefinedCommands();
        if(cmds.length > 0)
        {
            command = cmds[0];
        }

        Sys.setCwd(scriptFile.parent.toString());

        var cmd:String = 'haxelib';

        // SDK        
        var sdk:String = context.workspace.getVar('haxe.sdk');
        if(sdk != null)
        {
            cmd = Path.of(sdk).join(cmd).toString();
        }

        var args:Array<String> = ['run', 'lime', command, platform];
        args.push('-static');
        Sys.command(cmd, args);
        return;
        
        trace(command);
        trace(platform);
        trace(['run', 'lime', command, platform, '-static'].concat(context.workspace.env.arguments));
        Sys.command(cmd, ['run', 'lime', command, platform, '-static'].concat(context.workspace.env.arguments));
    }
}
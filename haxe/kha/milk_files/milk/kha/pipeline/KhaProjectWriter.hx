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
using hx.strings.Strings;

class KhaProjectWriter implements IPipelineStep
{
    public var project:KhaProject;
    public var pathToWrite:String;

    public var localLibraryPath:String;

    public function new()
    {
    }

    public function setup(context:ExecutionContext):Void
    {
        var args = arguable.ArgParser.parse(context.workspace.env.arguments);
        if(args.has('lib'))
        {
            localLibraryPath = args.get('lib').value;
        }

        var libPath:Path = Path.of(localLibraryPath);
        if(libPath.exists() == false)
        {
            libPath = context.workspace.getModuleRootPath('kha').join(localLibraryPath);
        }

        if(libPath.exists() == false)
        {
            libPath = Path.of(context.project.projectDir).join(localLibraryPath);
        }

        if(libPath.exists())
        {
            localLibraryPath = libPath.toString();
        }
    }

	public function execute(context:ExecutionContext):Void
    {
        var stringBuf:StringBuf = new StringBuf();

        stringBuf.add("let project = new Project('" + project.name + "');\n");

        if(localLibraryPath != null)
        {
            stringBuf.add("project.localLibraryPath = '" + localLibraryPath.replaceAll('\\', '\\\\') + "';\n");
        }

        if(project.assets != null)
        {
            for(assetPath in project.assets)
            {
                stringBuf.add("project.addAssets('" + assetPath.replaceAll('\\', '\\\\') + "');\n");
            }
        }

        if(project.sources != null)
        {
            for(sourcePath in project.sources)
            {
                stringBuf.add("project.addSources('" + sourcePath.replaceAll('\\', '\\\\') + "');\n");
            }
        }

        if(project.libraries != null)
        {
            for(lib in project.libraries)
            {
                stringBuf.add("project.addLibrary('" + lib + "');\n");
            }
        }

        if(project.definitions != null)
        {
            for(def in project.definitions)
            {
                stringBuf.add("project.addDefine('" + def + "');\n");
            }
        }

        if(project.mainclass != null) {
            stringBuf.add('project.addParameter("-main ${project.mainclass}");\n');
        }

        if(project.extras != null)
        {
            for(param in project.extras)
            {
                stringBuf.add("project.addParameter('" + param + "');\n");
            }
        }

        if(project.width != null)
        {
            stringBuf.add('project.windowOptions.width = ${project.width};\n');
        }

        if(project.height != null)
        {
            stringBuf.add('project.windowOptions.height = ${project.height};\n');
        }

        stringBuf.add("resolve(project);\n");

        // write to file
        if(Path.of(pathToWrite).parent.exists() == false)
        {
            Path.of(pathToWrite).parent.toDir().create();
        }

        Path.of(pathToWrite).toFile().writeString(stringBuf.toString());
    }
}
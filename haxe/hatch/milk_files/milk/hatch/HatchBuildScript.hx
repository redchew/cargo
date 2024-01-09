package milk.hatch;

import milk.Workspace;
import milk.Project;

import milk.pipeline.ExecutionContext;
import milk.script.IScript;

import hatch.Reader;
import hatch.Evaluator;
import hatch.HaxeEnv;
import hatch.HatchValue.HatchValue;
import hatch.HatchValueUtil;
import hatch.Prelude;

import hx.files.*;

class HatchBuildScript implements IScript
{
    var scriptLoaded:Bool = false;

    public function init(workspace:Workspace, project:Project):Void
    {
        var scriptFile = Path.of(project.projectDir).join('project.scm');

        if(scriptFile.exists())
        {
            Reader.init();
            HaxeEnv.init();
            Evaluator.init();

            loadPrelude();

            Evaluator.prelude.bind('workspace', HatchValueUtil.fromHaxe(workspace));
            Evaluator.prelude.bind('project', HatchValueUtil.fromHaxe(project));

            switch(Reader.read(scriptFile.toFile().readAsString()))
            {
                case Left(e): trace('READ ERROR $e');
                
                case Right(ListV([SymbolV('quit')])):
                {
                    trace('\nGOOD BYE!\n');
                }

                case Right(v): 
                try
                {
                    var result:HatchValue = Evaluator.eval( Evaluator.prelude, v );
                    #if debug
                    // Log.error(result);
                    #end
                    scriptLoaded = true;
                }
                catch (e:Dynamic)
                {
                    trace('EVAL ERROR for ${v},  $e');
                }
            }
        }
    }

    private static function loadPrelude()
    {
        for (def in Prelude.coreFunctions)
        {
            switch (Reader.read( def.form))
            {
                case Left(e): throw 'Read error loading prelude in form named ${def.name}';
                case Right(v): Evaluator.prelude.bind( def.name, Evaluator.eval( Evaluator.prelude, v));
            }
        }
    }

	public function invokeFunction(funcName:String):Void
    {
        if(scriptLoaded)
        {
            switch(Reader.read('(${funcName})'))
            {
                case Left(e): trace('READ ERROR $e');
                
                case Right(ListV([SymbolV('quit')])):
                {
                    trace('\nGOOD BYE!\n');
                }

                case Right(v): 
                try
                {
                    Evaluator.eval( Evaluator.prelude, v );
                }
                catch (e:Dynamic)
                {
                    trace('EVAL ERROR for ${v},  $e');
                }
            }
        }
    }
}